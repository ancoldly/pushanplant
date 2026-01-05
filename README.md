# Pushan Plant App

> Mobile app (Flutter) + model server (FastAPI) to detect plant leaf diseases using a simple CNN.
> Users upload or capture a leaf photo, the app sends it to a CNN model (served by FastAPI) and returns a prediction. A chatbot (via GenMini API) helps users learn more about diseases and treatments. User data and disease metadata are stored in Firebase.

- Status: Work in progress
- Language: Dart (Flutter) for the client, Python (FastAPI) for the model server
- Mobile UI tooling: Android Studio
- Platform: Android / iOS (Flutter)

## Table of contents
- [Overview](#overview)
- [Key goals](#key-goals)
- [Features](#features)
- [Screens](#screens)
- [Architecture](#architecture)
- [Tech stack](#tech-stack)
- [Repository layout (recommended)](#repository-layout-recommended)
- [Setup & Run](#setup--run)
  - [Frontend (Flutter)](#frontend-flutter)
  - [Backend (FastAPI model server)](#backend-fastapi-model-server)
  - [Firebase setup](#firebase-setup)
- [Model training & placement](#model-training--placement)
- [API examples](#api-examples)
- [Chatbot (GenMini) integration](#chatbot-genmini-integration)
- [Testing & debugging tips](#testing--debugging-tips)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Screenshots / UI mockups](#screenshots--ui-mockups)

## Overview
Pushan Plant App is a Flutter mobile application that helps users identify diseases on plant leaves. The app captures or receives a photo of a leaf, forwards it to a CNN model served by a FastAPI backend for inference, and returns the predicted disease (with a confidence score and brief guidance). Users can also chat with a GenMini-powered chatbot to get more information and advice. User accounts, posts, and disease reference data are stored in Firebase.

## Key goals
- Build responsive Flutter UIs & layouts
- Learn debugging on simulators and physical devices
- Implement basic state management and local & cloud storage
- Create a simple CNN-based image classifier and serve it via FastAPI
- Integrate Firebase for authentication, Firestore, and storage
- Provide a chatbot for disease info lookup

## Features
- Leaf disease detection from camera or gallery images
- Prediction screen showing label, confidence, and brief info
- Chatbot to ask about disease symptoms & treatment (GenMini API)
- Feed / sharing area for user and admin posts about plant health
- User profile screen to view/edit user info
- Search and browse disease catalog
- Firebase-backed user data and disease metadata

## Screens
- Home: project/summary, disease categories, search
- Predict: capture/select image → submit → view prediction & details
- Chatbot: conversation with GenMini for deeper info
- Feed / Share: user posts, admin posts, like/comment
- User: profile and settings

## Architecture
- Flutter app (mobile client) → calls:
  - Firebase (Auth, Firestore, Storage) for user data and disease content
  - Model server (FastAPI) for inference (POST image → JSON result)
  - GenMini API (proxy via backend or direct from app) for chatbot responses

A minimal sequence:
1. User picks/takes image in Flutter app
2. App uploads image to FastAPI /predict endpoint (or to Firebase Storage and sends URL)
3. FastAPI loads saved CNN model, runs inference, returns JSON {label, confidence, info}
4. Flutter shows prediction; user may query chatbot for more info

## Tech stack
- Frontend: Flutter (Dart)
- Backend (model server): Python + FastAPI
- Model: Convolutional Neural Network (TensorFlow/Keras recommended)
- Database / Auth / Storage: Firebase (Firestore, Firebase Auth, Storage)
- Tools: Android Studio, Flutter SDK, curl, requests

## Repository layout (recommended)
- /app_flutter/           # Flutter project
- /server/                # FastAPI model server (Python)
  - app.py                # FastAPI app
  - requirements.txt
  - model/                # saved model files
- /docs/                  # screenshots, design assets
- README.md
- LICENSE

## Setup & Run

### Frontend (Flutter)
Prerequisites:
- Flutter SDK installed: https://flutter.dev/docs/get-started/install
- Android Studio (or Xcode for iOS)
- Firebase project & client config files added to Flutter app

Basic commands:
```bash
# from repository root or app_flutter/
flutter pub get
flutter analyze

# run on connected device or emulator
flutter run

# run on specific device
flutter run -d <device-id>

# build release apk
flutter build apk --release
```

Notes:
- Add Firebase config files:
  - Android: android/app/google-services.json
  - iOS: ios/Runner/GoogleService-Info.plist
- Configure firebase options in Flutter (e.g., using firebase_core).
- Store sensitive keys (GenMini API key) in secure storage or server-side proxy; do NOT hardcode them.

### Backend (FastAPI model server)
Prerequisites:
- Python 3.8+
- Virtual environment recommended
- The model file (TensorFlow SavedModel or a .h5) placed in server/model/

Basic commands:
```bash
# from server/
python -m venv venv
source venv/bin/activate      # macOS / Linux
venv\Scripts\activate.bat     # Windows

pip install -r requirements.txt
# Example requirements: fastapi, uvicorn, tensorflow, pillow, python-multipart, requests

# Run FastAPI (development)
uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

Typical endpoints (implement in app.py):
- POST /predict — multipart/form-data with image file; returns JSON: {label, confidence, details}
- GET /health — health check

Example server skeleton (you can adapt):
```python
# app.py (high-level)
from fastapi import FastAPI, File, UploadFile
from PIL import Image
import io, numpy as np, tensorflow as tf

app = FastAPI()
model = tf.keras.models.load_model("model/saved_model")

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    contents = await file.read()
    img = Image.open(io.BytesIO(contents)).convert("RGB").resize((224,224))
    arr = np.array(img)/255.0
    arr = np.expand_dims(arr, 0)
    preds = model.predict(arr)
    # map preds -> label, confidence
    return {"label": "...", "confidence": 0.92}
```

### Firebase setup
1. Create Firebase project at https://console.firebase.google.com/
2. Enable Authentication (email/password or providers you need)
3. Create Firestore database and Storage bucket
4. Add Android and/or iOS apps in Firebase console and download client config files:
   - android/app/google-services.json → place in Android app folder
   - ios/Runner/GoogleService-Info.plist → place in iOS app folder
5. Initialize Firebase in Flutter (firebase_core, firebase_auth, cloud_firestore, firebase_storage packages)
6. Add Firestore rules and indexes as needed

Environment variables / config (examples):
- For backend:
  - MODEL_PATH=server/model/saved_model
  - GENMINI_API_KEY=your_genmini_key
- For Flutter:
  - Use firebase options files and runtime config if needed

## Model training & placement
- Train a simple CNN (TensorFlow/Keras recommended) offline using your dataset of leaf images and disease labels.
- Save the model to server/model/ in a format your server can load (SavedModel or .h5).
- Keep dataset and training code in a separate folder (e.g., /training) — not required for app runtime.

Training tip:
- Start with a small CNN (Conv2D → Pooling → Dense), augment data, use categorical_crossentropy for multi-class classification.
- Export labels mapping (e.g., labels.json) and include it in the server to translate model outputs to human-readable disease names and brief descriptions.

## API examples

Curl example (POST image):
```bash
curl -X POST "http://localhost:8000/predict" \
  -F "file=@/path/to/leaf.jpg"
```

Expected JSON response:
```json
{
  "label": "Leaf Blight",
  "confidence": 0.9123,
  "info": "Short description of the disease and suggested steps."
}
```

## Chatbot (GenMini) integration
- You can either call GenMini from Flutter directly (not recommended for secret API keys) or via your FastAPI backend (recommended).
- Store the GenMini API key in an environment variable on the server: GENMINI_API_KEY.
- Backend endpoint example:
  - POST /chat { "message": "What are treatments for leaf blight?" } → backend forwards to GenMini and returns response to app.

Backend pseudocode:
```python
import os, requests
GENMINI_API_KEY = os.getenv("GENMINI_API_KEY")

def genmini_query(prompt):
    resp = requests.post(
      "https://api.genmini.example/v1/generate",
      headers={"Authorization": f"Bearer {GENMINI_API_KEY}"},
      json={"prompt": prompt}
    )
    return resp.json()
```

## Testing & debugging tips
- Use Flutter DevTools & Android Studio for UI debugging and performance profiling.
- Test on both emulator and a physical device.
- Use Postman / curl to test FastAPI endpoints independently.
- If model inference is slow on CPU, reduce image size or optimize the model (quantize, pruning) or host inference on a GPU server.

## Contributing
- Fork the repository
- Create a branch: git checkout -b feature/your-feature
- Commit & push changes
- Create a Pull Request describing your changes

Add a CONTRIBUTING.md for contribution rules if desired.

## License
Specify a license (e.g., MIT). Add a LICENSE file in the repo.

## Contact
- Maintainer: ancoldly (GitHub)
- Email: (add your contact email)

## Screenshots / UI mockups

### Home
![Home](docs/screenshot-home.png)

### Chat
![Chat](docs/screenshot-chat.png)

### Search
![Search](docs/screenshot-search.png)

### Predict
![Predict](docs/screenshot-predict.png)

### Social
![Social](docs/screenshot-social.png)

### User
![User](docs/screenshot-user.png)

### Admin Dashboard
![Admin Dashboard](docs/screenshot-dashboard-admin.png)

### Admin Edit
![Admin Edit](docs/screenshot-admin-edit.png)
