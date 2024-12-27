import random
import datetime
import datetime
from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS
import time

# InfluxDB connection details
bucket = "SensorData"
org = "AQMS"
token = "cnuD2krG9s06LeYhs2zty7ZDf08zjP_1LrpPymhtWL9Rn6FwTPyiO2iPr0fkwbYf16LaEI-E25CJLSGr6PcNeg=="  # all access token
url = "http://localhost:8086"

# Initialize InfluxDB Client
client = InfluxDBClient(url=url, token=token, org=org)
write_api = client.write_api(write_options=SYNCHRONOUS)

def simulate_and_upload():
    # Generate random values for PM2.5, PM10, and AQI
    pm25 = round(random.uniform(0, 150), 2)  # Random value between 0 and 150 µg/m³
    pm10 = round(random.uniform(0, 200), 2)  # Random value between 0 and 200 µg/m³
    aqi = round(random.uniform(0, 400))      # Keep AQI as an integer

    # Create a point to write to InfluxDB
    point = (
        Point("air_quality")  # Measurement name
        .tag("location", "Sensor 1")  # Add tags for categorization
        .field("PM2.5", pm25)
        .field("PM10", pm10)
        .field("AQI", aqi)
        .time(datetime.datetime.now(datetime.timezone.utc).isoformat())  # Use timezone-aware datetime
    )

    # Write data to InfluxDB
    write_api.write(bucket=bucket, org=org, record=point)
    print(f"Data uploaded: PM2.5={pm25}, PM10={pm10}, AQI={aqi}")

# Simulate data every 10 seconds
try:
    while True:
        simulate_and_upload()
        time.sleep(10)  # Wait for 10 seconds before the next simulation
except KeyboardInterrupt:
    print("Simulation stopped!")