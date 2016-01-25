from urlparse import urlparse
from config import config

MQTT_URL = config['MQTT_URL']

TOPIC = 'xmas-lights'

url = urlparse(MQTT_URL)

hostname = url.hostname
username = url.username
password = url.password

if url.path:
    username = url.path[1:] + ':' + username

auth = dict(username=username, password=password) if username else None
port = 1883
