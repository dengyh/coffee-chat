express = require 'express'
router = do express.Router
User = require '../models/user'
Message = require '../models/message'

# GET users listing.
router
    .post '/', (req, res) ->
        user = new User
        user.name = req.body.name
        user.ip = req.connection.remoteAddress

        user.save (err) ->
            if err then res.json success: false
            res.cookie 'user_id', user._id
            res.json success: true

router
    .get '/:user_id', (req, res) ->
        User.findById req.params.user_id, (err, user) ->
            if err then res.json success: false, name: ''
            res.json success: true, name: user.name

router
    .get '/home/:user_id', (req, res) ->
        User.findById req.params.user_id, (userErr, user) ->
            Message.find from: user, (messageErr, messages) ->
                if userErr or messageErr then res.render 'user',
                    title: 'Error'
                    messages: messages
                res.render 'user',
                    title: user.name,
                    messages: messages

module.exports = router;
