import logging
from publish_message import publish, configure

API_VERSION = '7'

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    logger.info('Version %s', API_VERSION)
    logger.info('Received event: {}'.format(event))

    ifttt_token = event['env']['IFTTT_TOKEN']
    mqtt_url = event['env']['MQTT_URL']

    token = event['token']
    if token != ifttt_token:
        logger.error("Request token (%s) does not match expected", token)
        raise Exception("Invalid request token")

    action = event['action']
    configure(mqtt_url)
    publish('action', action=action)
    return dict(version=API_VERSION, action=action)
