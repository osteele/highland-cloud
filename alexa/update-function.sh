#!/bin/bash -eu

#FUNCTION_NAME=highland-alexa-lighting
FUNCTION_NAME=highlandHome
ZIPFILE=build/lambda.zip

mkdir -p build

coffee -o build -c *.coffee

# TODO fail unless rc in [0, 12]
nzip() { zip "$@" || true; }

# rm -f $ZIPFILE
(cd build && nzip -u ../$ZIPFILE *.js)
nzip -ur $ZIPFILE node_modules

aws lambda update-function-code \
  --function-name $FUNCTION_NAME \
  --zip-file fileb://$ZIPFILE &

aws lambda update-function-code \
  --function-name highland-alexa-skill \
  --zip-file fileb://$ZIPFILE &

wait
