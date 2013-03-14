mongoose = require("mongoose")

exports.init = ->
  mongoose.connect process.env.MONGOHQ_URL, (err, res) ->
    console.log "error connecting to mongo" if err

  return mongoose