import urllib.request
import urllib.parse
import json

crops = ['tomato', 'wheat', 'rice', 'corn', 'cotton', 'sugarcane', 'jute', 'groundnut', 'millet', 'pulses', 'tobacco', 'potato', 'onion', 'carrot', 'spinach', 'cabbage', 'broccoli', 'cauliflower', 'peas', 'beans', 'soybean', 'sunflower', 'sorghum']

headers = {'User-Agent': 'SmartAgriBot/1.0'}

results = {}

for crop in crops:
    url = f"https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&titles={crop}&pithumbsize=400&format=json"
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read())
            pages = data['query']['pages']
            page_id = list(pages.keys())[0]
            if page_id != '-1' and 'thumbnail' in pages[page_id]:
                img_url = pages[page_id]['thumbnail']['source']
                results[crop] = img_url
            else:
                print(f"No thumbnail for {crop}")
    except Exception as e:
        print(f"Failed {crop}: {e}")

print("final_urls = {")
for k, v in results.items():
    print(f"  '{k}': '{v}',")
print("}")
