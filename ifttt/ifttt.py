from publish_message import publish
import logging
from config import config

API_VERSION = '7'
IFTTT_TOKEN = config['IFTTT_TOKEN']

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    logger.info('Version %s', API_VERSION)
    logger.info('Received event: {}'.format(event))

    token = event.get('token')
    if token != IFTTT_TOKEN:
        logger.error("Request token (%s) does not match expected", token)
        raise Exception("Invalid request token")

    action = event['action']
    publish('action', action=action)
    return dict(version=API_VERSION, action=action)
