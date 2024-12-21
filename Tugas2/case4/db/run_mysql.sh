docker network inspect mynetwork >/dev/null 2>&1 || docker network create mynetwork
docker rm -f mysql1 >/dev/null 2>&1

docker container run -d \
  --name mysql1 \
  --network mynetwork \
  -v "$(pwd)/db/dbdata:/var/lib/mysql" \
  -v "$(pwd)/db/script:/docker-entrypoint-initdb.d" \
  -e MYSQL_DATABASE=mydb \
  -e MYSQL_USER=myuser \
  -e MYSQL_PASSWORD=mypassword \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  mysql:8.0-debian

docker exec mysql1 /bin/sh -c "/docker-entrypoint-initdb.d/init.sh"