"""
SmartAgri Enhanced v3 — Disease Detection Model Training
Uses MobileNetV2 transfer learning (TensorFlow/Keras)
Dataset: 35 crops × 30+ disease classes
Run: python backend/ml/train_disease_model.py
"""

import os, json, numpy as np
from pathlib import Path

# ─── Class labels (31 disease/healthy classes) ────────────────────────────────
DISEASE_CLASSES = [
    "Apple_Scab", "Apple_Healthy",
    "Banana_Panama_Wilt", "Banana_Black_Sigatoka", "Banana_Healthy",
    "Brinjal_Phomopsis_Blight", "Brinjal_Healthy",
    "Capsicum_Bacterial_Spot", "Capsicum_Anthracnose", "Capsicum_Healthy",
    "Chickpea_Ascochyta_Blight", "Chickpea_Healthy",
    "Coconut_Bud_Rot", "Coconut_Healthy",
    "Coffee_Leaf_Rust", "Coffee_Healthy",
    "Cotton_Leaf_Curl_Virus", "Cotton_Healthy",
    "Grapes_Powdery_Mildew", "Grapes_Black_Rot", "Grapes_Healthy",
    "Groundnut_Cercospora_Leaf_Spot", "Groundnut_Healthy",
    "Maize_Northern_Leaf_Blight", "Maize_Common_Rust", "Maize_Healthy",
    "Mango_Anthracnose", "Mango_Powdery_Mildew", "Mango_Healthy",
    "Onion_Purple_Blotch", "Onion_Healthy",
    "Orange_Citrus_Canker", "Orange_Healthy",
    "Potato_Early_Blight", "Potato_Late_Blight", "Potato_Healthy",
    "Rice_Blast_Disease", "Rice_Bacterial_Leaf_Blight", "Rice_Healthy",
    "Sugarcane_Red_Rot", "Sugarcane_Healthy",
    "Tea_Blister_Blight", "Tea_Healthy",
    "Tomato_Late_Blight", "Tomato_Early_Blight", "Tomato_Mosaic_Virus", "Tomato_Healthy",
    "Wheat_Stem_Rust", "Wheat_Powdery_Mildew", "Wheat_Healthy",
]

NUM_CLASSES = len(DISEASE_CLASSES)

def build_mobilenetv2_model(num_classes=NUM_CLASSES, img_size=224):
    """
    Build MobileNetV2 transfer learning model.
    Requires: tensorflow >= 2.9, pip install tensorflow
    """
    try:
        import tensorflow as tf
        from tensorflow.keras.applications import MobileNetV2
        from tensorflow.keras.layers import GlobalAveragePooling2D, Dense, Dropout, BatchNormalization
        from tensorflow.keras.models import Model
        from tensorflow.keras.optimizers import Adam

        base = MobileNetV2(
            input_shape=(img_size, img_size, 3),
            include_top=False,
            weights="imagenet"
        )
        # Freeze first 100 layers; fine-tune rest
        for layer in base.layers[:100]:
            layer.trainable = False
        for layer in base.layers[100:]:
            layer.trainable = True

        x = base.output
        x = GlobalAveragePooling2D()(x)
        x = BatchNormalization()(x)
        x = Dense(512, activation="relu")(x)
        x = Dropout(0.4)(x)
        x = Dense(256, activation="relu")(x)
        x = Dropout(0.3)(x)
        outputs = Dense(num_classes, activation="softmax")(x)

        model = Model(inputs=base.input, outputs=outputs)
        model.compile(
            optimizer=Adam(learning_rate=1e-4),
            loss="categorical_crossentropy",
            metrics=["accuracy", "top_k_categorical_accuracy"]
        )
        print(f"MobileNetV2 model built: {model.count_params():,} parameters")
        print(f"Classes: {num_classes} disease types")
        return model

    except ImportError:
        print("TensorFlow not installed. Run: pip install tensorflow")
        print("Model architecture described above for reference.")
        return None


def create_data_generators(dataset_dir, img_size=224, batch_size=32):
    """Create train/val/test ImageDataGenerators from directory structure."""
    try:
        from tensorflow.keras.preprocessing.image import ImageDataGenerator

        train_aug = ImageDataGenerator(
            rescale=1./255,
            rotation_range=25,
            width_shift_range=0.15,
            height_shift_range=0.15,
            shear_range=0.1,
            zoom_range=0.15,
            horizontal_flip=True,
            fill_mode="nearest",
            validation_split=0.2
        )
        val_aug = ImageDataGenerator(rescale=1./255, validation_split=0.2)

        train_gen = train_aug.flow_from_directory(
            os.path.join(dataset_dir, "train"),
            target_size=(img_size, img_size),
            batch_size=batch_size,
            class_mode="categorical",
            subset="training",
            shuffle=True
        )
        val_gen = val_aug.flow_from_directory(
            os.path.join(dataset_dir, "train"),
            target_size=(img_size, img_size),
            batch_size=batch_size,
            class_mode="categorical",
            subset="validation",
            shuffle=False
        )
        return train_gen, val_gen
    except ImportError:
        print("TensorFlow not available for generators.")
        return None, None


def train_disease_model(dataset_dir="data/disease/images", epochs=30, batch_size=32):
    """
    Full training pipeline.
    Expected dataset structure:
    data/disease/images/
      train/
        Tomato_Late_Blight/  (min 100 images each)
        Tomato_Healthy/
        Rice_Blast_Disease/
        ...
    """
    try:
        import tensorflow as tf
        from tensorflow.keras.callbacks import (
            EarlyStopping, ModelCheckpoint,
            ReduceLROnPlateau, TensorBoard
        )

        print("=" * 60)
        print("SmartAgri — Disease Detection Model Training")
        print(f"Classes  : {NUM_CLASSES}")
        print(f"Epochs   : {epochs}")
        print(f"Batch    : {batch_size}")
        print("=" * 60)

        model = build_mobilenetv2_model()
        if model is None:
            return

        train_gen, val_gen = create_data_generators(dataset_dir, batch_size=batch_size)
        if train_gen is None:
            print(f"Dataset not found at {dataset_dir}")
            print("Download PlantVillage dataset or use the included synthetic data.")
            return

        callbacks = [
            EarlyStopping(monitor="val_accuracy", patience=8, restore_best_weights=True),
            ModelCheckpoint("backend/models/disease_model_best.h5", save_best_only=True, monitor="val_accuracy"),
            ReduceLROnPlateau(monitor="val_loss", factor=0.3, patience=4, min_lr=1e-7),
        ]

        history = model.fit(
            train_gen,
            validation_data=val_gen,
            epochs=epochs,
            callbacks=callbacks,
            verbose=1
        )

        # Save final model
        model.save("backend/models/disease_model_final.h5")
        # Save class index map
        with open("backend/models/disease_class_indices.json", "w") as f:
            json.dump(train_gen.class_indices, f, indent=2)

        val_acc = max(history.history["val_accuracy"])
        print(f"\nBest Validation Accuracy: {val_acc*100:.2f}%")
        print("Models saved to backend/models/")
        return model, history

    except ImportError:
        print("TensorFlow not installed. Run: pip install tensorflow>=2.12")


def predict_disease(image_path, top_k=3):
    """Load saved model and predict disease from leaf image."""
    try:
        import tensorflow as tf
        from tensorflow.keras.preprocessing import image

        model = tf.keras.models.load_model("backend/models/disease_model_best.h5")
        with open("backend/models/disease_class_indices.json") as f:
            idx = json.load(f)
        idx_to_class = {v: k for k, v in idx.items()}

        img = image.load_img(image_path, target_size=(224, 224))
        arr = image.img_to_array(img) / 255.0
        arr = np.expand_dims(arr, axis=0)
        proba = model.predict(arr)[0]
        top_k_idx = np.argsort(proba)[::-1][:top_k]
        results = [{"disease": idx_to_class[i], "confidence": round(float(proba[i])*100, 2)} for i in top_k_idx]
        return results

    except Exception as e:
        print(f"Prediction error: {e}")
        return []


if __name__ == "__main__":
    print(f"Disease Classes ({NUM_CLASSES} total):")
    for i, c in enumerate(DISEASE_CLASSES, 1):
        print(f"  {i:3d}. {c}")
    print("\nTo train: place images in data/disease/images/train/<ClassName>/")
    print("Then call: train_disease_model()")
    model = build_mobilenetv2_model()
