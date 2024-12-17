docker ps -q --filter "ancestor=nginx-rtmp-server" | xargs -r docker stop
docker ps -aq --filter "ancestor=nginx-rtmp-server" | xargs -r docker rm

docker ps -q --filter "publish=5000" | xargs -r docker stop
docker ps -aq --filter "publish=5000" | xargs -r docker rm

docker build -t nginx-rtmp-server .
docker run -p 8080:80 -p 1935:1935 -p 5000:5000 nginx-rtmp-server