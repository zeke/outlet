express  = require("express")
https    = require("https")
request  = require("request")
cors     = require("cors")
mongoose = require("mongoose")
Repo     = require("../lib/repo")

mongoose.connect process.env.MONGOHQ_URL, (err, res) ->
  console.log "error connecting to mongo" if err

app = express(
  express.logger()
  express.cookieParser()
  express.bodyParser())

app.get "/plugins", cors(), (req, res) ->
  Repo.find (err, repos) ->
    res.jsonp repos

app.get "/plugins/:user/:repo", cors(), (req, res) ->
  key = "#{req.params.user}/#{req.params.repo}"
  url = "https://api.github.com/repos/#{key}"

  request {url:url, json:true}, (err, response, body) ->

    res.jsonp(200, body) if err or response.statusCode == 404

    repo = new Repo
      name: body.name
      description: body.description
      forks: body.forks
      watchers: body.watchers
      open_issues: body.open_issues
      owner_login: body.owner.login
      owner_gravatar_id: body.owner.gravatar_id
      html_url: body.html_url
      git_url: body.git_url

    repo.save (err, repo) ->
      res.jsonp(400, {error: err}) if err
      res.jsonp repo

module.exports = app