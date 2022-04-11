#!/bin/bash
NOW=$(($(date +'%s * 1000 + %-N / 1000000'))) && \
TEMP=$((50+( $RANDOM % 55 ))) && \
curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
--cacert es01.crt \
-X POST "https://localhost:9200/readings-regular/_doc" \
-d'
  {
  "@timestamp": "'"${NOW}"'",
  "client_id":58,
  "level":10,
  "temp":"'"${TEMP}"'",
  "rssi":-3.95
  }
'
