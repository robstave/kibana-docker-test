# kibana-docker-test

Docker compose for testing tiers

Based on the excellent example here:

https://opster.com/guides/elasticsearch/capacity-planning/elasticsearch-hot-warm-cold-frozen-architecture/

The main difference here is that there are TWO datasteams.  One is for kinda low priority data  and the othere is for data that we want to keep longer.
The scripts `start_post1` and `start_post2` do this.  It is based on 8.1 with auth going though, so there are a few steps required. Mainly, finding the certs.

This requires all the prereqs as the above link ( Docker, Docker compose and so on ) and is written for linux.


## setup

To Run:

1. Bring up the container.

	docker-compose up -d

Verify that things are up by logging into kibana on port 5601
Assuming that is going, we can start adding the configuration.  I would suggest reading the link above. This is basically the same thing, but without
the single order indices.  In this case, I am simulating a "reading" from an IOT device of sorts.

2. Command to set up the directories access. Just some housekeeping to get the repo to be writable.

	setup_dirs.sh

3. Copy over the cert from ES01 to inject data.

Copy over a cert from ES01 for later.  Just in the same dir as the docker compose.1

it may be located here:
/var/lib/docker/volumes/kibana-docker-test_certs/_data/es01

	cp es01.crt /<your-location>/kibana-docker-test

   
4. Run the scripts to fill in the indices, templates and so on.  Again, this is pretty much the same as the link above, but a tad different. 

	set_index_templates.sh
	start_datastreams.sh


5. Start pushing data.  

In this case, I am adding data with start_post1 and start_post2 to add data to both streams.

	start_post1
	start_post2
	
	
The data should be flowing at this point

6. Add Data view from kibana if not there. You will need to add the data view to see data

Stack managagement -> data views -> add readings-* with the timestamp




