#!/bin/bash
NOW=$(($(date +'%s * 1000 + %-N / 1000000'))) && \
TEMP=$((50+( $RANDOM % 55 ))) && \
curl -k -H "Content-Type: application/json" \
--cacert es01.crt \
-u elastic:elastic \
-X POST "https://localhost:9200/readings-prime/_doc" \
-d'
  {
  "@timestamp": "'"${NOW}"'",
  "client_id":99,
  "level":10,
  "temp":"'"${TEMP}"'",
  "rssi":-3.95
  }
'
