#!/bin/bash
for service in es01 es02 es03 ; do docker exec -u 0 $service chown elasticsearch:root /usr/share/elasticsearch/snapshots/; done
