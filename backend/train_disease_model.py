import os
import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout
from tensorflow.keras.models import Model
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam

# Paths
base_dir = os.path.dirname(__file__)
dataset_dir = r"C:\Users\sriha\Downloads\disease dataset"
model_save_path = os.path.join(base_dir, "models/DiseaseNet_Custom.h5")

def train_custom_disease_model():
    print("Initializing Custom Disease AI Training Pipeline...")

    # Advanced Data Augmentation for Blur & Bad Lighting Resistance
    from tensorflow.keras.applications.mobilenet_v2 import preprocess_input

    train_datagen = ImageDataGenerator(
        preprocessing_function=preprocess_input,
        rotation_range=40,
        width_shift_range=0.3,
        height_shift_range=0.3,
        shear_range=0.3,
        zoom_range=0.4,
        brightness_range=[0.4, 1.5], # Simulates very bad/dark lighting
        horizontal_flip=True,
        fill_mode='nearest',
        validation_split=0.2
    )

    train_generator = train_datagen.flow_from_directory(
        dataset_dir,
        target_size=(224, 224),
        batch_size=32,
        class_mode='categorical',
        subset='training'
    )

    test_generator = train_datagen.flow_from_directory(
        dataset_dir,
        target_size=(224, 224),
        batch_size=32,
        class_mode='categorical',
        subset='validation'
    )

    num_classes = len(train_generator.class_indices)
    print(f"Detected {num_classes} custom disease classes from New Dataset.")

    # Save class indices
    import json
    with open(os.path.join(base_dir, "models/disease_classes.json"), "w") as f:
        json.dump(train_generator.class_indices, f)

    # Base Model (Transfer Learning)
    base_model = MobileNetV2(weights='imagenet', include_top=False, input_shape=(224, 224, 3))
    
    # DEEP FINE-TUNING: Unfreeze the top layers of the base model so it can learn to see through blur!
    base_model.trainable = True
    # Freeze the very bottom layers (which detect basic shapes), unfreeze the rest
    for layer in base_model.layers[:100]:
        layer.trainable = False

    # Custom Top Layers
    x = base_model.output
    x = GlobalAveragePooling2D()(x)
    x = Dense(512, activation='relu')(x)
    x = Dropout(0.5)(x)
    predictions = Dense(num_classes, activation='softmax')(x)

    model = Model(inputs=base_model.input, outputs=predictions)

    # Compile with a very low learning rate for deep fine-tuning
    model.compile(optimizer=Adam(learning_rate=0.0001), 
                  loss='categorical_crossentropy', 
                  metrics=['accuracy'])

    # Callbacks for optimal training
    from tensorflow.keras.callbacks import ModelCheckpoint, EarlyStopping
    
    checkpoint = ModelCheckpoint(
        model_save_path, 
        monitor='val_accuracy', 
        save_best_only=True, 
        mode='max', 
        verbose=1
    )
    
    early_stopping = EarlyStopping(
        monitor='val_loss', 
        patience=10, 
        restore_best_weights=True,
        verbose=1
    )

    print("Starting Full Production Training (Up to 50 Epochs)...")
    history = model.fit(
        train_generator,
        epochs=50,
        validation_data=test_generator,
        callbacks=[checkpoint, early_stopping]
    )

    print("Training Complete!")
    print(f"Best model automatically saved to {model_save_path}!")

if __name__ == "__main__":
    train_custom_disease_model()
