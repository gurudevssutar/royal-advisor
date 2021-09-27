const mongoose = require('mongoose');
const Schema = mongoose.Schema

const questionOptionsSchema = new Schema(
    {
        name: {
            type: String
        },
        arrivalTime: {
            type: Number
        },
        burstTime: {
            type: Number
        },
        optionImage: {
            type: String
        }
    },
    {
        timestamps: false
    }
);

module.exports = mongoose.model('questionoptions', questionOptionsSchema)