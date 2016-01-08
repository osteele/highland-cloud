ALEXA_APP_IDS = process.env.ALEXA_APP_IDS .split ',' if process.env.ALEXA_APP_IDS

validateParameter = (req, res, pname, validate) ->
  value = req.body?.request?[pname]
  unless value
    console.error "missing value for #{pname}"
    res.status(400).send "missing #{pname}"
  unless validate value
    console.error "invalid value for #{pname}: #{value}"
    res.status(403).send "invalid #{pname}"

exports.validateAlexaRequest = (req, res, next) ->
  console.info req.headers
  return next() unless ALEXA_APP_IDS
  # return validateParameter req, res, 'requestId', (requestId) -> requestId in ALEXA_APP_IDS
  return validateParameter req, res, 'timestamp', (timestamp) -> Math.abs(new Date - new Date timestamp) < 15 * 1000
  return next()
