from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import recommendation_routes, disease_routes

app = FastAPI(title="SmartAgri Backend", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def load_models():
    # Placeholder for model loading
    print("Loading ML models (Soil MobileNetV2, Disease EfficientNetB4)...")
    pass

app.include_router(recommendation_routes.router, prefix="/api")
app.include_router(disease_routes.router, prefix="/api")

@app.get("/health")
def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
