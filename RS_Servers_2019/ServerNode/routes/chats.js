const express = require('express')
const router = express.Router();
const Chat = require('../models/Chat')
const RiveScript = require('../js/rivescript')

router.get('/', async (req, res) => {
    try {
        const chats = await Chat.find()
        res.json(chats)
    } catch (err) {
        res.json({ message: err })
    }
})

router.get('/:id', async (req, res) => {
    try {
        const chat = await Chat.findById(req.params.id)
        res.json(chat)
    } catch (err) {
        res.json({ message: err })
    }
})
/*
router.delete('/:chatId', async (req, res) => {
    try {
        const removeChat = await Chat.remove({ _id: req.params.chatId })
        res.json(removeChat)
    } catch (err) {
        res.json({ message: err })
    }
})
*/
/*
router.patch('/:chatId', async (req, res) => {
    try {
        const updateChat = await Chat.updateOne(
            { _id: req.params.chatId }, 
            { $set: 
                { text: req.body.text } 
            }
        )
        res.json(updateChat)
    } catch (err) {
        res.json({ message: err })
    }

})
*/
router.post('/', async (req, res) => {

    const formData = JSON.parse(req.body.data)
    const id = formData.id
    const message = formData.body
    const owner = formData.owner

    try {

        const chatCreated = await Chat.findById(id)

        reply(message, async (bot_resp) => {

            if (chatCreated != null) {

                await Chat.updateOne(
                    { _id: id },
                    {
                        $push: { messages: [{ owner: owner, body: message }, { owner: "bot", body: bot_resp }] }
                    }
                )
                
                const updatedChat = await Chat.findById(id)
                res.json(updatedChat)
            }
            else {

                const chat = new Chat({
                    _id: id,
                    owner: owner,
                    messages: [{ owner: owner, body: message }, { owner: "bot", body: bot_resp }]
                })

                const savedChat = await chat.save()
                res.json(savedChat)

            }

        })


    } catch (err) {

        res.json({ message: err })

    }

})

const bot = new RiveScript();
const RIVE_FILE = "./rivescripts/chat_room.rive";
const username = "local-user";
bot.loadFile([RIVE_FILE])
    .then(loading_done)
    .catch(loading_error);
function loading_done() {
    console.log("Bot has finished loading!");
}
function loading_error(error, filename, lineno) {
    console.log("Error when loading files: " + error);
}

function reply(msg, cb) {
    if (!bot) {
        cb(msg)
        return
    }
    bot.sortReplies();
    bot.reply(username, msg).then((resp) => {
        console.log("The bot says: " + resp);
        cb(resp)
    });
}

module.exports = router;