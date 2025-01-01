from flask import Flask, jsonify
from influxdb_client import InfluxDBClient, QueryApi

# Flask app
app = Flask(__name__)

# InfluxDB connection details
bucket = "SensorData"
org = "AQMS"
token = "cnuD2krG9s06LeYhs2zty7ZDf08zjP_1LrpPymhtWL9Rn6FwTPyiO2iPr0fkwbYf16LaEI-E25CJLSGr6PcNeg=="  # Replace with your token
url = "http://localhost:8086"  # Change if using a remote InfluxDB

# Initialize InfluxDB client
client = InfluxDBClient(url=url, token=token, org=org)
query_api = client.query_api()

# Endpoint to fetch the latest data
@app.route('/latest', methods=['GET'])
def get_latest_data():
    """
    Endpoint to fetch the latest data
    """
    query = f'from(bucket: "{bucket}") |> range(start: -1h) |> sort(columns: ["_time"], desc: true) |> limit(n: 1)'
    try:
        tables = query_api.query(query=query, org=org)
        results = []

        for table in tables:
            for record in table.records:
                results.append({
                    "time": record.get_time(),
                    "field": record.get_field(),
                    "value": record.get_value(),
                    "location": record.values.get("location", "Unknown")
                })

        return jsonify(results), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Endpoint to fetch historical data
@app.route('/history', methods=['GET'])
def get_historical_data():
    """
    Endpoint to fetch historical data
    """
    query = f'from(bucket: "{bucket}") |> range(start: -7d) |> sort(columns: ["_time"], desc: false) |> limit(n: 1000)'

    try:
        tables = query_api.query(query=query, org=org)
        results = []

        for table in tables:
            for record in table.records:
                if record.get_field() in ["AQI", "PM25", "PM10"]:
                    results.append({
                        "time": record.get_time(),
                        "field": record.get_field(),
                        "value": record.get_value()
                    })

        return jsonify(results), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True, port=5000)
