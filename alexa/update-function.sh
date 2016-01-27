#!/bin/bash -eu

#FUNCTION_NAME=highland-alexa-lighting
FUNCTION_NAME=highlandHome
ZIPFILE=build/lambda.zip

mkdir -p build

coffee -o build -c *.coffee

# rm -f $ZIPFILE
(cd build && zip -u ../$ZIPFILE *.js)
zip -ur $ZIPFILE node_modules

aws lambda update-function-code \
  --function-name $FUNCTION_NAME \
  --zip-file fileb://$ZIPFILE
