import logging
from messages import publish, configure

API_VERSION = '7'

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    logger.info('Version %s', API_VERSION)
    logger.info('Received event: {}'.format(event))

    token = event.get('token')
    if token != event['IFTTT_TOKEN']:
        logger.error("Request token (%s) does not match expected", token)
        raise Exception("Invalid request token")

    command = event.get('command', None)
    device = event['device']
    configure(event['MQTT_URL'])
    if command:
        publish('action', device=device, action=command)
    else:
        publish('event', device=device, event=event['event'])
    return dict(version=API_VERSION, command=command)
