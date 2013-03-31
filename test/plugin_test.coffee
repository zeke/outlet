mocha = require("mocha")
should = require("should")
Plugin = require("../lib/plugin")

describe "Plugin", ->
  describe "fetch()", ->

    it "fetches the plugin if the repo exists on github", (done) ->
      Plugin.fetch "heroku/heroku-fork", (err, plugin) ->
        plugin.should.have.property('name', 'heroku-fork')
        done()

    it "fails if the repo doesn't exist"

    it "fails if the repo doesn't contain an init.rb file"