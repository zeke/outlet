express  = require("express")
https    = require("https")
cors     = require("cors")
mongoose = require("mongoose")
Plugin   = require("../lib/plugin")

mongoose.connect process.env.MONGOHQ_URL, (err, res) ->
  console.log "error connecting to mongo" if err

app = express(
  express.logger()
  express.cookieParser()
  express.bodyParser()
)

app.get "/plugins", cors(), (req, res) ->
  Plugin.find (err, plugins) ->
    res.jsonp plugins

app.get "/plugins/:user/:repo", cors(), (req, res) ->
  gid = [req.params.user, req.params.repo].join("/")
  Plugin.fetch gid, (err, plugin) =>
    return res.jsonp(400, {error: err}) if err
    res.jsonp(plugin)

module.exports = app