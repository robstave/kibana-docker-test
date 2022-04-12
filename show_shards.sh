#!/bin/bash
while true; do
  clear
  curl -k -u elastic:elastic \
  --cacert es01.crt \
  -X GET "https://localhost:9200/_cat/shards/readings*?v&s=index&h=index,node"

  sleep 2

done
