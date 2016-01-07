module.exports = (req, res) ->
  request = req.body.request
  console.log request

  switch request.type

    when 'LaunchRequest'
      res.json
        version: '1.0'
        response:
          outputSpeech:
            type: 'PlainText'
            text: 'The Christmas Tree lights await your command'
          card:
            type: 'Simple'
            title: 'Xmas Lights'
            content: 'Some commands are "Tell the Christmas tree lights to turn on".'
          shouldEndSession: false

    when 'IntentRequest'
      intent = request.intent.name
      if action = IntentActions[intent]
        console.info 'intent', intent, action
        sendMessage {type: 'action', action}, (err, ok) ->
          if err
            console.error 'rabbit.publish failed'
            consle.error err
      else
        console.error "Unknown intent: #{intent}"
        return res.status(500).end()
      res.json
        version: '1.0'
        response:
          outputSpeech:
            type: 'PlainText'
            text: 'okay'
          # card:
          #   type: 'Simple'
          #   title: 'Xmas Lights'
          #   content: 'Some commands are "Tell the Christmas tree lights to turn on".'
          shouldEndSession: true

    when 'SessionEndedRequest'
      res.json
        version: '1.0'

    else
      console.error "Unknown request type: #{request.type}"
      return res.status(500).end()

IntentActions = {TurnOn: 'on', TurnOff: 'off', Pause: 'stop', Resume: 'resume', NextScene: 'next', Spin: 'spin'}

MQTT_URL = process.env.MQTT_URL or process.env.CLOUDMQTT_URL or process.env.CLOUDAMQP_URL or 'mqtt://localhost:1883'
MQTT_TOPIC = 'xmas-lights'

mqtt = require 'mqtt'
url = require 'url'

withMqttConnection = (mqttUrl, fn) ->
  urlObj = url.parse mqttUrl
  if urlObj.auth
    [username, password] = (urlObj.auth or ':').split ':', 2
    username = urlObj.path.slice(1) + ':' + username if urlObj.pathname
    urlObj.pathname = null
    urlObj.auth = username + ':' + password if username
    urlObj = url.format urlObj
  client = mqtt.connect urlObj
  client.on 'connect', ->
    fn client, -> client.end()

sendMessage = (payload) ->
  payload = JSON.stringify payload or {}
  withMqttConnection MQTT_URL, (client, done) ->
    client.publish MQTT_TOPIC, payload, {qos: 1, retain: true}, done
