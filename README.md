# Outlet

Outlet is a registry of plugins for the Heroku CLI.

## API

Outlet has a simple HTTP JSON API.

### Get all plugins

```sh
curl -H "Content-Type: application/json" \
https://outlet.herokuapp.com/plugins
```

### Get a specific plugin

```sh
curl -H "Content-Type: application/json" \
https://outlet.herokuapp.com/plugins/ddollar/heroku-redis-cli
```

### Publish a plugin

```sh
# Usage: publish_plugin heroku/heroku-deploy
#
function publish_plugin() {
  user=$(echo "$1" | cut -d'/' -f1)
  repo=$(echo "$1" | cut -d'/' -f2)
  curl \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"user\":\"$user\",\"repo\":\"$repo\"}" \
  https://outlet.herokuapp.com/plugins
}
```

## Development

```sh
brew install mongodb node   # (if you don't already have 'em)
npm install                 # install dependencies
mongod&                     # run mongo in the background
foreman start               # run node server with foreman
```

Pop open [localhost:5000](http://localhost:5000).

## License

MIT

 
 
 
 
 
 
 
 
