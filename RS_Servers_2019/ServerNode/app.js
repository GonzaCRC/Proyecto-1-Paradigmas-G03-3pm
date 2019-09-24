const express = require('express')
const app = express()
const mongoose = require('mongoose')
const multer = require('multer');
const upload = multer();
const cors = require('cors')
require('dotenv/config')

app.use(cors())
app.use(upload.none())

const chatsRoute = require('./routes/chats')

app.use('/chats', chatsRoute)

app.get('/', (req, res) => {
    res.send('We are on home')
})

mongoose.connect(process.env.DB_CONNECTION,
    { useNewUrlParser: true, useUnifiedTopology: true }, 
    () => console.log('connected to DB!')
)
app.listen(3001)