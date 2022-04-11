#!/bin/bash

echo -e "-------------------\n"
echo -e "starting"
curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_data_stream/readings-regular" 



curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_data_stream/readings-prime" 


