docker rm -f webapp

docker container run -d \
  --name webapp \
  --network mynetwork \
  --privileged \
  -p 9999:9999 \
  -v "$(pwd)/web/app:/app" \
  python:3.9-slim \
  sh -c "pip install flask mysql-connector-python && python /app/app.py"