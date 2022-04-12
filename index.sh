#!/bin/bash
while true; do
  clear
  curl -k -u elastic:elastic \
  --cacert es01.crt \
  -X GET "https://localhost:9200/_cat/indices?h=health,index,docs.count,store.size,creation.date.string&v&s=index"

  sleep 2

done
