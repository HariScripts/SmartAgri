import os
import json
import numpy as np

# A safe ensemble wrapper for Disease Detection
class DiseaseEnsemble:
    def __init__(self):
        self.model = None
        self.class_indices = {}
        self.is_loaded = False

    def load_models(self):
        try:
            from tensorflow.keras.models import load_model
            model_path = os.path.join(os.path.dirname(__file__), "models/DiseaseNet_Custom.h5")
            class_path = os.path.join(os.path.dirname(__file__), "models/disease_classes.json")
            
            if os.path.exists(model_path) and os.path.exists(class_path):
                with open(class_path, "r") as f:
                    # Invert the class_indices dictionary to map from index (int) to class name (string)
                    indices = json.load(f)
                    self.class_indices = {v: k for k, v in indices.items()}
                
                self.model = load_model(model_path)
                self.is_loaded = True
                print("Custom Disease AI model loaded safely.")
            else:
                print("Custom Disease AI model not found. Skipping load.")
        except Exception as e:
            print(f"Failed to load Disease AI: {e}")

    def predict(self, image_bytes):
        if not self.is_loaded:
            return None

        try:
            from tensorflow.keras.preprocessing.image import img_to_array, load_img
            from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
            import io
            
            # MobileNetV2 uses 224x224
            img = load_img(io.BytesIO(image_bytes), target_size=(224, 224))
            img_array = img_to_array(img)
            img_array = np.expand_dims(img_array, axis=0).astype(np.float32)
            
            # Use MobileNetV2 preprocessing to scale to [-1, 1]
            img_array = preprocess_input(img_array)

            # Predict using H5 model
            output_data = self.model.predict(img_array)[0]
            
            result_idx = int(np.argmax(output_data))
            confidence = float(np.max(output_data)) * 100
            
            # The label looks like "Apple Scab Leaf" or "Apple rust leaf"
            raw_label = self.class_indices.get(result_idx, "Unknown")
            
            # Clean up the label
            parts = raw_label.replace("leaf", "").replace("Leaf", "").strip().split(" ")
            crop = parts[0] if len(parts) > 0 else "Unknown"
            disease = " ".join(parts[1:]) if len(parts) > 1 else "Unknown"
            if disease == "" or disease.lower() == "healthy":
                 disease = "Healthy"
            
            # Determine severity
            severity = "HEALTHY" if "healthy" in disease.lower() else ("CRITICAL" if "blight" in disease.lower() or "virus" in disease.lower() else "HIGH")
            
            return {
                "crop": crop,
                "disease": disease,
                "severity": severity,
                "confidence": round(confidence, 1)
            }
        except Exception as e:
            print(f"Prediction error: {e}")
            return None

ensemble = DiseaseEnsemble()
