import urllib.request
import os

crop_urls = {
    'tomato': 'https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg',
    'wheat': 'https://upload.wikimedia.org/wikipedia/commons/a/a3/Kamut_wheat.jpg',
    'rice': 'https://upload.wikimedia.org/wikipedia/commons/7/7b/White_rice.jpg',
    'corn': 'https://upload.wikimedia.org/wikipedia/commons/f/f0/Sweet_corn.jpg',
    'cotton': 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Cotton_Plant.JPG',
    'sugarcane': 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Sugarcane_plantation_in_Mauritius.jpg/640px-Sugarcane_plantation_in_Mauritius.jpg',
    'jute': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Jute_field_in_Bangladesh.jpg/640px-Jute_field_in_Bangladesh.jpg',
    'groundnut': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Peanut_9417.jpg/640px-Peanut_9417.jpg',
    'millet': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Pearl_millet.jpg/640px-Pearl_millet.jpg',
    'pulses': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Dal_makhani_served_in_a_bowl.jpg/640px-Dal_makhani_served_in_a_bowl.jpg',
    'tobacco': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Tobacco_plant.jpg/640px-Tobacco_plant.jpg',
    'potato': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Patates.jpg/640px-Patates.jpg',
    'onion': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Onion_on_White.JPG/640px-Onion_on_White.JPG',
    'carrot': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Carrots_at_Borough_Market.jpg/640px-Carrots_at_Borough_Market.jpg',
    'spinach': 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Spinach.jpg/640px-Spinach.jpg',
    'cabbage': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Cabbage_and_cross_section_on_white.jpg/640px-Cabbage_and_cross_section_on_white.jpg',
    'broccoli': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Broccoli_and_cross_section_edit.jpg/640px-Broccoli_and_cross_section_edit.jpg',
    'cauliflower': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Cauliflower.jpg/640px-Cauliflower.jpg',
    'peas': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Peas_in_pods_-_Studio.jpg/640px-Peas_in_pods_-_Studio.jpg',
    'beans': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Phaseolus_vulgaris_seed.jpg/640px-Phaseolus_vulgaris_seed.jpg',
    'soybean': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Soybean_2.jpg/640px-Soybean_2.jpg',
    'sunflower': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/Sunflower_sky_backdrop.jpg/640px-Sunflower_sky_backdrop.jpg',
    'sorghum': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Sorghum.jpg/640px-Sorghum.jpg',
    'generic': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Agriculture_in_Volgograd_Oblast_002.JPG/640px-Agriculture_in_Volgograd_Oblast_002.JPG'
}

os.makedirs('assets/images/crops', exist_ok=True)

headers = {'User-Agent': 'Mozilla/5.0'}

for name, url in crop_urls.items():
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response, open(f'assets/images/crops/{name}.jpg', 'wb') as out_file:
            data = response.read()
            out_file.write(data)
            print(f"Downloaded {name}.jpg")
    except Exception as e:
        print(f"Failed to download {name}: {e}")
