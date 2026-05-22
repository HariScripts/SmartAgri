"""
SmartAgri Enhanced v3 — ML Training Scripts
train_crop_model.py  &  train_disease_model.py
Run from project root: python backend/ml/train_crop_model.py
"""

# ═══════════════════════════════════════════════════════
# PART 1: CROP RECOMMENDATION MODEL TRAINING
# ═══════════════════════════════════════════════════════
import os, pickle
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.metrics import classification_report, accuracy_score
from sklearn.pipeline import Pipeline

DATA_PATH   = os.path.join(os.path.dirname(__file__), "../../data/crop/crop_recommendation.csv")
MODEL_PATH  = os.path.join(os.path.dirname(__file__), "../models/crop_model.pkl")
LABEL_PATH  = os.path.join(os.path.dirname(__file__), "../models/crop_labels.pkl")
SCALER_PATH = os.path.join(os.path.dirname(__file__), "../models/crop_scaler.pkl")

SOIL_MAP = {"sandy": 0, "clay": 1, "loamy": 2, "silty": 3, "peaty": 4}

def train_crop_model():
    print("=" * 60)
    print("SmartAgri — Crop Recommendation Model Training")
    print("=" * 60)

    # ── Load data ─────────────────────────────────────────────────
    df = pd.read_csv(DATA_PATH)
    print(f"Dataset shape: {df.shape}")
    print(f"Unique crops : {df['crop'].nunique()}")
    print(f"Crops        : {sorted(df['crop'].unique())}")

    # ── Encode soil type ──────────────────────────────────────────
    df["soil_enc"] = df["soil_type"].map(SOIL_MAP).fillna(2)

    # ── Features & target ─────────────────────────────────────────
    FEATURES = ["N", "P", "K", "temperature", "humidity", "moisture", "ph", "soil_enc"]
    X = df[FEATURES].values
    le = LabelEncoder()
    y = le.fit_transform(df["crop"].values)

    print(f"\nFeatures used: {FEATURES}")
    print(f"Classes      : {list(le.classes_)}")

    # ── Train / test split ────────────────────────────────────────
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )

    # ── Model pipeline ────────────────────────────────────────────
    pipe = Pipeline([
        ("scaler", StandardScaler()),
        ("clf", RandomForestClassifier(
            n_estimators=500,
            max_depth=None,
            min_samples_leaf=2,
            class_weight="balanced",
            random_state=42,
            n_jobs=-1
        ))
    ])

    pipe.fit(X_train, y_train)

    # ── Evaluate ──────────────────────────────────────────────────
    y_pred = pipe.predict(X_test)
    acc = accuracy_score(y_test, y_pred)
    print(f"\nTest Accuracy  : {acc * 100:.2f}%")
    cv = cross_val_score(pipe, X, y, cv=5, scoring="accuracy")
    print(f"5-fold CV Acc  : {cv.mean()*100:.2f}% ± {cv.std()*100:.2f}%")
    print("\nClassification Report:")
    print(classification_report(y_test, y_pred, target_names=le.classes_))

    # ── Save ──────────────────────────────────────────────────────
    os.makedirs(os.path.dirname(MODEL_PATH), exist_ok=True)
    with open(MODEL_PATH,  "wb") as f: pickle.dump(pipe, f)
    with open(LABEL_PATH,  "wb") as f: pickle.dump(le, f)
    print(f"\nModel saved to  : {MODEL_PATH}")
    print(f"Labels saved to : {LABEL_PATH}")
    return pipe, le

# ── Inference helper ──────────────────────────────────────────────────────────
def predict_top5(N, P, K, temp, hum, moisture, ph, soil_type="loamy"):
    soil_enc = SOIL_MAP.get(soil_type, 2)
    X_new = np.array([[N, P, K, temp, hum, moisture, ph, soil_enc]])
    try:
        with open(MODEL_PATH,  "rb") as f: pipe = pickle.load(f)
        with open(LABEL_PATH,  "rb") as f: le   = pickle.load(f)
        proba = pipe.predict_proba(X_new)[0]
        top5_idx = np.argsort(proba)[::-1][:5]
        return [{"crop": le.classes_[i], "confidence": round(proba[i]*100, 1)} for i in top5_idx]
    except FileNotFoundError:
        print("Model not found — run train_crop_model() first.")
        return []

if __name__ == "__main__":
    pipe, le = train_crop_model()
    # Quick demo prediction
    print("\n── Demo Prediction ──")
    result = predict_top5(N=80, P=40, K=40, temp=22, hum=80, moisture=65, ph=6.5, soil_type="silty")
    for r in result:
        print(f"  {r['crop']:15s}  {r['confidence']}%")
