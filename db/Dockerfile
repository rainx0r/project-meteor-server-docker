FROM mariadb
ARG PUBLIC_IP=127.0.0.1
ARG WORLD_NAME=Meteor
COPY ./sql/*.sql /docker-entrypoint-initdb.d/
WORKDIR /docker-entrypoint-initdb.d
RUN sed -i -e "s/127.0.0.1/${PUBLIC_IP}/g" servers.sql
RUN sed -i -e "s/Fernehalwes/${WORLD_NAME}/g" servers.sql