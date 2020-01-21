FROM mono:latest
RUN apt-get update -y &&\
    apt-get install unzip wget mysql-client -y
WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh
CMD ./start.sh