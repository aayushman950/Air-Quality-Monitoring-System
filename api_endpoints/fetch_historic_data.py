from flask import Flask, jsonify
from influxdb import InfluxDBClient

app = Flask(__name__)
client = InfluxDBClient(host='localhost', port=8086, username='user', password='password', database='aqms')

@app.route('/history', methods=['GET'])
def get_historical_data():
    query = """
    SELECT time, AQI, PM25, PM10 FROM measurement_name
    WHERE time > now() - 30d  -- Replace 30d with the desired time range
    """
    results = client.query(query)
    data_points = list(results.get_points())
    return jsonify(data_points)

if __name__ == '__main__':
    app.run(debug=True)
