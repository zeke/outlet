mongoose = require("mongoose")

repoSchema = new mongoose.Schema
  name: String
  description: String
  forks: Number
  watchers: Number
  open_issues: Number
  owner_login: String
  owner_gravatar_id: String
  html_url: String
  git_url: String

repoSchema.methods.speak = ->
  greeting = "hello from repo"#(if @name then "Meow name is " + @name else "I don't have a name")
  console.log greeting

module.exports = mongoose.model("Repo", repoSchema)