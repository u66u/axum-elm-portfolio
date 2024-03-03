# Portfolio frontend

## Usage 

```bash
npm install -g elm elm-spa
```

## running locally

```bash
elm-spa server  # starts this app at http:/localhost:1234
```

### other commands

```bash
elm-spa add    # add a new page to the application
elm-spa build  # production build
elm-spa watch  # runs build as you code (without the server)
elm-spa gen    # build without .js files
```

## Configuration

Remember to specify your backend URL in `src/Config.elm`. This is crucial for your application to connect to the correct server.
