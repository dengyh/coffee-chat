express = require 'express'
router = do express.Router
User = require '../models/user'
Message = require '../models/message'

# GET home page.
router.get '/', (req, res) ->
    if req.cookies 
        if req.cookies.user_id
            User.findById req.cookies.user_id, (userErr, user) ->
                if userErr then res.render 'index', { visited: false }
                res.render 'index', { visited: true, user: user }
        else res.render 'index', { visited: false }
    else res.render 'index', { visited: false }

module.exports = router;