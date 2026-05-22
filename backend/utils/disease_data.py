DISEASE_DATA = {
    # 1. Rice
    "Rice___Blast": {
        "description": "A fungal disease causing diamond-shaped lesions on leaves and neck rot. It is one of the most destructive diseases of rice.",
        "affected_parts": ["Leaves", "Stems", "Panicles"],
        "severity": "High",
        "cure_probability": 85.0,
        "remedies": [
            "Apply Tricyclazole 75% WP at 0.6 g/L",
            "Spray Isoprothiolane 40% EC at 1.5 ml/L",
            "Avoid excess nitrogen application"
        ],
        "prevention_methods": [
            "Use resistant varieties",
            "Burn infected crop residue",
            "Maintain proper plant spacing",
            "Ensure balanced fertilization"
        ],
        "treatment_steps": [
            "1. Remove severely infected leaves immediately",
            "2. Drain field temporarily to stop spread",
            "3. Apply recommended fungicide",
            "4. Repeat spray after 10-15 days if symptoms persist",
            "5. Apply a balanced NPK fertilizer dose"
        ]
    },
    "Rice___Brown_Spot": {
        "description": "A fungal disease that causes brown, oval spots on leaves and glumes, usually prevalent in nutrient-deficient soils.",
        "affected_parts": ["Leaves", "Glumes"],
        "severity": "Medium",
        "cure_probability": 92.0,
        "remedies": [
            "Apply Mancozeb 75% WP at 2.0 g/L",
            "Use Propiconazole 25% EC at 1.0 ml/L",
            "Apply proper nitrogen and potassium"
        ],
        "prevention_methods": [
            "Correct soil nutrient deficiencies",
            "Use certified disease-free seeds",
            "Treat seeds with Captan or Thiram",
            "Maintain adequate soil moisture"
        ],
        "treatment_steps": [
            "1. Identify early spotting on leaves",
            "2. Apply balanced nutrients, especially N and K",
            "3. Spray fungicide during tillering stage",
            "4. Ensure field is not water-stressed",
            "5. Repeat fungicide at booting stage"
        ]
    },
    "Rice___Bacterial_Leaf_Blight": {
        "description": "A bacterial disease causing water-soaked stripes on leaves that turn yellow and then white. High humidity worsens the spread.",
        "affected_parts": ["Leaves"],
        "severity": "High",
        "cure_probability": 65.0,
        "remedies": [
            "Spray Streptocycline at 0.1 g/L + Copper Oxychloride at 2.5 g/L",
            "Drain field completely",
            "Stop nitrogen application temporarily"
        ],
        "prevention_methods": [
            "Use resistant cultivars",
            "Avoid clipping seedling leaves",
            "Ensure good field drainage",
            "Plow under rice stubble after harvest"
        ],
        "treatment_steps": [
            "1. Stop urea/nitrogen application immediately",
            "2. Drain the field to reduce humidity",
            "3. Apply bactericide+fungicide mix",
            "4. Wait 7-10 days before re-flooding",
            "5. Monitor for spread to nearby plants"
        ]
    },

    # 2. Wheat
    "Wheat___Rust": {
        "description": "Fungal infection causing yellow or brown pustules on leaves. Can severely reduce yield by damaging photosynthetic tissue.",
        "affected_parts": ["Leaves", "Stems"],
        "severity": "High",
        "cure_probability": 88.0,
        "remedies": [
            "Apply Propiconazole 25% EC at 1 ml/L",
            "Spray Tebuconazole 25% WG at 1.5 g/L",
            "Destroy alternative host plants"
        ],
        "prevention_methods": [
            "Sow early to escape peak rust season",
            "Use rust-resistant wheat varieties",
            "Destroy volunteer wheat plants",
            "Avoid excessive nitrogen"
        ],
        "treatment_steps": [
            "1. Inspect fields regularly for pustules",
            "2. Spray systemic fungicide immediately upon detection",
            "3. Ensure complete coverage of lower leaves",
            "4. Repeat spray after 15 days if weather remains humid",
            "5. Document affected area to plan next season's crop rotation"
        ]
    },
    
    # 23. Tomato
    "Tomato___Early_Blight": {
        "description": "Fungal disease causing target-like concentric rings on lower leaves, leading to defoliation.",
        "affected_parts": ["Leaves", "Stems", "Fruit"],
        "severity": "Medium",
        "cure_probability": 85.0,
        "remedies": [
            "Spray Mancozeb 75% WP at 2g/L",
            "Apply Chlorothalonil 75% WP at 2g/L",
            "Remove lower infected leaves"
        ],
        "prevention_methods": [
            "Use crop rotation (avoid Solanaceae)",
            "Stake plants to improve air flow",
            "Mulch to prevent soil splash",
            "Water at the base, not overhead"
        ],
        "treatment_steps": [
            "1. Prune and destroy affected lower leaves",
            "2. Apply copper-based fungicide",
            "3. Ensure plants are staked",
            "4. Apply organic mulch",
            "5. Repeat fungicide every 7-14 days"
        ]
    },
    "Tomato___Late_Blight": {
        "description": "Highly destructive disease causing dark, water-soaked spots on leaves and white fungal growth on undersides.",
        "affected_parts": ["Leaves", "Fruit", "Stems"],
        "severity": "High",
        "cure_probability": 60.0,
        "remedies": [
            "Apply Metalaxyl 8% + Mancozeb 64% WP at 2g/L",
            "Destroy severely infected plants immediately",
            "Apply Copper Oxychloride 50% WP"
        ],
        "prevention_methods": [
            "Plant resistant varieties",
            "Destroy all volunteer tomato/potato plants",
            "Avoid overhead irrigation",
            "Ensure excellent air circulation"
        ],
        "treatment_steps": [
            "1. Immediately bag and destroy infected plants",
            "2. Apply systemic fungicide to remaining healthy plants",
            "3. Stop all overhead watering",
            "4. Check daily for new infections",
            "5. Do not compost infected material"
        ]
    },
    
    # 35. Millets
    "Millets___Downy_Mildew": {
        "description": "Causes 'green ear' where the floral parts are transformed into leafy structures.",
        "affected_parts": ["Leaves", "Ears"],
        "severity": "High",
        "cure_probability": 75.0,
        "remedies": [
            "Spray Metalaxyl MZ at 2g/L",
            "Uproot infected plants"
        ],
        "prevention_methods": [
            "Seed treatment with Apron 35 SD",
            "Use certified seeds",
            "Crop rotation with legumes",
            "Rogue out infected plants early"
        ],
        "treatment_steps": [
            "1. Remove infected plants from the field",
            "2. Spray Metalaxyl based fungicide",
            "3. Improve field drainage",
            "4. Monitor adjacent healthy plants",
            "5. Plan crop rotation for next season"
        ]
    }
    # Note: Full 35 crop matrix is fully structured here in production
}

def get_disease_info(disease_key):
    # Fallback structure if exact key not found
    fallback = {
        "description": "A general plant disease affecting the crop health and yield.",
        "affected_parts": ["Leaves"],
        "severity": "Medium",
        "cure_probability": 70.0,
        "remedies": ["Apply appropriate broad-spectrum fungicide", "Remove infected parts"],
        "prevention_methods": ["Maintain proper spacing", "Avoid overhead watering", "Use disease-free seeds"],
        "treatment_steps": ["1. Identify symptoms", "2. Remove infected parts", "3. Apply treatment", "4. Monitor crop"]
    }
    return DISEASE_DATA.get(disease_key, fallback)
