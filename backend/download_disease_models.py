import os
from huggingface_hub import snapshot_download

models = [
    "animeshakr/plant-disease-efficientnetv2s",
    "JK-TK/PlantDiseaseDetection",
    "itzsherlockz/plant-disease-mobilenetv2",
    "liriope/PlantDiseaseDetection"
]

base_dir = os.path.join(os.path.dirname(__file__), "models", "disease_ensemble")
os.makedirs(base_dir, exist_ok=True)

print("Starting to download models. This may take a few minutes depending on file sizes...")

for repo_id in models:
    print(f"Downloading {repo_id}...")
    try:
        repo_name = repo_id.split("/")[-1]
        save_path = os.path.join(base_dir, repo_name)
        snapshot_download(repo_id=repo_id, local_dir=save_path, local_dir_use_symlinks=False)
        print(f"Successfully downloaded {repo_id} to {save_path}")
    except Exception as e:
        print(f"Failed to download {repo_id}. Error: {e}")

print("All model downloads completed.")
