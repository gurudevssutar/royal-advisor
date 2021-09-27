const express = require('express');
const { body } = require('express-validator')

const router = express.Router();

const User = require('../models/user')
const authController = require('../controllers/auth')

router.put('/signup', [
    body('email')
        .isEmail()
        .withMessage('Please Enter a Valid Email.')
        .custom((value, { req }) => {
            return User.findOne({email: value})
                        .then(userDoc => {
                            if(userDoc) {
                                return Promise.reject('Email Address already Registered.')
                            }
                        })
        })
        .normalizeEmail(),
    body('password').trim().isLength({ min: 5 }),
    body('name').trim().notEmpty(),
    ],
    authController.signup
    )

router.post('/login', authController.login);

module.exports = router;