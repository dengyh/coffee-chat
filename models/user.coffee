mongoose = require 'mongoose'
Schema = mongoose.Schema

UserSchema = new Schema(
    name: type: String, required: true, unique: true
    ip: type: String, required: true
)

module.exports = mongoose.model 'User', UserSchema