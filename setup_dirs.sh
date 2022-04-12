#!/bin/bash
for service in es01 es02 es03 es04 ; do docker exec -u 0 $service chown elasticsearch:root /usr/share/elasticsearch/snapshots/; done
