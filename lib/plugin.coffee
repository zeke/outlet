mongoose = require("mongoose")
request  = require("request")

pluginSchema = new mongoose.Schema
  url: String, required: true
  name: String, required: true
  description: String
  forks: Number, required: true
  watchers: Number, required: true
  html_url: String, required: true
  git_url: String, required: true
  updated_at: Date, required: true
  owner:
    name: String, required: true
    gravatar_id: String, required: true

# The desired properties from the github API response object
pluginSchema.statics.githubProperties =
  "url name description forks watchers html_url git_url updated_at".split(' ')

# Check for an init.rb file in the github repo
pluginSchema.methods.detectInitFile = (cb) ->
  url = "https://raw.github.com/#{@owner_login}/#{@name}/master/init.rb"
  console.log url
  request url, (err, response, repo) ->
    return cb(!err and response.statusCode is 200)

pluginSchema.statics.fetch = (gid, cb) ->

  url = "https://api.github.com/repos/#{gid}"
  request {url:url, json:true}, (err, response, repo) ->

    # Handle errors
    throw err if err
    throw new Error("not found") if response.statusCode == 404

    # Copy properties from the github response object
    props = {}
    props[prop] = repo[prop] for prop in Plugin.githubProperties
    plugin = new Plugin(props)

    # Check for an init.rb file in the github repo
    plugin.detectInitFile (fileExists) ->
      throw new Error("init.rb file not found in repository") unless fileExists

      # Persist to the database
      plugin.save (err, plugin) ->
        throw err if err
        cb(null, plugin)

Plugin = mongoose.model("Plugin", pluginSchema)

module.exports = Plugin