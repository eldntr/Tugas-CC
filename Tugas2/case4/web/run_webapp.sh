docker rm -f webapp

# Create a volume for pip cache
docker volume create pip-cache

docker container run -d \
  --name webapp \
  --network mynetwork \
  --privileged \
  -p 9999:9999 \
  -v "$(pwd)/web/app:/app" \
  -v "$(pwd)/web/requirements.txt:/requirements.txt" \
  -v pip-cache:/root/.cache/pip \
  python:3.9-slim \
  sh -c "pip install -r /requirements.txt && python /app/app.py"