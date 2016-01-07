express = require 'express'
bodyParser = require 'body-parser'
{validateAlexaRequest} = require './middleware'

app = express()
app.set 'port', process.env.PORT or 5000
app.set 'view engine', 'jade'

app.use bodyParser.json()
app.use express.static 'public'

app.get '/', (req, res) ->
  res.render 'index'

app.get '/privacy', (req, res) ->
  res.render 'privacy'

app.post '/alexa/xmas-lights', validateAlexaRequest, require './alexa.xmas-lights'

app.listen app.get('port'), ->
  console.log "Listening at #{app.get('port')}"
