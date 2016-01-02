express = require 'express'
bodyParser = require 'body-parser'

app = express()

app.set 'port', process.env.PORT or 5000
app.use bodyParser.json()

app.post '/alexa/xmas-lights', require './alexa.xmas-lights'

app.listen app.get('port'), ->
  console.log "Listening at #{app.get('port')}"
