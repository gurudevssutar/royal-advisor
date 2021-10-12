const QuestionOptions = require('../models/questionOptions')
const Question = require('../models/question')

exports.getQuestion = async (req, res, next) => {

    try{
        const questionId = req.params.questionId;
        const question = await Question.findById(questionId)
                                .populate('questionOptions')
                                .populate('answer.qRef')

        if(question == null){
            res.status(404).json({
                error: 'Resource Does Not Exist',
                message: 'Not Found'
            });
            return;
        }

        res.status(200).json({
            message: 'Question Fetched Successfully',
            question: question
        });
    }catch(err){
        if(!err.statusCode){
            err.statusCode = 502;
        }
        if(!err.data){
            err.data = 'Unable to fetch question';
        }
        next(err);
    }
};


exports.getQuestionList = async (req, res, next) => {

    try{
        const questions = await Question.find().select('questionNum').sort('questionNum')

        // console.log(questions)

        if(questions == null){
            res.status(404).json({
                error: 'Resources Does Not Exist',
                message: 'Not Found'
            });
            return;
        }

        res.status(200).json({
            message: 'Questions Fetched Successfully',
            questions: questions
        });
    }catch(err){
        if(!err.statusCode){
            err.statusCode = 502;
        }
        if(!err.data){
            err.data = 'Unable to fetch questions';
        }
        next(err);
    }
};