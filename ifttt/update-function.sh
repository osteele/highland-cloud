#!/bin/bash -eu

FUNCTION_NAME=highland-ifttt
ZIPFILE=ifttt.zip

rm -f $ZIPFILE
zip -r $ZIPFILE *.py *.json paho

aws lambda update-function-code \
  --function-name $FUNCTION_NAME \
  --zip-file fileb://$ZIPFILE
