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
        "host": "$RMQ_PORT_5672_TCP_ADDR",
        "port": $RMQ_PORT_5672_TCP_PORT,
        "vhost": "/",
        "user": "rabbit",
        "password": "rabbit"
    },
    "redis": {
        "host": "$REDIS_PORT_6379_TCP_ADDR",
        "port": $REDIS_PORT_6379_TCP_PORT
    },
    "elasticsearch": {
        "host": "$ES_PORT_9200_TCP_ADDR",
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

# Sets mailer config
M_GUI=${M_GUI:-http://localhost:3000}
M_FROM=${M_FROM:-sensu@server.com}
M_TO=${M_TO:-Yury_Kavaliou@epam.com}
SMTP_ADDR=${SMTP_ADDR:-localhost}
SMTP_PORT=${SMTP_PORT:-25}

cat > /etc/sensu/conf.d/mailer.json <<EOF
{
    "mailer": {
        "admin_gui": "$M_GUI",
        "mail_from": "$M_FROM",
        "mail_to": "$M_TO",
        "smtp_address": "$SMTP_ADDR",
        "smtp_port": $SMTP_PORT
    }
}
EOF



# Start Supervisord
#/usr/bin/supervisord -c /etc/supervisord.conf