# SmartAgri Setup Guide

🚀 **Live Production Web Application**: [https://smartagrisystem.netlify.app/](https://smartagrisystem.netlify.app/)

---

SmartAgri is a comprehensive, production-ready Smart Agricultural System that combines a Flutter cross-platform mobile application with a Python FastAPI backend powered by advanced Machine Learning models.

## Prerequisites
- Flutter SDK 3.x
- Python 3.10+
- Firebase project (Firestore, Auth, Messaging enabled)
- Android Studio / VS Code
- R (for analysis scripts)

## Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Train the machine learning models (requires GPU for optimal speed):
   - **Soil Classification Model:**
     ```bash
     python training/train_soil_model.py
     ```
   - **Disease Detection Model:**
     ```bash
     python training/train_disease_model.py
     ```
4. Start the FastAPI server locally:
   ```bash
   python -m uvicorn main:app --reload
   # Or use the provided script:
   ./start.sh
   ```

## Flutter Setup
1. Create a Firebase project and enable Authentication (Email/Password) and Firestore.
2. Add the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) to the respective directories.
3. Install Flutter dependencies:
   ```bash
   cd smartagri
   flutter pub get
   ```
4. Update the `API_BASE_URL` in `lib/core/constants/app_strings.dart` if your backend is hosted remotely (default is localhost).
5. Run the application:
   ```bash
   flutter run
   ```

## Model Training Notes
- **Soil Model Dataset:** 
  Download the "Soil Types Classification" dataset from Kaggle.
  - URL: [Soil Types Dataset](https://www.kaggle.com/datasets/pythonafroz/soil-types-for-machine-learning)
  - Place in: `backend/training/data/soil/`
  - Expected accuracy: >95% (MobileNetV2)
- **Disease Model Dataset:** 
  Use the PlantVillage dataset supplemented with additional crop images.
  - URL: [PlantDisease Dataset](https://www.kaggle.com/datasets/emmarex/plantdisease)
  - Place in: `backend/training/data/disease/`
  - Expected accuracy: >92% (EfficientNetB4 with TTA)
- **Training time:** Soil model takes ~2hrs on GPU, Disease model takes ~8hrs on GPU. If a local GPU is unavailable, use Google Colab.

## R Analysis Scripts
The `r_analysis` folder contains scripts for data cleaning, crop health visualization, disease risk analysis, and yield distribution.
To generate visualizations:
```bash
Rscript r_analysis/crop_health_viz.R
```
Visualizations are saved directly to the `output/` folder.

## Deployment
- **Backend (Docker):** 
  Deploy the backend container to AWS, GCP, or Render using the included Dockerfile.
  ```bash
  docker-compose up -d
  ```
- **Flutter Mobile App:** 
  Build the production APK for Android:
  ```bash
  flutter build apk --release
  ```
- **Flutter Desktop App:** 
  Build the application for Windows or macOS:
  ```bash
  flutter build windows
  # or
  flutter build macos
  ```
