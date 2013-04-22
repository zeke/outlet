mongoose = require("mongoose")
request  = require("request")

pluginSchema = new mongoose.Schema
  url: String
  repo: mongoose.Schema.Types.Mixed

pluginSchema.virtual("init_rb_url").get ->
  url = "https://raw.github.com/#{@repo.owner.login}/#{@repo.name}/master/init.rb"
  console.log url
  url

pluginSchema.methods.detectInitFile = (cb) ->
  request @init_rb_url, (err, response, repo) ->
    throw err if err
    return cb(!err and response.statusCode is 200)

pluginSchema.statics.fetch = (gid, cb) ->

  url = "https://api.github.com/repos/#{gid}"

  Plugin.findOne {url: url}, (err, plugin) ->
    throw err if err

    if plugin
      return cb(null, plugin)
    else
      request {url:url, json:true}, (err, response, repo) ->
        throw err if err
        throw new Error("repo not found: #{url}") if response.statusCode == 404

        plugin = new Plugin
          url: url
          repo: repo

        # Check for an init.rb file in the github repo
        plugin.detectInitFile (fileExists) ->
          throw new Error("init.rb file not found in repository") unless fileExists

          # Persist to the database
          plugin.save (err, plugin) ->
            throw err if err
            cb(null, plugin)

Plugin = mongoose.model("Plugin", pluginSchema)

module.exports = Plugin