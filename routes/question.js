const express = require('express');
const { body } = require('express-validator')

const isAuth = require('../middleware/is-auth')

const router = express.Router();

const questionController = require('../controllers/question')

// GET /question/all
router.get('/all', questionController.getQuestion);

module.exports = router;