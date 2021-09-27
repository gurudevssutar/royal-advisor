const { validationResult } = require('express-validator')
const fs = require('fs');
const path = require('path')

const Post = require('../models/post')
const User = require('../models/user')

exports.getPosts = async (req, res, next) => {
    const currentPage = req.query.page || 1;
    const perPage = 2;
    let totalItems;

    //Code without async await
    // Post.find()
    //     .countDocuments()
    //     .then(count => {
    //         totalItems = count;
    //         return  Post.find()
                        // .skip((currentPage-1)*perPage)
                        // .limit(perPage)
    //     })
    //     .then(posts => {
            // res.status(200).json({
            //     message: 'Posts Fetched Successfully',
            //     posts: posts,
            //     totalItems: totalItems
            // });
    //     })
    //     .catch(err => {
            // if(!err.statusCode){
            //     err.statusCode = 502;
            // }
            // next(err);
    //     })
   
    //Code using async await
    try{
        totalItems = await Post.find().countDocuments();
        const posts = await Post.find()
                                .populate('creator')
                                .sort({createdAt: -1})
                                .skip((currentPage-1)*perPage)
                                .limit(perPage)

        res.status(200).json({
            message: 'Posts Fetched Successfully',
            posts: posts,
            totalItems: totalItems
            });
    }catch(err){
        if(!err.statusCode){
            err.statusCode = 502;
        }
        if(!err.data){
            err.data = 'Unable to fetch posts';
        }
        next(err);
    }
};
  
exports.createPost = (req, res, next) => {
    const errors = validationResult(req);
    if(!errors.isEmpty()){
        const error = new Error('Validation Failure, data format not supported.');
        error.statusCode = 422;
        error.data = errors.array();
        throw error
        // return res.status(422).json({message: 'Entered data is not validated.'})
    }
    if(!req.file) {
        const error = new Error('Image not supported.');
        error.statusCode = 422;
        error.data = 'Image not attached'
        throw error
    }
    const title = req.body.title;
    const content = req.body.content;
    // normally on mac and linux only req.file.path is written but on windows we need to replace \\ with /
    const imageUrl = req.file.path.replace("\\","/")

    //Get user id stored at time of isAuth
    const userId = req.userId;
    let creator;

    // Create post in db
    const post = new Post({
        title: title, 
        imageUrl: imageUrl,
        content: content,
        creator: userId,
    });

    post.save()
        .then(result => {
            console.log(`Post Creation On Save Result`, result);
            return User.findById(userId);
        })
        .then(user => {
            if(!user){
                const error = new Error('User not found');
                error.statusCode = 404;
                error.data = 'No user found with that id'
                throw error
            }
            creator = user
            user.posts.push(post);
            return user.save();
        })
        .then(result => {
            //emit for all users, broadcast for all except the user who did this.
            io.getIo().emit('posts', {
                action: 'create',
                post: {...post._doc, creator: {_id: req.userId, name: creator.name}}
            });
            res.status(201).json({
                message: 'Post created successfully!',
                post: post,
                creator: {_id: creator._id, name: creator.name}
            });
        })
        // .then(result => {
        //     console.log(`Post Creation On Save Result`);
        //     console.log(result)
        //     res.status(201).json({
        //         message: 'Post created successfully!',
        //         post: result
        //       });
        // })
        .catch(err => {
            console.log(`Post Creation Error Save`);
            console.log(err)
            // const error = new Error('Validation Failure, data format not supported.');
            // error.statusCode = 502;
            // next(err)
            res.status(502).json({
                message: 'Post Not Created',
                error: err
              });
        });
    
};

exports.getPost = (req, res, next) => {
    const postId = req.params.postId;
    Post.findById(postId)
        .then(post => {
            if(!post){
                const error = new Error('This Post Does Not Exist Anymore');
                error.statusCode = 404;
                throw error
            }
            res.status(200).json({
                message: 'Post Fetched Successfully',
                post: post
            })
        })
        .catch(err => {
            if(!err.statusCode){
                err.statusCode = 502;
            }
            next(err);
        });
};

exports.updatePost =  (req, res, next) => {
    const errors = validationResult(req);
    if(!errors.isEmpty()){
        const error = new Error('Validation Failure, data format not supported.');
        error.statusCode = 422;
        throw error
        // return res.status(422).json({message: 'Entered data is not validated.'})
    }
    const postId = req.params.postId
    const title = req.body.title
    const content = req.body.content
    let imageUrl = req.body.image
    if(req.file) {
        imageUrl = req.file.path.replace("\\","/");
    }
    if(!imageUrl){
        const error = new Error('Image not selected.');
        error.statusCode = 422;
        throw error
    }

    Post.findById(postId)
        .populate('creator')
        .then(post => {
            if(!post){
                const error = new Error('This Post Does Not Exist Anymore');
                error.statusCode = 404;
                error.data = 'Post not found'
                throw error
            }

            //Checking if id of postCreator and id of user matches
            if(post.creator._id.toString() !== req.userId){
                const error = new Error('Not Authorized!');
                error.statusCode = 403;
                error.data = 'Post created by different user cannot edit'
                throw error
            }

            if(imageUrl != post.imageUrl){
                clearImage(post.imageUrl);
            }
            post.title = title;
            post.content = content;
            post.imageUrl = imageUrl;
            return post.save();
        })
        .then(result => {
            io.getIo().emit('posts', {
                action: 'update',
                post: result
            });
            res.status(200).json({message: 'Post Updated Successfully', post: result});
        })
        .catch(err => {
        if(!err.statusCode){
            err.statusCode = 502;
        }
        next(err);
    });
}

const clearImage = filePath => {
    filePath = path.join(__dirname, '..', filePath)
    fs.unlink(filePath, err => {
        if(err){
            console.log('Clear Image error' + filePath)
            console.log(err)
        }
    })
};

exports.deletePost = (req, res, next) => {
    const postId = req.params.postId;
    Post.findById(postId)
        .then(post => {
            if(!post){
                const error = new Error('This Post Does Not Exist Anymore');
                error.statusCode = 404;
                error.data = 'Post not found'
                throw error
            }

            //Check user created that post
            if(post.creator.toString() !== req.userId){
                const error = new Error('Not Authorized!');
                error.statusCode = 403;
                error.data = 'Post created by different user cannot delete'
                throw error
            }

            clearImage(post.imageUrl);
            return Post.findByIdAndRemove(postId);
            //Also need to delete post user relation
        })
        .then(result => {
            console.log('Delete Post Result' , result);
            return User.findById(req.userId);
            
        })
        .then(user => {
            if(!user){
                const error = new Error('User not found');
                error.statusCode = 404;
                error.data = 'No user found with that id'
                throw error
            }
            user.posts.pull(postId);
            return user.save();
        })
        .then(result => {
            io.getIo().emit('posts', {
                action: 'delete',
                post: postId
            });
            res.status(200).json({
                message: 'Deleted Post Successfully'
            })
        })
        // .then(result => {
        //     console.log('Delete Post Result');
        //     console.log(result);
        //     res.status(200).json({
        //         message: 'Deleted Post Successfully',
        //         result: result
        //     })
        // })
        .catch(err => {
            if(!err.statusCode){
                err.statusCode = 502;
            }
            next(err);
        });

}