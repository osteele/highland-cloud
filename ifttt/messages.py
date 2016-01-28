from collections import namedtuple
import logging
import json
from urlparse import urlparse
import paho.mqtt.publish as mqtt_publish

logging.basicConfig(level=logging.WARNING)
logger = logging.getLogger('messages')

TOPIC = 'xmas-lights'


def configure(url_s):
    global mqtt_config
    url = urlparse(url_s)

    hostname = url.hostname
    username = url.username
    password = url.password

    if url.path:
        username = url.path[1:] + ':' + username

    auth = dict(username=username, password=password) if username else None
    port = 1883

    mqtt_config = namedtuple('MqtttConfig', ('hostname', 'auth', 'port'))(hostname, auth, port)


def publish(mtype, **payload):
    payload['type'] = mtype
    logger.info('publish topic=%s payload=%s', TOPIC, payload)
    mqtt_publish.single(TOPIC,
                        payload=json.dumps(payload),
                        qos=1,
                        retain=True,
                        hostname=mqtt_config.hostname,
                        auth=mqtt_config.auth,
                        port=mqtt_config.port,
                        client_id='')
