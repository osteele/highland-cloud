url = require 'url'
mqtt = require 'mqtt'

logger = console

MQTT_URL = require('./config').MQTT_URL
MQTT_TOPIC = 'xmas-lights'

withMqttConnection = (mqttUrl, onConnect) ->
  urlObj = url.parse mqttUrl
  if urlObj.auth
    [username, password] = (urlObj.auth or ':').split ':', 2
    username = urlObj.path.slice(1) + ':' + username if urlObj.pathname
    urlObj.pathname = null
    urlObj.auth = username + ':' + password if username
    urlObj = url.format urlObj
  logger.info 'connect', mqttUrl
  client = mqtt.connect urlObj
  client.on 'connect', ->
    onConnect client, -> client.end(done)
  client.on 'error', (err) ->
    logger.error err

exports.sendMessage = (payload, done) ->
  payload = JSON.stringify payload or {}
  withMqttConnection MQTT_URL, (client) ->
    client.publish MQTT_TOPIC, payload, {qos: 1, retain: true}, done
