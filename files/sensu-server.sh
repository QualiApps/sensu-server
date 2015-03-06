#!/usr/bin/env bash

ADDRESS=$(awk "/$HOSTNAME/ "'{ print $1 }' /etc/hosts)

# Sets server config
cat > /etc/sensu/conf.d/settings.json <<EOF
{
    "api": {
        "host": "$ADDRESS",
        "port": 4567
    },
    "rabbitmq": {
        "host": "rmq",
        "port": $RMQ_PORT_5672_TCP_PORT,
        "vhost": "/",
        "user": "rabbit",
        "password": "rabbit"
    },
    "redis": {
        "host": "redis",
        "port": $REDIS_PORT_6379_TCP_PORT
    },
    "elasticsearch": {
        "host": "es",
        "port": $ES_PORT_9200_TCP_PORT,
        "index": "sensu-metrics",
        "timeout": 5
    }
}
EOF

# Sets uchiwa config
cat > /etc/sensu/uchiwa.json <<EOF
{
    "sensu": [
        {
            "name": "Sensu Server",
            "host": "$ADDRESS",
            "ssl": false,
            "port": 4567,
            "path": "",
            "timeout": 5000
        }
    ],
    "uchiwa": {
        "port": 3000,
        "stats": 10,
        "refresh": 10000
    }
}
EOF



# Start Supervisord
/usr/bin/supervisord -c /etc/supervisord.conf