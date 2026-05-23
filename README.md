# SmartAgri — AI-Powered Precision Agriculture System

<div align="center">

### 🚀 Live Demo
[![Netlify Status](https://api.netlify.com/api/v1/badges/placeholder/deploy-status)](https://smartagrisystem.netlify.app/)

**[▶ Open Live App → smartagrisystem.netlify.app](https://smartagrisystem.netlify.app/)**

*Login with:* `farmer12345@gmail.com` / `farmer12345` — or create your own account

---

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python)
![R](https://img.shields.io/badge/R-Analysis-276DC3?logo=r)
![Flask](https://img.shields.io/badge/Flask-Backend-000000?logo=flask)
![Netlify](https://img.shields.io/badge/Deployed-Netlify-00C7B7?logo=netlify)

</div>

---

SmartAgri is a comprehensive, production-ready Smart Agricultural System that combines a Flutter cross-platform web application with a Python Flask backend powered by advanced Machine Learning models. It helps farmers make data-driven decisions using AI soil classification, IoT sensor data, crop recommendations, and disease detection.

## ✨ Latest Features (v4 — May 2025)

| Feature | Description |
|---|---|
| 📖 **Analytics Guide** | Plain-language guide explaining Summary Statistics, Pair Plots & Correlation Heatmaps — no data science knowledge needed |
| 📏 **SD Sensitivity Scale** | Colour-coded badges (🔴 Sensitive → 🟢 Very Tolerant) shown inline with every soil metric |
| 🔒 **Secure Authentication** | Fixed login bug — now validates exact email + password; wrong passwords are rejected with clear error messages |
| 📈 **High-Res Pair Plots** | 300 DPI, 5400×4800 px pair plots with responsive fullscreen viewer and 10× pinch-to-zoom |
| 📊 **Fullscreen Split-Screen Dialog** | Wide-screen layout shows plot + metadata side-by-side for maximum readability |
| 🌦️ **Live Weather Suitability** | Real-time weather matched against crop water needs to show suitability score |

## 🔑 Core Capabilities

- 🌱 **AI Crop Recommendation** — Soil sensor input → ML-ranked crop list with confidence scores
- 🔬 **Soil Classification** — Deep learning (MobileNetV2, >95% accuracy) image-based soil type detection
- 🦠 **Disease Detection** — EfficientNetB4 plant disease detection from leaf photos (>92% accuracy)
- 📡 **IoT Sensor Integration** — Live N/P/K, temperature, moisture, pH, and rainfall telemetry
- 📊 **Statistical Analytics** — Summary stats, pair plots, and correlation heatmaps per crop
- 🗺️ **Farm Management** — Multi-farm dashboard with field mapping and history

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter 3.x (Web, Android, iOS, Desktop) |
| Backend | Python · Flask · scikit-learn |
| ML Models | MobileNetV2 · EfficientNetB4 · Random Forest |
| Data Analysis | R · matplotlib · pandas |
| Database | Firebase Firestore · Hive (local) |
| Auth | Local credential store (Firebase Auth ready) |
| Deployment | Netlify (web) · Docker-ready (backend) |

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.x
- Python 3.10+
- R (for analysis scripts)

### Backend
```bash
cd backend
pip install -r requirements.txt
python app.py
```

### Flutter App
```bash
cd smartagri
flutter pub get
flutter run -d chrome    # web
flutter run              # mobile
```

### Build for Production
```bash
flutter build web --release
# Deploy smartagri/build/web/ to Netlify
```

## 📊 ML Model Details

| Model | Dataset | Architecture | Accuracy |
|---|---|---|---|
| Soil Classification | [Soil Types (Kaggle)](https://www.kaggle.com/datasets/pythonafroz/soil-types-for-machine-learning) | MobileNetV2 | >95% |
| Disease Detection | [PlantVillage (Kaggle)](https://www.kaggle.com/datasets/emmarex/plantdisease) | EfficientNetB4 + TTA | >92% |
| Crop Recommendation | crop_recommendation.csv | Random Forest | >97% |

Training time: ~2hrs (Soil) · ~8hrs (Disease) on GPU. Use Google Colab if no local GPU.

## 📁 Project Structure

```
SmartAgri/
├── backend/          # Flask API + ML models
├── smartagri/        # Flutter app
│   └── lib/
│       ├── screens/  # UI screens
│       ├── providers/# State management
│       ├── models/   # Data models
│       └── services/ # API & notifications
├── r_analysis/       # R + Python analytics scripts
├── data/             # Crop datasets
└── models/           # Trained ML model files
```

## 🌐 Deployment

- **Web App** → [smartagrisystem.netlify.app](https://smartagrisystem.netlify.app/) (Netlify)
- **Backend** → Docker-ready for AWS / GCP / Render
  ```bash
  docker-compose up -d
  ```
- **Android APK**
  ```bash
  flutter build apk --release
  ```

## 📄 License

MIT License — free to use, modify, and distribute.

---

<div align="center">
Built with ❤️ for farmers · <a href="https://smartagrisystem.netlify.app/">Live Demo</a>
</div>
