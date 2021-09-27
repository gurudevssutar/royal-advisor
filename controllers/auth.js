const { validationResult } = require('express-validator')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
// const fs = require('fs');
// const path = require('path')
const User = require('../models/user')

exports.signup = (req, res, next) => {
    const errors = validationResult(req)
    // console.log('controller called 1')
    if(!errors.isEmpty()){
        const error = new Error('Validation Failure, data format not supported.');
        error.statusCode = 422;
        error.data = errors.array();
        throw error
    }
    // console.log('controller called 2')
    const email = req.body.email;
    const name = req.body.name;
    const password = req.body.password;
    bcrypt.hash(password , 12)
          .then(hashedpw => {
              const user = new User({
                  email: email,
                  password: hashedpw,
                  name: name
              });
            //   console.log('user signup')
              return user.save();
          })
          .then(result => {
              console.log('User Signup Save Result' , result)
              res.status(201).json({
                  message: 'User Signed Up Successfully',
                  userId: result._id
              })
          })
          .catch(err => {
            if(!err.statusCode){
                err.statusCode = 500;
            }
            next(err);
          })
}


exports.login = (req, res, next) => {
    const email = req.body.email;
    const password = req.body.password;
    let loadedUser;
    User.findOne({email: email})
        .then(user => {
            if(!user){
                const error = new Error('Invalid Username or Password');
                error.statusCode = 401;
                error.data = 'Authentication Failure'
                throw error
            }
            loadedUser = user;
            return bcrypt.compare(password , user.password)
        })
        .then(isEqual => {
            if(!isEqual){
                const error = new Error('Invalid Username or Password');
                error.statusCode = 401;
                error.data = 'Authentication Failure'
                throw error
            }
            const token = jwt.sign(
                {
                email: loadedUser.email,
                userId: loadedUser._id.toString(),
                password: loadedUser.password
                },
                'my-super-secret-key-long-one', //Secret Signature
                {
                    expiresIn: '10h'
                }
            );

            res.status(200)
                .json({
                    message: 'Login Successfull',
                    token: token,
                    userId: loadedUser._id.toString()
                })
        })
        .catch(err => {
            if(!err.statusCode){
                err.statusCode = 500;
            }
            next(err);
          })

}