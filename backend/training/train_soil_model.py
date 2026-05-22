import os
import cv2
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import joblib

def extract_features(image_path):
    # Read image and resize
    img = cv2.imread(image_path)
    if img is None:
        return None
    img = cv2.resize(img, (64, 64))
    
    # Simple feature extraction: Color Histogram
    hist = cv2.calcHist([img], [0, 1, 2], None, [8, 8, 8], [0, 256, 0, 256, 0, 256])
    cv2.normalize(hist, hist)
    
    # Flatten the histogram to a 1D feature vector
    return hist.flatten()

def train():
    data_dir = r"C:\Users\sriha\Downloads\soil types"
    
    if not os.path.exists(data_dir):
        print(f"Dataset not found at {data_dir}. Please ensure the folder exists.")
        return

    features = []
    labels = []
    class_names = []
    
    print("Extracting features from images...")
    # Read classes
    for class_idx, class_name in enumerate(sorted(os.listdir(data_dir))):
        class_dir = os.path.join(data_dir, class_name)
        if not os.path.isdir(class_dir):
            continue
            
        class_names.append(class_name)
        
        for img_name in os.listdir(class_dir):
            img_path = os.path.join(class_dir, img_name)
            feat = extract_features(img_path)
            if feat is not None:
                features.append(feat)
                labels.append(class_idx)

    if not features:
        print(f"No valid images found in {data_dir}.")
        return

    X = np.array(features)
    y = np.array(labels)
    
    print(f"Total images processed: {len(X)}")
    print("Training Random Forest Classifier...")
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    model = RandomForestClassifier(n_estimators=100, random_state=42, n_jobs=-1)
    model.fit(X_train, y_train)
    
    preds = model.predict(X_test)
    acc = accuracy_score(y_test, preds)
    print(f"Validation Accuracy: {acc * 100:.2f}%")
    
    os.makedirs('../models', exist_ok=True)
    
    print("Saving model to models/soil_classifier_rf.pkl")
    joblib.dump(model, '../models/soil_classifier_rf.pkl')
    
    import json
    class_map = {name: idx for idx, name in enumerate(class_names)}
    with open('../models/soil_classes.json', 'w') as f:
        json.dump(class_map, f)
        
    print("Training complete! Scikit-learn model saved.")

if __name__ == "__main__":
    train()
