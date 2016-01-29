from collections import namedtuple
import logging
import json
from urlparse import urlparse
import paho.mqtt.publish as mqtt_publish

logging.basicConfig(level=logging.WARNING)
logger = logging.getLogger('messages')


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


def publish(topic, **payload):
    logger.info('publish topic=%s payload=%s', topic, payload)
    mqtt_publish.single(topic,
                        payload=json.dumps(payload),
                        qos=1,
                        retain=True,
                        hostname=mqtt_config.hostname,
                        auth=mqtt_config.auth,
                        port=mqtt_config.port,
                        client_id='')


def publish_command(device=None, **payload):
    payload['type'] = 'action'
    publish(device, **payload)


# deviceName deviceId timestamp isStateChange source value event
def publish_event(payload):
    topic = '/%(site)s/%(room)s/%(deviceId)s/%(event)s/%(value)s' % payload
    publish(topic, **payload)
