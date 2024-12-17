#!/bin/sh

docker network inspect mynetwork >/dev/null 2>&1 || docker network create mynetwork

docker rm -f mysql1 >/dev/null 2>&1

docker container run -d \
  --name mysql1 \
  --network mynetwork \
  -v "$(pwd)/dbdata:/var/lib/mysql" \
  -e MYSQL_DATABASE=mydb \
  -e MYSQL_USER=myuser \
  -e MYSQL_PASSWORD=mypassword \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  mysql:8.0-debian 

# Wait for MySQL server to start
sleep 20

# Ensure the MySQL container is running
MYSQL_CONTAINER_STATUS=$(docker inspect -f '{{.State.Status}}' mysql1)
if [ "$MYSQL_CONTAINER_STATUS" != "running" ]; then
    echo "MySQL container is not running. Please start the container and try again."
    exit 1
fi

MYSQL_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql1)
if [ -z "$MYSQL_HOST" ]; then
    echo "Failed to retrieve MySQL container IP address."
    exit 1
fi

docker exec -it mysql1 mysql -uroot -prootpassword -e "ALTER USER 'myuser'@'%' IDENTIFIED WITH mysql_native_password BY 'mypassword';"
docker exec -it mysql1 mysql -uroot -prootpassword -e "GRANT ALL PRIVILEGES ON mydb.* TO 'myuser'@'%';"

docker exec -i mysql1 mysql -umyuser -pmypassword mydb <<EOF
DROP TABLE IF EXISTS weather;
CREATE TABLE weather (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(255) NOT NULL,
    temperature FLOAT NOT NULL,
    description VARCHAR(255),
    timestamp DATETIME NOT NULL
);
EOF

# Verify table structure
echo "test"
docker exec -it mysql1 mysql -umyuser -pmypassword mydb -e "DESCRIBE weather;"