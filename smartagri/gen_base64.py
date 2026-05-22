import urllib.request
import base64

urls = {
    'tomato': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Tomato_je.jpg/200px-Tomato_je.jpg',
    'wheat': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Vehn%C3%A4pelto_6.jpg/200px-Vehn%C3%A4pelto_6.jpg',
    'rice': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/20201102.Hengnan.Hybrid_rice_Sanyou-1.6.jpg/200px-20201102.Hengnan.Hybrid_rice_Sanyou-1.6.jpg',
    'cotton': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/CottonPlant.JPG/200px-CottonPlant.JPG',
    'sugarcane': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Saccharum_officinarum_-_K%C3%B6hler%E2%80%93s_Medizinal-Pflanzen-125.jpg/200px-Saccharum_officinarum.jpg',
    'generic': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Agriculture_in_Volgograd_Oblast_002.JPG/200px-Agriculture_in_Volgograd_Oblast_002.JPG'
}

headers = {'User-Agent': 'SmartAgriBot/1.0'}

dart_code = "class CropImagesBase64 {\n"

for crop, url in urls.items():
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response:
            b64 = base64.b64encode(response.read()).decode('utf-8')
            dart_code += f"  static const String {crop} = '{b64}';\n"
    except Exception as e:
        print(f"Failed {crop}: {e}")

dart_code += "}\n"

with open("lib/utils/crop_images_base64.dart", "w") as f:
    f.write(dart_code)

print("Generated base64 dart file.")
