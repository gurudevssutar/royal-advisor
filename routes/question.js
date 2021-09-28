const express = require('express');
const { body } = require('express-validator')

// const isAuth = require('../middleware/is-auth')

const router = express.Router();

const questionController = require('../controllers/question')

// GET /question/questionId
router.get('/single/:questionId', questionController.getQuestion);

// GET /question/all
router.get('/all', questionController.getQuestionList);


module.exports = router;