express = require 'express'
path = require 'path'
favicon = require 'static-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost:27017/chat'

routes = require './routes/index'
users = require './routes/users'
messages = require './routes/messages'

app = do express

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use do favicon
app.use logger 'dev'
app.use do bodyParser.json
app.use do bodyParser.urlencoded
app.use do cookieParser
app.use express.static path.join(__dirname, 'public')

app.use '/', routes
app.use '/user', users
app.use '/message', messages

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

# error handlers

###
 development error handler
 will print stacktrace
###
if app.get('env') is 'development'
    app.use (err, req, res, next) ->
        res.status err.status || 500
        res.render 'error',
            message: err.message
            error: err

###
 production error handler
 no stacktraces leaked to user
 ###
app.use (err, req, res, next) ->
    res.status err.status || 500
    res.render 'error',
        message: err.message
        error: {}

module.exports = app
