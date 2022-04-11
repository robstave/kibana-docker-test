# kibana-docker-test

sdfdf
Docker compose for testing tiers

Based on the excellent example here:
https://opster.com/guides/elasticsearch/capacity-planning/elasticsearch-hot-warm-cold-frozen-architecture/


To Run

	docker-compose up -d

verify that things are up by logging into kibana on port 5601

command to set up the directories access

	setup_dirs.sh

Copy over a cert from ES01 for later.  Just in the same dir as the docker compose.1

it may be located here:
/var/lib/docker/volumes/kibana-docker-test_certs/_data/es01


cp es01.crt /home/rstave/kibana-docker-test

   

run the script

  set_index_templates.sh

  start_datastreams.sh


Start pushing data.  
In this case, I am adding data with start_post1 and start_post2 to add data to both streams.


The data should be flowing at this point

You will need to add the data view to see data

Stack managagement -> data views -> add readings-* with the timestamp



