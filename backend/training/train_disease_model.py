import os
import cv2
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import joblib

def extract_features(image_path):
    # Read image and resize to a small size for traditional ML
    img = cv2.imread(image_path)
    if img is None:
        return None
    img = cv2.resize(img, (64, 64))
    
    # Extract Color Histogram
    hist = cv2.calcHist([img], [0, 1, 2], None, [8, 8, 8], [0, 256, 0, 256, 0, 256])
    cv2.normalize(hist, hist)
    
    return hist.flatten()

def train():
    zip_path = r"C:\Users\sriha\Downloads\disease dataset.zip"
    
    if not os.path.exists(zip_path):
        print(f"Zip dataset not found at {zip_path}. Please check the path.")
        return

    features = []
    labels = []
    class_names = []
    
    print("Reading and extracting features directly from zip file (sampling 30 images per class for speed)...")
    
    import zipfile
    class_counts = {}
    class_map = {}
    
    try:
        with zipfile.ZipFile(zip_path, 'r') as z:
            # First, identify the classes based on directory names
            # Assuming structure like: dataset/Class_Name/image.jpg
            for info in z.infolist():
                if info.is_dir() or not info.filename.endswith(('.jpg', '.png', '.jpeg', '.JPG')):
                    continue
                    
                parts = info.filename.split('/')
                if len(parts) >= 2:
                    class_name = parts[-2]
                    
                    if class_name not in class_map:
                        class_map[class_name] = len(class_names)
                        class_names.append(class_name)
                        class_counts[class_name] = 0
                        print(f"Found class: {class_name}")
                        
                    # Sample only 30 images per class to prevent memory overload from 17GB zip
                    if class_counts[class_name] < 30:
                        img_data = z.read(info.filename)
                        nparr = np.frombuffer(img_data, np.uint8)
                        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
                        
                        if img is not None:
                            img = cv2.resize(img, (64, 64))
                            hist = cv2.calcHist([img], [0, 1, 2], None, [8, 8, 8], [0, 256, 0, 256, 0, 256])
                            cv2.normalize(hist, hist)
                            
                            features.append(hist.flatten())
                            labels.append(class_map[class_name])
                            class_counts[class_name] += 1
                            
                    # Break early if we've collected enough for all classes (assuming we found at least a few classes)
                    if len(class_counts) > 0 and all(count >= 30 for count in class_counts.values()):
                        if len(class_counts) > 10:  # If we have a good number of classes, break to save time
                            pass # We won't break fully just in case there are more classes deep down, but we skip fast
                            
    except Exception as e:
        print(f"Error reading zip file: {e}")
        return

    if not features:
        print(f"No valid images found in {zip_path}.")
        return

    X = np.array(features)
    y = np.array(labels)
    
    print(f"Total images processed: {len(X)}")
    print("Training Random Forest Classifier for Disease Detection...")
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Using Random Forest (lightweight and requires no GPU)
    model = RandomForestClassifier(n_estimators=100, max_depth=20, random_state=42, n_jobs=-1)
    model.fit(X_train, y_train)
    
    preds = model.predict(X_test)
    acc = accuracy_score(y_test, preds)
    print(f"Validation Accuracy: {acc * 100:.2f}%")
    
    os.makedirs('../models', exist_ok=True)
    
    print("Saving model to models/disease_detector_rf.pkl")
    joblib.dump(model, '../models/disease_detector_rf.pkl')
    
    import json
    class_map = {name: idx for idx, name in enumerate(class_names)}
    with open('../models/disease_classes.json', 'w') as f:
        json.dump(class_map, f)
        
    print("Training complete! Scikit-learn model saved.")

if __name__ == "__main__":
    train()
