import random
import datetime

# Dummy threshold data
CROP_THRESHOLDS = {
    "Rice": {"N": (80, 120), "P": (40, 60), "K": (40, 60), "temp": (20, 35), "hum": (80, 90), "moist": (70, 80)},
    "Wheat": {"N": (100, 120), "P": (60, 80), "K": (40, 60), "temp": (15, 25), "hum": (50, 70), "moist": (50, 60)},
    "Sugarcane": {"N": (150, 200), "P": (60, 80), "K": (80, 100), "temp": (25, 35), "hum": (70, 85), "moist": (60, 75)},
}

def generate_sensor_data(crop_name: str):
    thresholds = CROP_THRESHOLDS.get(crop_name, CROP_THRESHOLDS["Rice"])
    
    def simulate_value(optimal_range):
        mid = sum(optimal_range) / 2
        variation = (optimal_range[1] - optimal_range[0]) * 0.2
        # 20% chance to go out of bounds
        if random.random() < 0.2:
            variation *= 2.5
        return round(random.uniform(mid - variation, mid + variation), 2)

    return {
        "nitrogen": simulate_value(thresholds["N"]),
        "phosphorus": simulate_value(thresholds["P"]),
        "potassium": simulate_value(thresholds["K"]),
        "temperature": simulate_value(thresholds["temp"]),
        "humidity": simulate_value(thresholds["hum"]),
        "soilMoisture": simulate_value(thresholds["moist"]),
        "timestamp": datetime.datetime.now().isoformat(),
        "status": "Normal" # Simplified
    }
