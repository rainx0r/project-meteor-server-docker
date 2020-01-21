# project-meteor-server-docker

Docker container for FFXIV 1.0 servers running with [project-meteor-server](https://bitbucket.org/Ioncannon/project-meteor-server/src/develop/).

The docker network uses MariaDB, nginx and mono under the hood.

Currently all the FFXIV-related servers run under 1 container and only 1 World instance is used. This might change in the future but getting this to work to begin with was already a huge pain in the ass.

## Building
1. Build the solution of the repository linked above. (Before building you might want to commenting out lines 84-86 in `Program.cs` for `Map Server` and lines `102-103` in `Program.cs` for World Server as that behaves very poorly under mono)
2. Place all build files under `game/server/` so you end up with `game/server/World Server/World Server.exe` etc.
3. Get the `staticactors.bin` file from `<FINAL FANTASY XIV client install location>\client\script\rq9q1797qvs.san`, paste it into `game/server/Map Server/` and rename it as `staticactors.bin`.
4. Copy all files from `/Data/sql` from the original repository under `db/sql/`.
5. Copy all files from `/Data/www/login_su` from the original repository under `login/www/`.
6. Set the `PUBLIC_IP` environment variable to the public IP of the host.
7. Set the `WORLD_NAME`environment variable to the name of the world you want to host.
8. Download `docker` and `docker-compose``
9. Run `docker-compose build`.

## Running
1. Set the `PUBLIC_IP` environment variable to the public IP of the host.
2. Make sure you have ports `54994`, `1989`, and `54992` open. Due to how the servers connect to each other there is not much room for remapping these ports in the `docker-compose.yml` file to give you more freedom over selection of the publicly exposed ports.
3. Run `docker-compose up`.

## FAQ
- Q: Why does the server seemingly hang on initializing the database?
- A: Because there is currently a bug with MariaDB where getting timezone information takes ages on HDDs. You won't experience this if your server has an SSD but if it doesn't, you have two options: 

    - Wait around 20-ish minutes before it proceeds to initializing the database, then shut down all containers and start them up again since the FFXIV container will have timed out by then.

    - Add `MYSQL_INITDB_SKIP_TZINFO: 1` under the `environment` key of the `db` service in `docker-compose.yml`.