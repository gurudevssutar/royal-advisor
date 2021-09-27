const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const path = require('path');
const { v4: uuidv4 } = require('uuid')
const multer = require('multer');


require('dotenv').config();

// const feedRoutes = require('./routes/feed');
const questionRoutes = require('./routes/question');
// const authRoutes = require('./routes/auth');

const app = express();
app.use(bodyParser.json());

const fileStorage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'images')
    },
    filename: (req, file, cb) => {
        cb(null ,uuidv4() + '-'+ file.originalname)
    }
});

const fileFilter = (req, file, cb) => {
    if(file.mimetype === 'image/png' ||
       file.mimetype === 'image/jpg' || 
       file.mimetype === 'image/jpeg' ||
       file.mimetype === 'image/jfif' ||
       file.mimetype === 'image/gif'
       ){
        cb(null , true);
    }else{
        cb(null , false);
    }
}

app.use(multer({
    storage: fileStorage,
    fileFilter: fileFilter
}).single('image')
)

app.use('/images', express.static(
    path.join(
        __dirname,
        'images'
    )
))

const PORT = process.env.PORT || 8080
//Creating general middleware for all routes to overide cors and help send response to any server
app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*'); //second param is name of domain
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    // console.log('got request ')
    next();
});

// app.use('/feed', feedRoutes);
app.use('/question', questionRoutes);
// app.use('/auth', authRoutes);

app.use((error, req, res, next) => {
    console.log(error);
    const status = error.statusCode || 500;
    const message = error.message;
    const data = error.data;
    res.status(status).json({
        message: message,
        data: data
    })
});

mongoose.connect(process.env.MONGO_URI).then(result => {
        app.listen(PORT, () => console.log(`Server Running on Port: http://localhost:${PORT}`));
    }).catch((error) => console.log(`Unable to connect to database`, error));

// mongoose.set('useNewUrlParser', true);
// mongoose.set('useFindAndModify', false);
// mongoose.set('useCreateIndex', true);

// app.listen(PORT);