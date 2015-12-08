#!/usr/bin/env bash

ADDRESS=$(awk "/$HOSTNAME/ "'{ print $1 }' /etc/hosts)

# Sets server config
cat > /etc/sensu/conf.d/settings.json <<EOF
{
    "api": {
        "host": "$ADDRESS",
        "port": ${SENSU_PORT:-4567}
    },
    "rabbitmq": {
        "host": "${FEED_NAME:-feed}",
        "port": ${FEED_PORT:-5672},
        "vhost": "${RMQ_VHOST:-/}",
        "user": "${RMQ_USER:-rabbit}",
        "password": "${RMQ_PASS:-rabbit}"
    },
    "redis": {
        "host": "${REDIS_NAME:-metricdb}",
        "port": ${REDIS_PORT:-6379}
    },
    "elasticsearch": {
        "host": "${ES_NAME:-pss-db}",
        "port": ${ES_PORT:-9200},
        "index": "${DB_INDEX_NAME:-sensu-metrics}",
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
            "port": ${SENSU_PORT:-4567},
            "path": "",
            "timeout": 5000
        }
    ],
    "uchiwa": {
        "port": ${UCHIWA_PORT:-3000},
        "stats": 10,
        "refresh": 10000
    }
}
EOF

# Sets mailer config
M_GUI=${M_GUI:-http://localhost:3000}
M_FROM=${M_FROM:-sensu@server.com}
M_TO=${M_TO:-yury_kavaliou@epam.com}
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
/usr/bin/supervisord -c /etc/supervisord.conf