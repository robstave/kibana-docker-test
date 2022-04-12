#!/bin/bash

echo -e "-------------------\n"
echo -e "changing ilm polling to 15 s"
curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_cluster/settings" \
-d'
{
  "transient": {
    "indices.lifecycle.poll_interval": "15s" 
  }
}
'

