mongoose = require("mongoose")
request  = require("request")

pluginSchema = new mongoose.Schema
  id: String
  name: String
  description: String
  forks: Number
  watchers: Number
  open_issues: Number
  owner_login: String
  owner_gravatar_id: String
  html_url: String
  git_url: String
  updated_at: Date

pluginSchema.statics.githubProperties =
  "name description forks open_issues owner_login owner_gravatar_id html_url git_url updated_at".split(' ')

pluginSchema.statics.fetch = (gid, cb) ->

  url = "https://api.github.com/repos/#{gid}"
  request {url:url, json:true}, (err, response, repo) ->
    return cb(err) if err
    return cb("Not Found") if response.statusCode == 404

    props = {}
    props[prop] = repo[prop] for prop in Plugin.githubProperties

    plugin = new Plugin(props)

    plugin.save (err, plugin) ->
      return cb(err) if err
      cb(null, plugin)

Plugin = mongoose.model("Plugin", pluginSchema)

module.exports = Plugin