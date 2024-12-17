#!/bin/sh

docker rm -f weather_collector

docker container run -d \
  --name weather_collector \
  --network mynetwork \
  -e DELAY=3600 \
  -v "$(pwd)/scripts:/script" \
  alpine:3.18 \
  /bin/sh -c "apk update && apk add --no-cache mysql-client curl jq && /bin/sh /script/getweather.sh"