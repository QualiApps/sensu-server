# Sensu Server

FROM fedora:21

MAINTAINER Yury Kavaliou <Yury_Kavaliou@epam.com>

COPY ./files/sensu.repo /etc/yum.repos.d/sensu.repo
RUN yum install -y sensu \
	ruby \
	initscripts \
	supervisor \
	uchiwa \
	&& gem install sensu-plugin \
	&& rm /etc/sensu/uchiwa.json

COPY ./files/handlers/elasticsearch_metrics.rb /etc/sensu/handlers/elasticsearch_metrics.rb
COPY ./files/conf.d/ /etc/sensu/conf.d/

COPY ./files/sensu-server.sh /etc/sensu/sensu-server.sh

RUN chmod 700 /etc/sensu/sensu-server.sh
RUN chmod 700 /etc/sensu/handlers/elasticsearch_metrics.rb

# supervisord
COPY ./files/supervisord.conf /etc/supervisord.conf

ENTRYPOINT [ "/bin/bash", "/etc/sensu/sensu-server.sh" ]