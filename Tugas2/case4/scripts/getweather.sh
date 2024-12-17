#!/bin/sh

API_KEY="5dc057d560msh3176f78ecffab07p1b0617jsnb1a86ef0e08d"
LAT="35.5"
LON="-78.5"
URL="https://open-weather13.p.rapidapi.com/city/landon/EN"
LOKASI=/data
DELAY=60
MYSQL_HOST="mysql1"

# Ensure the MySQL container is running
if ! ping -c 1 $MYSQL_HOST &> /dev/null; then
    echo "MySQL container is not running. Please start the container and try again."
    exit 1
fi

echo "Will run every $DELAY seconds"

while true;
do
    date=$(date '+%Y-%m-%d %H:%M:%S')
    echo "Processing at $date"
    weather_data=$(curl -sL --request GET --url "$URL" --header "x-rapidapi-host: open-weather13.p.rapidapi.com" --header "x-rapidapi-key: $API_KEY")
    temp=$(echo $weather_data | jq '.main.temp')
    humidity=$(echo $weather_data | jq '.main.humidity')
    description=$(echo $weather_data | jq -r '.weather[0].description')

    echo "weather data: $temp F, $humidity %, $description"
    mysql -h $MYSQL_HOST -u myuser -pmypassword mydb -e "INSERT INTO weather (city, temperature, description, timestamp) VALUES ('Landon', $temp, '$description', '$date');"
    if [ $? -eq 0 ]; then
        echo "Successfully inserted weather data into SQL at $date"
        mysql -h $MYSQL_HOST -u myuser -pmypassword mydb -e "SELECT * FROM weather ORDER BY timestamp DESC LIMIT 1;"
    else
        echo "Failed to insert weather data into SQL at $date"
    fi
    sleep $DELAY
done