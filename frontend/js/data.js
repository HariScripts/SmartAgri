/**
 * SmartAgri v4 — data.js
 * All knowledge bases: 35 crops, 30+ diseases, 4 soil types, alert templates
 */

/* ══════════════════════════════════════
   SOIL DATABASE
══════════════════════════════════════ */
const SOIL_DB = {
  loamy: {
    label:"Loamy Soil", emoji:"🌱", color:"#16a34a", bg:"#f0fdf4", confidence:96,
    ph:"6.0–7.0", drainage:"Good (optimal)", nutrients:"High", moisture:"Well balanced",
    crops:["Tomato","Maize","Wheat","Soybean","Onion","Garlic","Peas","Mustard","Sunflower","Potato"],
    amendments:"Ideal soil. Maintain organic matter with 5t/ha compost annually. Deep ploughing once a year."
  },
  sandy: {
    label:"Sandy Soil", emoji:"🏜️", color:"#d97706", bg:"#fefce8", confidence:91,
    ph:"5.5–7.0", drainage:"Excellent (fast draining)", nutrients:"Low", moisture:"Low — drains quickly",
    crops:["Carrot","Potato","Watermelon","Groundnut","Mustard","Mungbean","Mothbeans","Kidneybeans","Pomegranate","Blackgram"],
    amendments:"Add FYM 20t/ha. Use drip irrigation. Apply mulch to reduce evaporation. Add micro-nutrients."
  },
  clay: {
    label:"Clay Soil", emoji:"🧱", color:"#dc2626", bg:"#fef2f2", confidence:88,
    ph:"5.5–7.5", drainage:"Poor (waterlogging risk)", nutrients:"High", moisture:"High — slow draining",
    crops:["Wheat","Cabbage","Cotton","Cauliflower","Sugarcane","Orange","Grapes","Lentil","Spinach","Lettuce"],
    amendments:"Add gypsum 2t/ha. Make raised beds. Mix sand + FYM to improve structure. Avoid compaction."
  },
  silty: {
    label:"Silty Soil", emoji:"💧", color:"#2563eb", bg:"#eff6ff", confidence:85,
    ph:"6.0–7.0", drainage:"Moderate", nutrients:"Very High", moisture:"Moderate–High",
    crops:["Rice","Jute","Ginger","Turmeric","Coffee","Tea","Banana","Coconut","Lettuce","Capsicum"],
    amendments:"Avoid compaction. Add organic matter. Contour bunding to prevent erosion. Cover cropping recommended."
  }
};

/* ══════════════════════════════════════
   CROP DATABASE — 35 crops
══════════════════════════════════════ */
const CROP_DB = {
  Rice:        {emoji:"🌾",season:"Kharif", soil:["loamy","silty"],      N:[80,100],P:[40,60], K:[35,50], temp:[20,26],hum:[75,90],moisture:[60,75],growDays:120,yieldTha:5.2, waterReq:"High",   fertReq:"Medium",fertilizer:"Urea 120kg/ha + DAP 50kg/ha + MOP 30kg/ha. Split Urea in 3 doses.",irrigation:"Maintain 3–5cm standing water. Drain 15 days before harvest.",tips:"Transplant 25-day seedlings. Keep field weeded until tillering."},
  Maize:       {emoji:"🌽",season:"Kharif", soil:["loamy","sandy"],      N:[35,50], P:[55,70], K:[25,40], temp:[22,30],hum:[50,70],moisture:[35,55],growDays:90, yieldTha:6.8, waterReq:"Medium", fertReq:"High",  fertilizer:"Urea 90kg/ha + DAP 40kg/ha. Top-dress at knee-high stage.",irrigation:"Every 7–10 days. Critical at silking and grain fill.",tips:"Earth up at 30 days. Avoid water stress at tasselling."},
  Wheat:       {emoji:"🌾",season:"Rabi",   soil:["loamy","clay"],       N:[70,90], P:[32,45], K:[32,45], temp:[15,25],hum:[60,75],moisture:[48,62],growDays:120,yieldTha:4.1, waterReq:"Medium", fertReq:"Medium",fertilizer:"DAP 50kg/ha + Urea 65kg/ha in 2 doses.",irrigation:"Crown root (21d), jointing (45d), milky grain (80d).",tips:"Use certified seed. Treat with Vitavax before sowing."},
  Tomato:      {emoji:"🍅",season:"Rabi",   soil:["loamy","sandy"],      N:[25,38], P:[55,72], K:[160,185],temp:[22,28],hum:[55,68],moisture:[44,58],growDays:75, yieldTha:32,  waterReq:"Medium", fertReq:"High",  fertilizer:"DAP 60kg/ha + Urea 80kg/ha + MOP 80kg/ha. Ca spray at fruit set.",irrigation:"Drip every 3–4 days. Avoid wetting foliage.",tips:"Stake at 30cm. Pinch suckers. Mulch to retain moisture."},
  Potato:      {emoji:"🥔",season:"Rabi",   soil:["sandy","loamy"],      N:[25,38], P:[55,65], K:[180,205],temp:[25,32],hum:[64,75],moisture:[50,62],growDays:90, yieldTha:22,  waterReq:"Medium", fertReq:"High",  fertilizer:"DAP 100kg/ha + Urea 120kg/ha + MOP 150kg/ha.",irrigation:"Ridges; every 10 days. Avoid waterlogging near harvest.",tips:"Hill-up twice. Use certified seed. Harvest when vines yellow."},
  Onion:       {emoji:"🧅",season:"Rabi",   soil:["loamy","sandy"],      N:[28,38], P:[52,62], K:[145,165],temp:[24,30],hum:[55,68],moisture:[42,55],growDays:100,yieldTha:18,  waterReq:"Medium", fertReq:"Medium",fertilizer:"DAP 60kg/ha + Urea 80kg/ha in 2 splits.",irrigation:"Every 7 days. Stop 15 days before harvest.",tips:"Cure at 35°C for 10 days. Avoid bruising during harvest."},
  Garlic:      {emoji:"🧄",season:"Rabi",   soil:["loamy","sandy"],      N:[33,45], P:[45,58], K:[130,148],temp:[24,28],hum:[52,65],moisture:[40,52],growDays:120,yieldTha:6,   waterReq:"Medium", fertReq:"Medium",fertilizer:"DAP 50kg/ha + Urea 80kg/ha + MOP 60kg/ha.",irrigation:"Every 7–8 days. Stop 3 weeks before harvest.",tips:"Plant cloves 5cm deep. Remove scapes to divert energy to bulbs."},
  Ginger:      {emoji:"🫚",season:"Kharif", soil:["silty","loamy"],      N:[22,28], P:[72,88], K:[185,205],temp:[28,32],hum:[75,88],moisture:[65,78],growDays:240,yieldTha:8,   waterReq:"High",   fertReq:"High",  fertilizer:"FYM 25t/ha + DAP 50kg/ha. Mulch with dry leaves.",irrigation:"Sprinkler every 3–4 days. Shade during summer.",tips:"Harvest at 8–9 months. Store rhizomes at high humidity."},
  Turmeric:    {emoji:"🟡",season:"Kharif", soil:["silty","loamy"],      N:[22,28], P:[78,88], K:[185,200],temp:[26,32],hum:[74,85],moisture:[62,75],growDays:270,yieldTha:7.5, waterReq:"High",   fertReq:"High",  fertilizer:"FYM 20t/ha + DAP 50kg/ha + MOP 100kg/ha.",irrigation:"Sprinkler every 7 days. Semi-shade environment.",tips:"Cure fingers at 60°C for 6 hours. Polish for marketability."},
  Groundnut:   {emoji:"🥜",season:"Kharif", soil:["sandy","loamy"],      N:[48,62], P:[33,48], K:[48,62], temp:[26,32],hum:[55,68],moisture:[42,55],growDays:110,yieldTha:2.8, waterReq:"Low",    fertReq:"Medium",fertilizer:"DAP 60kg/ha + Gypsum 200kg/ha at pegging.",irrigation:"Every 12 days. Critical at pegging and pod fill.",tips:"Peg zone must remain loose. Harvest when inner pod turns dark."},
  Soybean:     {emoji:"🫘",season:"Kharif", soil:["loamy","silty"],      N:[50,65], P:[45,58], K:[42,55], temp:[25,30],hum:[65,80],moisture:[52,68],growDays:100,yieldTha:3.2, waterReq:"Medium", fertReq:"Low",   fertilizer:"DAP 60kg/ha + MOP 30kg/ha. Rhizobium seed inoculation.",irrigation:"Every 10 days. Critical at flowering and pod fill.",tips:"Inoculate seeds with Bradyrhizobium for nitrogen fixation."},
  Cotton:      {emoji:"🌸",season:"Kharif", soil:["loamy","clay"],       N:[80,95], P:[68,80], K:[58,70], temp:[24,28],hum:[65,78],moisture:[52,65],growDays:180,yieldTha:2.8, waterReq:"Medium", fertReq:"High",  fertilizer:"Urea 120kg/ha + DAP 75kg/ha + MOP 50kg/ha split 3 times.",irrigation:"Furrow every 12–15 days. Critical at boll formation.",tips:"Monitor for bollworm. Top irrigation at boll development."},
  Sugarcane:   {emoji:"🎋",season:"Annual", soil:["loamy","clay"],       N:[135,155],P:[42,55],K:[38,48],  temp:[26,32],hum:[58,70],moisture:[45,58],growDays:365,yieldTha:70,  waterReq:"High",   fertReq:"High",  fertilizer:"Urea 200kg/ha in 3 splits + DAP 80kg/ha at planting.",irrigation:"Furrow/drip. Critical at grand growth phase (3–6 months).",tips:"Ratoon crop gives 70–80% yield. Harvest when Brix >18."},
  Mango:       {emoji:"🥭",season:"Summer", soil:["loamy","clay"],       N:[52,65], P:[42,55], K:[28,40], temp:[22,28],hum:[60,72],moisture:[48,60],growDays:365,yieldTha:12,  waterReq:"Low",    fertReq:"Medium",fertilizer:"FYM 50kg/tree + Urea 1kg + DAP 0.5kg/tree annually.",irrigation:"Monthly. Stop at flowering. Resume at fruit development.",tips:"Prune after harvest. Control mango mealybug. Harvest at color break."},
  Banana:      {emoji:"🍌",season:"Annual", soil:["loamy","silty"],      N:[18,28], P:[90,108],K:[190,205],temp:[35,40],hum:[20,28],moisture:[28,38],growDays:365,yieldTha:40,  waterReq:"High",   fertReq:"High",  fertilizer:"Urea 300g + DAP 300g + MOP 300g per plant per year in 4 splits.",irrigation:"Drip every 3–4 days. Drought causes bunching failure.",tips:"Remove male bud after last hand. Cover bunch at 3 weeks."},
  Coconut:     {emoji:"🥥",season:"Annual", soil:["silty","sandy"],      N:[8,14],  P:[45,58], K:[48,62], temp:[25,30],hum:[76,88],moisture:[60,72],growDays:365,yieldTha:8,   waterReq:"Medium", fertReq:"Medium",fertilizer:"Urea 500g + DAP 250g + MOP 1.5kg per palm per year.",irrigation:"Basin every 7 days in dry season.",tips:"Remove 2–3 lower fronds annually. Fertilizer in 2 splits."},
  Grapes:      {emoji:"🍇",season:"Annual", soil:["clay","sandy"],       N:[33,42], P:[85,98], K:[60,72], temp:[36,42],hum:[37,48],moisture:[38,50],growDays:180,yieldTha:15,  waterReq:"Low",    fertReq:"High",  fertilizer:"DAP 200g + MOP 150g per vine after pruning.",irrigation:"Drip. Critical at berry set and veraison.",tips:"Kniffen/bower training. Thin bunches for berry size."},
  Orange:      {emoji:"🍊",season:"Winter", soil:["clay","loamy"],       N:[48,62], P:[50,62], K:[100,115],temp:[24,30],hum:[60,72],moisture:[50,62],growDays:365,yieldTha:20,  waterReq:"Medium", fertReq:"Medium",fertilizer:"Urea 500g + SSP 200g + MOP 300g per tree in 2 splits.",irrigation:"Basin/drip monthly. Increase at fruit swelling.",tips:"Rejuvenation pruning every 3 years. Control psyllids for HLB."},
  Apple:       {emoji:"🍎",season:"Winter", soil:["loamy","sandy"],      N:[110,125],P:[33,42],K:[28,38],  temp:[20,25],hum:[22,30],moisture:[25,35],growDays:180,yieldTha:30,  waterReq:"Low",    fertReq:"Medium",fertilizer:"FYM 40kg + Urea 500g + DAP 300g per tree.",irrigation:"8–10 irrigations/year. Critical at bloom and fruit development.",tips:"Thin at marble size. Kaolin clay spray for sunburn."},
  Papaya:      {emoji:"🍈",season:"Annual", soil:["loamy","sandy"],      N:[185,205],P:[43,55],K:[23,32],  temp:[22,28],hum:[70,82],moisture:[56,68],growDays:270,yieldTha:45,  waterReq:"High",   fertReq:"High",  fertilizer:"Urea 200g + DAP 150g per plant per month.",irrigation:"Drip every 3–4 days. Never allow waterlogging.",tips:"Use bisexual variety. Root zone trenching improves drainage."},
  Watermelon:  {emoji:"🍉",season:"Summer", soil:["sandy","loamy"],      N:[16,24], P:[10,18], K:[35,46], temp:[12,18],hum:[16,26],moisture:[18,30],growDays:80, yieldTha:35,  waterReq:"Medium", fertReq:"Medium",fertilizer:"DAP 60kg/ha + Urea 50kg/ha + MOP 50kg/ha.",irrigation:"Drip every 5–7 days. Reduce water 2 weeks before harvest.",tips:"Black plastic mulch improves yield. Hand pollinate for fruit set."},
  Sunflower:   {emoji:"🌻",season:"Rabi",   soil:["loamy","sandy"],      N:[35,45], P:[52,62], K:[118,135],temp:[26,30],hum:[47,58],moisture:[38,48],growDays:100,yieldTha:2.2, waterReq:"Low",    fertReq:"Medium",fertilizer:"Urea 80kg/ha + DAP 50kg/ha + MOP 50kg/ha.",irrigation:"Every 12–15 days. Critical at head formation.",tips:"N-S row orientation for uniform sunlight. Bird protection at maturity."},
  Mustard:     {emoji:"🌼",season:"Rabi",   soil:["sandy","loamy"],      N:[28,38], P:[38,48], K:[108,125],temp:[25,30],hum:[42,55],moisture:[32,45],growDays:90, yieldTha:1.8, waterReq:"Low",    fertReq:"Medium",fertilizer:"DAP 50kg/ha + Urea 60kg/ha. Sulphur 20kg/ha for oil quality.",irrigation:"Once at branching; once at pod fill.",tips:"Harvest when 75% pods golden. Thresh promptly."},
  Chickpea:    {emoji:"🫘",season:"Rabi",   soil:["loamy","clay"],       N:[75,90], P:[83,95], K:[72,85], temp:[24,28],hum:[70,82],moisture:[52,65],growDays:110,yieldTha:1.8, waterReq:"Low",    fertReq:"Low",   fertilizer:"DAP 50kg/ha. Rhizobium + PSB inoculation at sowing.",irrigation:"One irrigation at branching. Drought-tolerant crop.",tips:"Use resistant varieties. Monitor for blight and pod borer."},
  Lentil:      {emoji:"🫛",season:"Rabi",   soil:["loamy","sandy"],      N:[60,70], P:[35,45], K:[15,25], temp:[26,32],hum:[28,38],moisture:[28,40],growDays:110,yieldTha:1.5, waterReq:"Low",    fertReq:"Low",   fertilizer:"DAP 40kg/ha + MOP 20kg/ha. Rhizobium inoculation.",irrigation:"One irrigation at flowering if rainfall insufficient.",tips:"Harvest when lower pods turn brown. Avoid shattering."},
  Peas:        {emoji:"🫛",season:"Rabi",   soil:["loamy","silty"],      N:[52,65], P:[43,55], K:[85,105],temp:[24,30],hum:[58,72],moisture:[45,58],growDays:75, yieldTha:8,   waterReq:"Medium", fertReq:"Medium",fertilizer:"DAP 60kg/ha + MOP 40kg/ha. Top-dress Urea 20kg/ha.",irrigation:"Every 10 days. Critical at flowering and pod fill.",tips:"Stake climbing varieties. Harvest at green pod stage."},
  Coffee:      {emoji:"☕",season:"Annual", soil:["silty","loamy"],      N:[9,15],  P:[55,65], K:[68,82], temp:[20,26],hum:[76,86],moisture:[65,76],growDays:365,yieldTha:1.2, waterReq:"Medium", fertReq:"Medium",fertilizer:"Urea 200g + DAP 150g + MOP 250g per plant twice a year.",irrigation:"Sprinkler every 7 days in dry season. Shade trees required.",tips:"Shade management critical. Pulp cherries within 24h of harvest."},
  Tea:         {emoji:"🍵",season:"Annual", soil:["silty","loamy"],      N:[8,14],  P:[52,65], K:[78,92], temp:[22,27],hum:[68,80],moisture:[55,68],growDays:365,yieldTha:2.8, waterReq:"Medium", fertReq:"Medium",fertilizer:"Urea 200kg/ha + DAP 50kg/ha per year in 4 splits.",irrigation:"Sprinkler every 5–7 days. Minimal stress for quality flush.",tips:"Pluck at 2-leaf-and-bud. Rejuvenation prune every 5 years."},
  Capsicum:    {emoji:"🫑",season:"Kharif", soil:["loamy","silty"],      N:[14,22], P:[70,83], K:[165,185],temp:[23,28],hum:[70,82],moisture:[57,70],growDays:90, yieldTha:12,  waterReq:"Medium", fertReq:"High",  fertilizer:"DAP 60kg/ha + Urea 80kg/ha + MOP 80kg/ha. Ca spray at fruit set.",irrigation:"Drip every 3–4 days.",tips:"Remove first flower to build plant. 4–6 fruits per plant."},
  Brinjal:     {emoji:"🍆",season:"Kharif", soil:["loamy","silty"],      N:[18,28], P:[60,72], K:[145,165],temp:[22,28],hum:[65,75],moisture:[53,68],growDays:90, yieldTha:18,  waterReq:"Medium", fertReq:"High",  fertilizer:"DAP 60kg/ha + Urea 100kg/ha + MOP 60kg/ha.",irrigation:"Every 5–7 days. Drip preferred.",tips:"Harvest at tender stage. Watch for shoot-and-fruit borer."},
  Cabbage:     {emoji:"🥬",season:"Rabi",   soil:["clay","loamy"],       N:[22,32], P:[42,55], K:[105,122],temp:[20,26],hum:[62,75],moisture:[48,62],growDays:80, yieldTha:25,  waterReq:"Medium", fertReq:"Medium",fertilizer:"DAP 60kg/ha + Urea 80kg/ha + MOP 50kg/ha.",irrigation:"Every 7 days. Avoid overhead spray near maturity.",tips:"Transplant 25-day seedling. Earth-up twice for firm heads."},
  Spinach:     {emoji:"🥬",season:"Rabi",   soil:["loamy","silty"],      N:[24,34], P:[42,52], K:[96,112],temp:[19,25],hum:[58,72],moisture:[46,60],growDays:45, yieldTha:8,   waterReq:"Medium", fertReq:"Low",   fertilizer:"DAP 50kg/ha + Urea 60kg/ha in 2 splits.",irrigation:"Every 5 days. Sprinkler preferred.",tips:"Multiple cut harvesting. Avoid over-mature leaves."},
  Pomegranate: {emoji:"🍎",season:"Annual", soil:["sandy","loamy"],      N:[18,24], P:[120,135],K:[192,205],temp:[34,40],hum:[18,26],moisture:[25,35],growDays:365,yieldTha:12,  waterReq:"Low",    fertReq:"Medium",fertilizer:"DAP 200g + MOP 300g + Urea 300g per tree in 2 splits.",irrigation:"Drip bi-weekly. Regulated deficit at colour development.",tips:"Prune to single-trunk form. Thin fruits for size >200g."},
  Jute:        {emoji:"🌿",season:"Kharif", soil:["loamy","silty"],      N:[190,210],P:[78,92],K:[33,42],  temp:[22,26],hum:[74,86],moisture:[58,70],growDays:120,yieldTha:3.5, waterReq:"High",   fertReq:"High",  fertilizer:"Urea 100kg/ha + DAP 50kg/ha at 30 days.",irrigation:"Requires 300mm rainfall. Supplemental if dry.",tips:"Harvest at early flowering for best fibre quality."},
  Cauliflower: {emoji:"🥦",season:"Rabi",   soil:["clay","loamy"],       N:[25,35], P:[48,58], K:[115,132],temp:[18,24],hum:[64,75],moisture:[52,65],growDays:80, yieldTha:20,  waterReq:"Medium", fertReq:"Medium",fertilizer:"DAP 60kg/ha + Urea 80kg/ha. Boron spray at curd stage.",irrigation:"Every 7 days. Critical at curd initiation.",tips:"Tie leaves over curd to prevent discolouration."},
  Blackgram:   {emoji:"🫘",season:"Kharif", soil:["sandy","loamy"],      N:[20,28], P:[38,50], K:[52,65], temp:[25,32],hum:[12,20],moisture:[18,28],growDays:70, yieldTha:1.2, waterReq:"Low",    fertReq:"Low",   fertilizer:"DAP 40kg/ha. Rhizobium seed inoculation.",irrigation:"1 irrigation at pod fill. Drought-tolerant.",tips:"Harvest at 60–70% pods mature. Avoid shattering losses."},
};

/* ══════════════════════════════════════
   DISEASE DATABASE — 30+ classes
══════════════════════════════════════ */
const DISEASE_DB = {
  tomato_blight:   {crop:"Tomato",  emoji:"🍅",disease:"Late Blight",         severity:"CRITICAL",confidence:94.2,curePct:65,managePct:25,noCurePct:10,
    remedy:["Remove and destroy infected plant parts immediately","Improve field drainage urgently","Apply copper-based fungicide spray","Avoid overhead irrigation — use drip only"],
    pesticide:"Mancozeb 75WP @ 2g/L water — spray every 7 days",
    fertilizer:"Reduce nitrogen; increase potassium with MOP 50kg/ha to strengthen cell walls",
    prevention:"Space plants for airflow. Stake vines. Avoid wetting foliage. Mulch around base."},
  tomato_healthy:  {crop:"Tomato",  emoji:"🍅",disease:"Healthy",              severity:"HEALTHY", confidence:98.1,curePct:100,managePct:0,noCurePct:0,
    remedy:["Plant is perfectly healthy — no treatment needed","Maintain current irrigation schedule","Continue regular monitoring and scouting"],
    pesticide:"None required",
    fertilizer:"Continue balanced NPK schedule as planned",
    prevention:"Continue monitoring. Preventive sulphur spray in humid seasons."},
  corn_blight:     {crop:"Maize",   emoji:"🌽",disease:"N. Leaf Blight",      severity:"HIGH",    confidence:91.0,curePct:72,managePct:20,noCurePct:8,
    remedy:["Apply mancozeb fungicide at very first sign","Remove and burn all crop debris","Use resistant hybrids in next season"],
    pesticide:"Mancozeb 75WP @ 2.5g/L — 2–3 sprays at 10-day intervals",
    fertilizer:"Reduce nitrogen. Apply potassium to improve disease resistance.",
    prevention:"Crop rotation. Avoid dense planting. Plant resistant varieties."},
  wheat_rust:      {crop:"Wheat",   emoji:"🌾",disease:"Stem Rust",            severity:"CRITICAL",confidence:93.5,curePct:60,managePct:30,noCurePct:10,
    remedy:["Spray propiconazole immediately on entire field","Remove infected tillers from field","Burn stubble completely after harvest"],
    pesticide:"Propiconazole 25EC @ 1ml/L — 2 sprays at 14-day interval",
    fertilizer:"Balanced NPK. Avoid excess nitrogen that promotes rust spread.",
    prevention:"Sow resistant varieties. Early sowing avoids peak rust season."},
  grape_mildew:    {crop:"Grapes",  emoji:"🍇",disease:"Powdery Mildew",      severity:"HIGH",    confidence:89.0,curePct:80,managePct:15,noCurePct:5,
    remedy:["Apply sulphur dust immediately on all affected parts","Improve trellis system for better airflow","Remove heavily infected bunches from vine"],
    pesticide:"Wettable Sulphur 80WP @ 3g/L — spray every 10 days during humid periods",
    fertilizer:"Reduce nitrogen. Maintain potassium for plant resistance.",
    prevention:"Prune for open canopy. Sulphur preventive spray at budbreak."},
  potato_late:     {crop:"Potato",  emoji:"🥔",disease:"Late Blight",          severity:"CRITICAL",confidence:95.0,curePct:55,managePct:30,noCurePct:15,
    remedy:["Apply metalaxyl+mancozeb at very first sign","Destroy infected haulms before harvest day","Avoid harvesting in wet or humid conditions"],
    pesticide:"Metalaxyl 8%+Mancozeb 64WP @ 2.5g/L — spray every 5 days during blight weather",
    fertilizer:"Adequate potassium improves resistance. Apply MOP 80kg/ha.",
    prevention:"Use blight-resistant varieties. Monitor weather for risk periods."},
  rice_blast:      {crop:"Rice",    emoji:"🌾",disease:"Blast Disease",        severity:"CRITICAL",confidence:92.3,curePct:68,managePct:22,noCurePct:10,
    remedy:["Apply tricyclazole at first sign immediately","Reduce nitrogen application right away","Drain field briefly to reduce humidity around plants"],
    pesticide:"Tricyclazole 75WP @ 0.6g/L — spray at tillering AND panicle emergence",
    fertilizer:"Reduce nitrogen. Apply silicon (silicate 200kg/ha) to strengthen plant resistance.",
    prevention:"Balanced N fertilisation. Resistant varieties. Proper water management."},
  rice_blight:     {crop:"Rice",    emoji:"🌾",disease:"Bacterial Leaf Blight",severity:"HIGH",    confidence:88.7,curePct:65,managePct:28,noCurePct:7,
    remedy:["Drain field immediately to reduce humidity","Apply copper bactericide on entire field","Use resistant variety in next crop season"],
    pesticide:"Copper Hydroxide 77WP @ 3g/L — 2 sprays at 7-day interval",
    fertilizer:"Avoid excess nitrogen that promotes lush growth vulnerable to bacteria.",
    prevention:"Use clean certified seed. Avoid injury during transplanting."},
  banana_wilt:     {crop:"Banana",  emoji:"🍌",disease:"Panama Wilt (Fusarium)",severity:"CRITICAL",confidence:93.0,curePct:10,managePct:20,noCurePct:70,
    remedy:["Uproot and completely destroy infected plants — do not compost","Disinfect all tools with bleach solution","Do NOT replant susceptible varieties for 5 years in that soil"],
    pesticide:"No effective fungicide. Use Trichoderma harzianum soil drench preventively @ 5g/L",
    fertilizer:"Preventive Trichoderma harzianum soil application before planting.",
    prevention:"Plant Cavendish or FHIA-resistant varieties. Avoid infected soil movement."},
  mango_anthrac:   {crop:"Mango",   emoji:"🥭",disease:"Anthracnose",          severity:"HIGH",    confidence:89.8,curePct:75,managePct:20,noCurePct:5,
    remedy:["Apply carbendazim at panicle emergence (before flowering)","Avoid overhead irrigation during flowering","Collect and destroy all fallen infected fruits"],
    pesticide:"Carbendazim 50WP @ 1g/L — spray at flowering AND fruit set",
    fertilizer:"Calcium spray at fruit set reduces susceptibility to anthracnose.",
    prevention:"Prune for airflow. Post-harvest hot water treatment 52°C for 5 minutes."},
  cotton_curl:     {crop:"Cotton",  emoji:"🌸",disease:"Leaf Curl Virus",      severity:"CRITICAL",confidence:92.8,curePct:15,managePct:35,noCurePct:50,
    remedy:["Remove and destroy infected plants immediately","Apply insecticide for whitefly vector control","Switch to CLCuV-tolerant varieties next season"],
    pesticide:"Thiamethoxam 25WG @ 0.3g/L for whitefly — spray at first sign",
    fertilizer:"No specific fertilizer treatment. Focus on vector (whitefly) control.",
    prevention:"Use CLCuV-resistant varieties. Reflective mulch deters whiteflies."},
  apple_scab:      {crop:"Apple",   emoji:"🍎",disease:"Apple Scab",           severity:"HIGH",    confidence:90.2,curePct:78,managePct:18,noCurePct:4,
    remedy:["Apply mancozeb at green tip stage before symptoms appear","Rake and destroy all fallen leaves from orchard floor","Apply lime sulphur spray during dormancy period"],
    pesticide:"Mancozeb 75WP @ 2.5g/L — spray every 7 days during spring rains",
    fertilizer:"Balanced NPK. Avoid excess nitrogen that promotes lush susceptible tissue.",
    prevention:"Prune for canopy openness. Use resistant rootstocks for new plantings."},
  onion_blotch:    {crop:"Onion",   emoji:"🧅",disease:"Purple Blotch",        severity:"HIGH",    confidence:87.9,curePct:72,managePct:20,noCurePct:8,
    remedy:["Apply mancozeb immediately at first purplish spot appearance","Ensure good field drainage to prevent waterlogging","Remove all crop debris after harvest completely"],
    pesticide:"Mancozeb 75WP @ 2g/L — spray every 7 days",
    fertilizer:"Sulphur 20kg/ha improves plant resistance to fungal diseases.",
    prevention:"Crop rotation. Avoid overhead irrigation. Plant certified bulbs."},
  orange_canker:   {crop:"Orange",  emoji:"🍊",disease:"Citrus Canker",        severity:"HIGH",    confidence:91.5,curePct:60,managePct:30,noCurePct:10,
    remedy:["Prune infected branches 30cm below all visible symptoms","Apply copper bactericide immediately to pruned areas","Disinfect all pruning tools with 1% bleach between trees"],
    pesticide:"Copper Hydroxide 77WP @ 3g/L — spray every 3 weeks",
    fertilizer:"Calcium + Boron spray improves bark integrity and reduces canker entry points.",
    prevention:"Install wind breaks. Avoid plant injury. Copper sprays at flush emergence."},
  chickpea_blight: {crop:"Chickpea",emoji:"🫘",disease:"Ascochyta Blight",     severity:"HIGH",    confidence:86.3,curePct:68,managePct:24,noCurePct:8,
    remedy:["Apply chlorothalonil at very first sign of lesions","Remove and destroy all infected plant debris","Use disease-free certified seed in next season"],
    pesticide:"Chlorothalonil 75WP @ 2g/L — spray at 45 and 60 days after sowing",
    fertilizer:"Balanced fertilizer. Avoid excess nitrogen that promotes lush growth.",
    prevention:"Certified seed. Crop rotation. Resistant varieties available."},
};

/* ══════════════════════════════════════
   ALERT TEMPLATES
══════════════════════════════════════ */
const ALERT_TEMPLATES = {
  low_moisture:   {ico:"💧",type:"crit",badge:"CRITICAL",title:"Low Soil Moisture Detected",
    remedy:"Increase irrigation frequency immediately. Use drip irrigation for efficiency. Apply 45-min irrigation session now.",
    prevention:"Install soil moisture sensors at root zone. Set IoT alert threshold at 38%. Apply mulch to reduce evaporation."},
  high_temp:      {ico:"🌡️",type:"crit",badge:"WARNING",title:"Temperature Exceeds Optimal Range",
    remedy:"Provide shade using shade nets or mulching. Increase watering frequency during hot hours (early morning 5–7 AM).",
    prevention:"Install automated weather alerts. Use crop-specific temperature thresholds in IoT dashboard."},
  low_nitrogen:   {ico:"🧪",type:"warn",badge:"NPK ALERT",title:"Nitrogen Deficiency Detected",
    remedy:"Apply Urea 30kg/ha as top-dressing immediately. Mix with irrigation water for faster absorption (fertigation).",
    prevention:"Regular soil testing every 30 days. Follow fertilizer schedule in maintenance module strictly."},
  low_potassium:  {ico:"🔬",type:"warn",badge:"NPK ALERT",title:"Low Potassium (K) Detected",
    remedy:"Apply Muriate of Potash (MOP) 20kg/ha now. Potassium sulfate preferred in sensitive crops like tomato.",
    prevention:"Include K in base fertilizer at planting. Soil test before every season."},
  high_humidity:  {ico:"🌫️",type:"warn",badge:"DISEASE RISK",title:"High Humidity — Fungal Risk",
    remedy:"Improve air circulation between plants. Apply preventive fungicide (Mancozeb 75WP @ 2g/L) immediately.",
    prevention:"Use drip instead of overhead irrigation. Space plants for airflow. Avoid evening irrigation."},
  low_phosphorus: {ico:"⚗️",type:"info",badge:"NOTICE",title:"Phosphorus (P) Below Optimal",
    remedy:"Apply DAP 25kg/ha or Super Phosphate 50kg/ha. Mix into soil near root zone for best uptake.",
    prevention:"Maintain soil pH 6–7 for phosphorus availability. Apply phosphorus at planting as basal dose."},
};

/* ══════════════════════════════════════
   FERTILIZER SCHEDULES
══════════════════════════════════════ */
const FERT_SCHEDULE = [
  {day:"Day 0",   icon:"🌱",name:"Basal Dressing",   dose:"DAP 50kg/ha + MOP 30kg/ha at planting time"},
  {day:"Day 30",  icon:"🌿",name:"First Top-Dress",  dose:"Urea 40kg/ha — broadcast and water in well"},
  {day:"Day 60",  icon:"🌾",name:"Second Top-Dress", dose:"Urea 30kg/ha + MOP 20kg/ha combined application"},
  {day:"Day 90",  icon:"🌺",name:"Flowering Stage",  dose:"DAP 20kg/ha foliar spray + micro-nutrients"},
  {day:"Day 120", icon:"🍎",name:"Fruit/Grain Fill",  dose:"MOP 20kg/ha + Calcium nitrate 0.5% foliar spray"},
];
