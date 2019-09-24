const mongoose = require('mongoose')

const ChatSchema = mongoose.Schema({
    _id: {
        type: String,
        require: true
    },    
    owner: {
        type: String,
        require: true
    },
    messages: [{
        owner: String,
        body: {
            type: String,
            require: true
        }
    }]
})

module.exports = mongoose.model('Chat', ChatSchema)