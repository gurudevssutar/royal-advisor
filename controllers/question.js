const QuestionOptions = require('../models/questionOptions')
const Question = require('../models/question')

exports.getQuestion = async (req, res, next) => {
    const currentPage = req.query.page || 1;
    const perPage = 2;
    let totalItems;

    try{
        totalItems = await Question.find().countDocuments();
        const posts = await Question.find()
                                .populate('questionOptions')
                                .populate('answer.qRef')
                                // .sort({createdAt: -1})
                                .skip((currentPage-1)*perPage)
                                .limit(perPage)

        res.status(200).json({
            message: 'Questions Fetched Successfully',
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