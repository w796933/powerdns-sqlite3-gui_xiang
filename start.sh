#!/bin/bash

SQLITE3_DB=pdns.sqlite3
SQLITE3_DB_HOME=/var/lib/powerdns
DATA_VOLUME=/data

ALLOW_RECURSION=127.0.0.1,172.17.0.0/16,${ALLOW_RECURSION}
ALLOW-AXFR-IPS=${ALLOW-AXFR-IPS}

if [[ ! -e $SQLITE3_DB_HOME/$SQLITE3_DB.default ]]; then
    echo "Creating default database"
    mv $SQLITE3_DB_HOME/$SQLITE3_DB $SQLITE3_DB_HOME/$SQLITE3_DB.default
fi

if [[ ! -e $DATA_VOLUME/$SQLITE3_DB ]]; then
    echo "Cloning default database"
    cp -p $SQLITE3_DB_HOME/$SQLITE3_DB.default $DATA_VOLUME/$SQLITE3_DB
fi

if [[ ! -L $SQLITE3_DB_HOME/$SQLITE3_DB ]]; then
    echo "Linking existing DB from $DATA_VOLUME/$SQLITE3_DB to $SQLITE3_DB_HOME/$SQLITE3_DB"
    ln -s $DATA_VOLUME/$SQLITE3_DB $SQLITE3_DB_HOME/$SQLITE3_DB
fi

sed -i -e "s\^PDNS_API_KEY.*$\PDNS_API_KEY = '${WEBPASSWD}'\g" /var/lib/powerdns-admin/config.py

echo "Starting powerdns-Admin"
/bin/bash -c "cd /var/lib/powerdns-admin/ && . ./flask/bin/activate && ./create_db.py && ./run.py" &

echo "Starting pdns_server"
/usr/sbin/pdns_server --daemon=no --allow-recursion=${ALLOW_RECURSION} --recursor=${RECURSOR} --allow-axfr-ips=${ALLOW-AXFR-IPS} --master=yes --disable-axfr=no --local-address=0.0.0.0 --launch=gsqlite3 --webserver=yes --webserver-address=0.0.0.0 --webserver-port=8080 --webserver-password=${WEBPASSWD} --experimental-json-interface=yes --experimental-api-key=${WEBPASSWD} "$@"
