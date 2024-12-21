echo "Waiting for MySQL to be ready..."
timeout=300
while ! mysqladmin ping -h localhost -u root -prootpassword --silent; do
    echo "Waiting for MySQL to start..."
    sleep 10
    timeout=$((timeout - 10))
    if [ $timeout -le 0 ]; then
        echo "MySQL startup timed out."
        exit 1
    fi
done

echo "Waiting for initialization..."
sleep 10

# Execute initialization script explicitly using the correct path
echo "Initializing database..."
mysql -uroot -prootpassword mydb < /docker-entrypoint-initdb.d/init.sql

# Verify table creation
echo "Verifying table structure..."
mysql -umyuser -pmypassword mydb -e "DESCRIBE weather;"