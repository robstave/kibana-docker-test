#!/bin/bash

echo -e "-------------------\n"
echo -e "creating snapshot repo:"
curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_snapshot/readings-snapshots-repository" \
-d'
  {
  "type": "fs",
  "settings": {
    "location": "/usr/share/elasticsearch/snapshots",
    "compress": true
  }
}
'



echo -e "\n"
echo -e "creating index template"

curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_index_template/readings" \
-d'
{
  "index_patterns": ["readings-*"],
  "template": {
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 0
    },
    "mappings": {
      "properties": {
        "client_id": {
          "type": "integer"
        },
        "created_at": {
          "type": "date"
        },
        "temp": {
          "type": "float"
        },
        "rssi": {
          "type": "float"
        }

      }
    }
  }
}
'

echo -e "\n"
echo -e "creating lifecycle policies:"


curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_ilm/policy/readings-lifecycle-policy" \
-d'
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_age": "5m"
          }
        }
      },
      "warm": {
        "min_age": "10m",
        "actions": {}
      },
      "delete": {
        "min_age": "30m",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
'


curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_ilm/policy/readings-prime-lifecycle-policy" \
-d'
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_age": "5m"
          }
        }
      },
      "warm": {
        "min_age": "10m",
        "actions": {}
      },
      "cold": {
        "min_age": "20m",
        "actions": {}
      },
      "frozen": {
        "min_age": "30m",
        "actions": {
          "searchable_snapshot": {
            "snapshot_repository": "readings-snapshots-repository"
          }
        }
      },
      "delete": {
        "min_age": "1h",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
'

echo -e "\n"
echo -e "creating component settings:"

curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_component_template/readings-settings" \
-d'
{
  "template": {
    "settings": {
      "index.lifecycle.name": "readings-lifecycle-policy",
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  },
  "_meta": {
    "description": "Settings for orders indices"
  }
}
'



curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_component_template/readings-prime-settings" \
-d'
{
  "template": {
    "settings": {
      "index.lifecycle.name": "readings-prime-lifecycle-policy",
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  },
  "_meta": {
    "description": "Settings for prime indices"
  }
}
'


echo -e "\n"
echo -e "creating component mappings:"


curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_component_template/readings-mappings" \
-d'
{
  "template": {
    "mappings": {
      "properties": {
        "@timestamp": {
          "type": "date",
          "format": "date_optional_time||epoch_millis"
        },
        "client_id": {
          "type": "integer"
        },
        "created_at": {
          "type": "date"
        },
                "level": {
          "type": "integer"
        },
        "temp": {
          "type": "float"
        },
        "rssi": {
          "type": "float"
        }
      }
    }
  },
  "_meta": {
    "description": "Mappings for orders indices"
  }
}
'

echo -e "\n"
echo -e "creating index templages from settings and mappings:"

curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_index_template/readings" \
-d'
{
  "index_patterns": ["readings-*"],
  "data_stream": { },
  "composed_of": [ "readings-settings", "readings-mappings" ],
  "priority": 500,
  "_meta": {
    "description": "Template for regular readings data stream"
  }
}
'


curl -k -H "Content-Type: application/json" \
-u elastic:elastic \
-H 'kbn-xsrf: true' \
-XPUT "https://localhost:9200/_index_template/readings-prime" \
-d'
{
  "index_patterns": ["readings-prime"],
  "data_stream": { },
  "composed_of": [ "readings-prime-settings", "readings-mappings" ],
  "priority": 600,
  "_meta": {
    "description": "Template for prime readings data stream"
  }
}
'


echo -e "\n"
echo -e "tweak cluster settings"
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


echo -e "\n"
echo -e "-------------\n"
