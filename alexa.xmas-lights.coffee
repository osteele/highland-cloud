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

IntentActions = {TurnOn: 'on', TurnOff: 'off', Pause: 'stop', Resume: 'resume', NextScene: 'next'}

RABBIT_URL = process.env.RABBIT_URL or process.env.CLOUDAMQP_URL

PublicationChannel = null

require('amqplib').connect RABBIT_URL
.then (conn) ->
  conn.createConfirmChannel().then (ch) ->
    PublicationChannel = ch

sendMessage = (content) ->
  buffer = new Buffer JSON.stringify content or {}
  PublicationChannel.publish '', 'lights', buffer,
    contentType: 'application/json'
    persistent : true
