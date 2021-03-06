mocha = require("mocha")
should = require("should")
mongoose = require("mongoose")
Plugin = require("../lib/plugin")

before (done) ->
  mongoose.connect process.env.MONGO_TEST_URL, (err, res) ->
    done()

describe "Plugin", ->
  describe "fetch()", ->

    it "creates a plugin if the repo exists on github", (done) ->
      Plugin.fetch "heroku/heroku-fork", (err, plugin) ->
        plugin.should.have.property('repo')
        plugin.repo.should.have.property('name', 'heroku-fork')
        done()

    it "inherits all the desired attributes", (done) ->
      Plugin.fetch "heroku/heroku-fork", (err, plugin) ->
        plugin.repo.should.have.property('name', 'heroku-fork')
        plugin.repo.should.have.property('owner_login', 'heroku')
        done()

    it "doesn't create a plugin that's already been fetched"

    it "fails if the repo doesn't exist", (done) ->
      Plugin.fetch "cake/never-there", (err, plugin) ->
        err.should.be.a('string')
        err.should.equal('not found')
        should.not.exist(plugin)
        done()

    it "fails if the repo doesn't contain an init.rb file", (done) ->
      Plugin.fetch "zeke/queriac", (err, plugin) ->
        err.should.be.a('string')
        err.should.equal('init.rb file not found in repository')
        should.not.exist(plugin)
        done()
