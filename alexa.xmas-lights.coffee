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
      switch intent
        when ['TurnOn', 'TurnOff', 'Pause', 'Resume']
          console.info 'intent', intent
      res.json
        version: '1.0'
        response:
          outputSpeech:
            type: 'PlainText'
            text: 'okay'
          card:
            type: 'Simple'
            title: 'Xmas Lights'
            content: 'Some commands are "Tell the Christmas tree lights to turn on".'
          shouldEndSession: false
