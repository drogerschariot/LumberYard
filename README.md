LumberYard
==========

LumberYard creates a Logstash test environment is minutes using vagrant.

###Install
- git clone git@github.com:drogerschariot/LumberYard.git
- cd LumberYard
- vagrant up


###Usage

When your testing environment starts, you will have a Logstash server with an Elasticsearch DB, a Redis broker, and Kibana for your frontend. To test log events, simply send logs to the Redis broker via <your_computer_IP>:6379 and view them in Kibana http://localhost:8088


###Contrib
Fork and request.
