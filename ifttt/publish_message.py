import json
import logging
import paho.mqtt.publish as mqtt_publish
import mqtt_config

logging.basicConfig(level=logging.WARNING)
logger = logging.getLogger('messages')


def publish(mtype, **payload):
    payload['type'] = mtype
    logger.info('publish topic=%s payload=%s', mqtt_config.TOPIC, payload)
    mqtt_publish.single(mqtt_config.TOPIC,
                        payload=json.dumps(payload),
                        qos=1,
                        retain=True,
                        hostname=mqtt_config.hostname,
                        auth=mqtt_config.auth,
                        port=mqtt_config.port,
                        client_id='')
