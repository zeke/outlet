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
npm install
foreman start
```

## License

MIT