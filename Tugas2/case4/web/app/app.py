from flask import Flask, render_template, request
import mysql.connector

app = Flask(__name__)

def get_weather_data(start_date=None, end_date=None):
    conn = mysql.connector.connect(
        host="mysql1",
        user="myuser",
        password="mypassword",
        database="mydb"
    )
    cursor = conn.cursor()
    query = "SELECT timestamp, city, temperature, description FROM weather"
    params = []
    if start_date and end_date:
        query += " WHERE timestamp BETWEEN %s AND %s"
        params.extend([start_date, end_date])
    query += " ORDER BY timestamp DESC"
    cursor.execute(query, params)
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return data

@app.route('/')
def index():
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')
    weather_data = get_weather_data(start_date, end_date)
    return render_template('index.html', weather_data=weather_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9999)