from flask import Flask, render_template
import mysql.connector

app = Flask(__name__)

def get_weather_data():
    conn = mysql.connector.connect(
        host="mysql1",
        user="myuser",
        password="mypassword",
        database="mydb"
    )
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM weather ORDER BY timestamp DESC LIMIT 10")
    data = cursor.fetchall()
    conn.close()
    return data

@app.route('/')
def index():
    weather_data = get_weather_data()
    return render_template('index.html', weather_data=weather_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9999)