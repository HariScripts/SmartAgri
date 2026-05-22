from fastapi import APIRouter, File, UploadFile
import random
from utils.disease_data import get_disease_info
import io

router = APIRouter()

# Global model variables (would be loaded in main.py)
DISEASE_MODEL = None
CLASS_MAP = {}

@router.post("/detect-disease")
async def detect_disease(file: UploadFile = File(...)):
    # Read image bytes
    contents = await file.read()
    
    # MOCKING ML MODEL INFERENCE (TTA averaged logic)
    # In a real scenario, we pass contents to the loaded EfficientNetB4 model.
    # We simulate the exact response format defined in Prompt 2.
    
    is_healthy = random.random() > 0.8
    
    if is_healthy:
        return {
            "crop_name": "Tomato",
            "is_healthy": True,
            "confidence": round(random.uniform(95, 99.9), 2),
            "disease_name": "Healthy",
            "cure_probability": 100.0,
            "description": "Your crop looks perfectly healthy. Keep up the good work!",
            "affected_parts": [],
            "severity": "None",
            "remedies": [],
            "prevention_methods": ["Maintain current watering schedule", "Ensure proper sunlight"],
            "treatment_steps": []
        }
    else:
        # Simulate a disease detection
        disease_keys = ["Rice___Blast", "Tomato___Early_Blight", "Wheat___Rust"]
        selected_key = random.choice(disease_keys)
        crop, disease = selected_key.split("___")
        disease = disease.replace("_", " ")
        
        info = get_disease_info(selected_key)
        
        return {
            "crop_name": crop,
            "disease_name": disease,
            "confidence": round(random.uniform(85, 98), 2),
            "cure_probability": info["cure_probability"],
            "description": info["description"],
            "affected_parts": info["affected_parts"],
            "severity": info["severity"],
            "remedies": info["remedies"],
            "prevention_methods": info["prevention_methods"],
            "treatment_steps": info["treatment_steps"],
            "is_healthy": False
        }
