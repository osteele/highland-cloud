messages = require './messages'

exports.handler = (event, context) ->
  console.log 'event.session.application.applicationId=' + event.session?.application?.applicationId
  # unless event.session.application.applicationId is 'amzn1.echo-sdk-ams.app.[unique-value-here]'
  #    return context.fail 'Invalid Application ID'

  # if event.session.new
  #   onSessionStarted {requestId: event.request.requestId}, event.session

  switch event.request.type

    when 'LaunchRequest'
      handleLaunchRequest event, context

    when 'IntentRequest'
      handleIntentRequest event, context

    when 'SessionEndedRequest'
      handleSessionEndRequest event
      context.succeed()

    else
      console.error "Unknown request type: #{request.type}"
      context.fail "Unknown request type: #{request.type}"

handleLaunchRequest = (event, context) ->
  context.succeed
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

handleIntentRequest = (event, context) ->
  intent = event.request.intent.name
  if action = IntentActions[intent]
    console.info 'intent', intent, action
    messages.sendMessage {type: 'action', action}, (err, ok) ->
      if err
        console.error 'rabbit.publish failed'
        console.error err
        context.fail 'message connection failed'
      else
        context.succeed
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
  else
    console.error "Unknown intent: #{intent}"
    context.fail "Unknown intent: #{intent}"

handleSessionEndRequest = (event, context) ->
  console.log 'sesson end'

IntentActions =
  TurnOn   : 'on'
  TurnOff  : 'off'
  Pause    : 'stop'
  Resume   : 'resume'
  NextScene: 'next'
  Spin     : 'spin'
  Reverse  : 'spin'
  SlowDown : 'slower'
  SpeedUp  : 'faster'
