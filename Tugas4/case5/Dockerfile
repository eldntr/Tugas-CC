FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

# Install necessary packages
RUN apt-get update && apt-get install -y \
    tzdata \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    libssl-dev \
    zlib1g-dev \
    wget \
    ffmpeg \
    curl \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Flask
RUN pip3 install flask

# Download and compile Nginx with RTMP module
RUN wget http://nginx.org/download/nginx-1.19.10.tar.gz && \
    tar zxvf nginx-1.19.10.tar.gz && \
    wget https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz && \
    tar zxvf v1.2.1.tar.gz && \
    cd nginx-1.19.10 && \
    ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-1.2.1 && \
    sed -i 's/-Werror//g' objs/Makefile && \
    make && make install

# Copy Nginx configuration file
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# Copy web files
COPY www /usr/local/nginx/html

# Copy Flask application
COPY app.py /app.py

# Copy HTML template for Flask
RUN mkdir -p /templates
COPY www/index.html /templates/index.html

EXPOSE 80 1935 5000

CMD ["/bin/bash", "-c", "/usr/local/nginx/sbin/nginx & python3 /app.py"]
