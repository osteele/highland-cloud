ALEXA_APP_IDS = process.env.ALEXA_APP_IDS .split ',' if process.env.ALEXA_APP_IDS

exports.validateAlexaRequest = (req, res, next) ->
  return next() unless ALEXA_APP_IDS
  {requestId, timestamp} = req.body.request
  return res.status(400).send 'missing requestId' unless requestId
  return res.status(400).send 'missing timestamp' unless timestamp
  return res.status(403).send 'invalid requestId' unless requestId in ALEXA_APP_IDS
  return res.status(403).send 'invalid timestamp' unless Math.abs(new Date - new Date timestamp) < 15 * 1000
  return next()
