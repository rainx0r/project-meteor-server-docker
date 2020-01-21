#!/bin/bash
set -m

FFXIV_IP=$(getent hosts ffxiv | awk '{ print $1 }')

cd server

# https://cweiske.de/tagebuch/docker-mysql-available.htm
maxcounter=120
echo "Waiting for MySQL for up to ${maxcounter}s..."
counter=1
while ! mysql --protocol TCP -h "${MYSQL_HOST}" -u "${MYSQL_USER}" -p "${MYSQL_PASSWORD}" -e "show databases;" > /dev/null 2>&1; do
    sleep 1
    counter=`expr $counter + 1`
    if [ $counter -gt $maxcounter ]; then
        >&2 echo "Waited for MySQL too long. Exiting."
        exit 1
    fi;
done

mysql --protocol TCP -h "${MYSQL_HOST}" -u "${MYSQL_USER}" -p "${MYSQL_PASSWORD}"\
    -e "UPDATE ${MYSQL_DATABASE}.servers SET address='${PUBLIC_IP}';"
mysql --protocol TCP -h "${MYSQL_HOST}" -u "${MYSQL_USER}" -p "${MYSQL_PASSWORD}"\
    -e "UPDATE ${MYSQL_DATABASE}.server_zones SET serverIp='${FFXIV_IP}';"

cd "Lobby Server"\
    && sed -i\
    -e 's/server_ip=.*/server_ip='"${FFXIV_IP}"'/g'\
    -e 's/host=.*/host='"${MYSQL_HOST}"'/g'\
    -e 's/database=.*/database='"${MYSQL_DATABASE}"'/g'\
    -e 's/username=.*/username='"${MYSQL_USER}"'/g' lobby_config.ini\
    && mono "Lobby Server.exe" &
cd "Map Server"\
    && sed -i\
    -e 's/server_ip=.*/server_ip='"${FFXIV_IP}"'/g'\
    -e 's/host=.*/host='"${MYSQL_HOST}"'/g'\
    -e 's/database=.*/database='"${MYSQL_DATABASE}"'/g'\
    -e 's/username=.*/username='"${MYSQL_USER}"'/g' map_config.ini\
    && mono "Map Server.exe" &
sleep 15
cd "World Server"\
    && sed -i\
    -e 's/server_ip=.*/server_ip='"${FFXIV_IP}"'/g'\
    -e 's/host=.*/host='"${MYSQL_HOST}"'/g'\
    -e 's/database=.*/database='"${MYSQL_DATABASE}"'/g'\
    -e 's/username=.*/username='"${MYSQL_USER}"'/g' world_config.ini\
    && mono "World Server.exe" &
fg %1