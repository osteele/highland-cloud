from publish_message import publish
import logging
from config import config

IFTTT_TOKEN = config['IFTTT_TOKEN']

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    logger.info('Version 6')
    logger.info('Received event: {}'.format(event))

    token = event.get('token')
    if token != IFTTT_TOKEN:
        logger.error("Request token (%s) does not match expected", token)
        raise Exception("Invalid request token")

    action = event['action']
    publish('action', action=action)
    return "action: %s" % action
