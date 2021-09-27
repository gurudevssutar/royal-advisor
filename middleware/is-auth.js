const jwt = require('jsonwebtoken');
const User = require('../models/user')

module.exports = (req, res, next) => {
    const temp = req.get('Authorization');
    if(temp){
        const token = temp.split(' ')[1];
        let decodedToken;
        try{
            decodedToken = jwt.verify(token, 'my-super-secret-key-long-one');
        }catch(err){
            err.statusCode = 500;
            throw err;
        }
        if(!decodedToken){
            const error = new Error('Not Authenticated');
            error.statusCode = 401;
            error.data = 'Authentication Failure, No Token provided'
            throw error
        }

        req.userId = decodedToken.userId;
        console.log('User isauth decodedtoken result', decodedToken)
        User.findOne({_id: decodedToken.userId})
            .then(user => {
                console.log('User isAuth then result ', user)
                if(!user){
                    const error = new Error('User does not exist, Please login again');
                    error.statusCode = 401;
                    error.data = 'Authentication Failure'
                    throw error
                }
                next() 
            })
            .catch(err => {
                if(!err.statusCode){
                    err.statusCode = 500;
                }
                next(err);
            })
    }else{
        const error = new Error('Not Authenticated');
        error.statusCode = 401;
        error.data = 'Authentication Failure, No Token provided'
        throw error
    }
}