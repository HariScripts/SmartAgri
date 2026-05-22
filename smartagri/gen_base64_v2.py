import urllib.request
import base64

urls = {
    'tomato': 'https://loremflickr.com/200/200/tomato,plant/all',
    'wheat': 'https://loremflickr.com/200/200/wheat,plant/all',
    'rice': 'https://loremflickr.com/200/200/rice,plant/all',
    'cotton': 'https://loremflickr.com/200/200/cotton,plant/all',
    'generic': 'https://loremflickr.com/200/200/farm,crop/all'
}

dart_code = "class CropImagesBase64 {\n"

for crop, url in urls.items():
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response:
            b64 = base64.b64encode(response.read()).decode('utf-8')
            dart_code += f"  static const String {crop} = '{b64}';\n"
    except Exception as e:
        print(f"Failed {crop}: {e}")

dart_code += "}\n"

with open("lib/utils/crop_images_base64.dart", "w") as f:
    f.write(dart_code)

print("Generated base64 dart file successfully.")
