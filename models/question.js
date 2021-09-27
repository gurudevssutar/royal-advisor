const mongoose = require('mongoose');
const Schema = mongoose.Schema

const questionSchema = new Schema(
    {
        algoName: {
            type: String
        },
        preemption: {
            type: Boolean
        },
        questionText: {
            type: String
        },
        questionImg: {
            type: String
        },
        questionNum: {
            type: Number
        },
        questionOptions: [{
            type: Schema.Types.ObjectId,
            ref: 'questionoptions'
        }],
        answer: [{
            qRef: {
                type: Schema.Types.ObjectId,
                ref: 'questionoptions'
            },
            startTime: {
                type: Number
            },
            endTime: {
                type: Number
            },
        }]
    },
    {
        timestamps: false
    }
);

module.exports = mongoose.model('question', questionSchema)