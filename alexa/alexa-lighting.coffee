# Docs: https://developer.amazon.com/public/binaries/content/assets/html/alexa-lighting-api.html

https = require 'https'
messages = require './messages'

logger = console

handleDiscoveryEvent = (event, context) ->
  # event.header.name is "DiscoverAppliancesRequest"
  # event.payload.accessToken is String

  headers =
    namespace: 'Discovery'
    name: 'DiscoverAppliancesResponse'
    payloadVersion: '1'

  xmasLights =
    applianceId: 'xmas-lights'
    manufacturerName: 'osteele'
    modelName: 'OS01'
    version: 'VER01'
    friendlyName: 'Christmas tree'
    friendlyDescription: 'Christmas Tree lights'
    isReachable: true
    additionalApplianceDetails: {}

  payload =
    discoveredAppliances: [xmasLights]

  result =
    header: headers
    payload: payload

  logger.info 'discovery ->', result
  context.succeed result

handleControlEvent = (event, context) ->
  switch event.header.name
    when 'SwitchOnOffRequest'
      applianceId = event.payload.appliance.applianceId
      # accessToken = event.payload.accessToken.trim()
      logger.info "applianceId=#{applianceId}"

      switch event.payload.switchControlAction
        when 'TURN_ON'
          action = 'on'
        when 'TURN_OFF'
          action = 'off'
        else
          # AdjustNumericalSettingRequest
          context.fail "unknown request name: #{event.header.name}"

      sendResponse = ->
        headers =
          namespace: 'Control'
          name: 'SwitchOnOffResponse'
          payloadVersion: '1'

        payload =
          success: true

        result =
          header: headers
          payload: payload

        logger.info 'control ->', result
        context.succeed result

      messages.sendMessage {type: 'action', action: action}, sendResponse

    else
      context.fail createControlError 'SwitchOnOffRequest', 'UNSUPPORTED_OPERATION', 'Unrecognized operation'

handleSystemEvent = (event, context) ->
  switch event.header.name
    when 'HealthCheckRequest'
      headers =
        namespace: 'System'
        name: 'HealthCheckResponse'
        payloadVersion: '1'

      payload =
        isHealthy: true,
        description: 'The system is currently healthy'

      result =
        header: headers
        payload: payload

      logger.info 'health ->', result
      context.succeed result

    else
      context.fail createControlError 'HealthCheckRequest', 'UNSUPPORTED_OPERATION', 'Unrecognized operation'

createControlError = (name, code, description) ->
  headers =
    namespace: 'Control'
    name: name
    payloadVersion: '1'

  payload =
    exception:
      code: code
      description: description

  result =
    header: headers
    payload: payload

  return result

exports.handler = (event, context) ->
  logger.info 'event =', event
  switch event.header.namespace
    when 'Discovery'
      handleDiscoveryEvent event, context
    when 'Control'
      handleControlEvent event, context
    when 'System'
      handleSystemEvent event, context
    else
      logger.error "Unknown namespace: #{event.header.namespace}"
      context.fail 'Something went wrong'
