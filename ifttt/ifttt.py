import logging
import messages

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

    messages.configure(event['MQTT_URL'])

    command = event.get('command', None)
    if command:
        messages.publish_command(device=event['device'], action=command)
    elif event['type'] == 'event':
        messages.publish_event(event['payload'])

    return dict(version=API_VERSION, status='ok')
