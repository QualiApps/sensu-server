Sensu Server
==============
The Sensu server is responsible for orchestrating check executions, the processing of check results, and event handling.

Depends on: RabbitMQ, Redis, Elasticsearch

Installation
--------------

1. Install [Docker](https://www.docker.com)

2. Download automated build from public Docker Hub Registry: `docker pull qapps/sensu-server`
(alternatively, you can build an image from Dockerfile: `docker build -t="qapps/sensu-server" github.com/qualiapps/sensu-server`)

Running
-----------------

`docker run -d -p 3000:3000 -p 4567:4567 --link rabbitmq:rmq --link elasticsearch:es --link redis:redis --name sensuServer qapps/sensu-server`

where:

`rabbitmq` - your rabbit container name

`elasticsearch` - your elasticsearch container name

`redis` - the redis container name


How to access via browser
-------------------------

Uchiwa - is a simple dashboard for the Sensu monitoring framework

`http://your-server:3000/`