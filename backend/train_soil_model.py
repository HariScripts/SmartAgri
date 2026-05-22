import os
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import load_model, Model
from tensorflow.keras.layers import Dense
from tensorflow.keras.optimizers import Adam

print("Loading dataset...")
dataset_dir = r"C:\Users\sriha\Downloads\SmartAgri_v4_Final2\SmartAgri_v4\backend\data\Combined"

datagen = ImageDataGenerator(
    rescale=1./255,
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

train_generator = datagen.flow_from_directory(
    dataset_dir,
    target_size=(224, 224),
    batch_size=16,
    class_mode='categorical',
    subset='training'
)

val_generator = datagen.flow_from_directory(
    dataset_dir,
    target_size=(224, 224),
    batch_size=16,
    class_mode='categorical',
    subset='validation'
)

print(f"Classes: {train_generator.class_indices}")

print("Loading base model...")
base_model_path = os.path.join(os.path.dirname(__file__), "models", "SoilNet_93_86.h5")
base_model = load_model(base_model_path)

# The last layer is a Dense layer with 4 outputs.
x = base_model.layers[-2].output
new_output = Dense(4, activation='softmax', name='new_predictions')(x)

model = Model(inputs=base_model.input, outputs=new_output)

# DEEP FINE TUNING
# Unfreeze the majority of the model so it can learn through blur and noise
for layer in model.layers[:-50]:
    layer.trainable = False
for layer in model.layers[-50:]:
    layer.trainable = True

model.compile(optimizer=Adam(learning_rate=0.0001), loss='categorical_crossentropy', metrics=['accuracy'])

from tensorflow.keras.callbacks import ModelCheckpoint, EarlyStopping

new_model_path = os.path.join(os.path.dirname(__file__), "models", "SoilNet_v2_Custom.h5")

checkpoint = ModelCheckpoint(
    new_model_path, 
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

print("Starting Deep Fine-Tuning Training for Soil (Up to 50 Epochs)...")
history = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=50,
    callbacks=[checkpoint, early_stopping]
)

print(f"Successfully saved robust soil model to {new_model_path}")
