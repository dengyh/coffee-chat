express = require 'express'
router = do express.Router
Message = require '../models/message'

router
    .post '/', (req, res) ->
        message = new Message
        message.from = req.body.user_id
        message.content = req.body.content
        message.time = do Date.now

        message.save (err) ->
            if err then res.json { success: false }
            res.json
                success: true
                content: message.content
                time: message.time

module.exports = router