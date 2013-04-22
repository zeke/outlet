express  = require("express")
https    = require("https")
cors     = require("cors")
mongoose = require("mongoose")
Plugin   = require("../lib/plugin")

mongoose.connect(process.env.MONGOHQ_URL)

app = express()
app.use express.bodyParser()
app.use app.router

app.get "/plugins", cors(), (req, res) ->
  Plugin.find (err, plugins) ->
    return res.jsonp(400, {error: err}) if err
    res.jsonp plugins

app.post "/plugins", cors(), (req, res) ->
  gid = [req.body.user, req.body.repo].join("/")
  Plugin.fetch gid, (err, plugin) =>
    return res.jsonp(400, {error: err}) if err
    res.jsonp(plugin)

app.get "/plugins/:user/:repo", cors(), (req, res) ->
  gid = [req.params.user, req.params.repo].join("/")
  Plugin.fetch gid, (err, plugin) =>
    return res.jsonp(400, {error: err}) if err
    res.jsonp(plugin)

module.exports = app