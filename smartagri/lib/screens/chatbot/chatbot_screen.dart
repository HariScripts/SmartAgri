import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/crop_provider.dart';

class ChatbotScreen extends StatefulWidget {
  final String initialContext;

  const ChatbotScreen({super.key, this.initialContext = ''});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _addBotMessage('Hello! I am your SmartAgri Assistant. How can I help you with your farm today?');
    if (widget.initialContext.isNotEmpty) {
      _addBotMessage('I see you are looking at ${widget.initialContext}. Do you have any specific questions about it?');
    }
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add({'sender': 'bot', 'text': message});
    });
  }

  void _addUserMessage(String message) {
    setState(() {
      _messages.add({'sender': 'user', 'text': message});
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _controller.clear();

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 800), () {
      final activeCrop = Provider.of<CropProvider>(context, listen: false).activeCrop?.cropName ?? 'your crop';
      final query = text.toLowerCase();
      String botReply = '';

      // 1. CROPS GROWING STEP-BY-STEP PROCESS
      if (query.contains('how to start') || query.contains('how to grow') || query.contains('process of') || query.contains('step by step') || query.contains('growing') || query.contains('cultivate')) {
        if (query.contains('rice') || query.contains('paddy')) {
          botReply = '🌾 **Step-by-Step Guide to Growing Rice (Paddy):**\n\n'
              '1. **Soil Preparation:** Prepare a clayey or loamy soil. Till the field 3-4 times and flood it with 5-10 cm of water (puddling) to create a soft, muddy bed.\n'
              '2. **Sowing/Transplanting:** Sow seeds in nursery beds first. After 25-30 days, transplant the healthy green seedlings into the main puddled field in rows spaced 20cm apart.\n'
              '3. **Water Management:** Rice is a water-loving crop. Maintain 5cm of standing water throughout the vegetative phase. Drain the water 10-15 days before harvesting.\n'
              '4. **Fertilizer Schedule:** Apply Nitrogen, Phosphorus, and Potassium (NPK) in a 120:60:60 ratio. Apply Nitrogen in 3 split doses: at planting, tillering stage, and panicle initiation stage.\n'
              '5. **Weeding & Protection:** Perform manual weeding 3-4 weeks after transplanting. Keep an eye out for pests like Stem Borers or Blast disease (use Carbendazim spray if needed).\n'
              '6. **Harvesting:** Harvest when the grains turn golden-yellow and moisture content drops to 20%. Cut the straw, dry in the sun, and thresh.';
        } else if (query.contains('wheat')) {
          botReply = '🌾 **Step-by-Step Guide to Growing Wheat:**\n\n'
              '1. **Soil Preparation:** Well-drained loamy soil is ideal. Till the field 2-3 times to prepare a fine seedbed.\n'
              '2. **Sowing:** Sow seeds in late autumn (Rabi season, Oct-Nov) at a depth of 4-5 cm using a seed drill or broadcasting. Space rows 20-22 cm apart.\n'
              '3. **Irrigation (Critical Stages):** Wheat requires 4-6 waterings. The most critical stages are: Crown Root Initiation (21 days after sowing), Tillering, Flowering, and Jointing.\n'
              '4. **Fertilizer Schedule:** Use NPK in a 120:60:40 ratio. Apply all P and K at sowing. Split Nitrogen into 2 doses: half at sowing, half with the first irrigation.\n'
              '5. **Protection:** Guard against Rust disease (apply propiconazole or sulfur dust if spotted) and keep fields weed-free using selective herbicides.\n'
              '6. **Harvesting:** Harvest in spring (March-April) when the plants turn dry and golden brown, and the grains feel hard when crushed.';
        } else if (query.contains('sugarcane')) {
          botReply = '🌱 **Step-by-Step Guide to Growing Sugarcane:**\n\n'
              '1. **Soil Preparation:** Deep, well-drained sandy loams rich in organic matter. Deep till the soil to a depth of 30-45 cm and create furrows spaced 90-120 cm apart.\n'
              '2. **Planting:** Select healthy stem cuttings (setts) with 2-3 active buds. Lay them horizontally in the furrows and cover them with 2 inches of soil.\n'
              '3. **Watering:** Sugarcane is a high-water consumption crop. Irrigate every 7-10 days in summer and 20 days in winter. Ensure proper drainage to avoid waterlogging.\n'
              '4. **Fertilizer Schedule:** Sugarcane is a heavy feeder. Apply NPK in a massive 250:80:120 kg/hectare ratio. Split Nitrogen across three applications: planting, 60 days, and 120 days.\n'
              '5. **Inter-culture & Earthing Up:** Till the soil between rows to clear weeds. Perform "earthing up" (putting soil around sugarcane base) at 4 months to prevent lodging.\n'
              '6. **Harvesting:** Ready in 10-18 months. Test juice sweetness (brix reading). Cut the cane at ground level where sugar concentration is highest.';
        } else if (query.contains('tomato')) {
          botReply = '🍅 **Step-by-Step Guide to Growing Tomatoes:**\n\n'
              '1. **Soil Preparation:** Rich, well-draining sandy loam soil with pH 6.0-6.8. Mix compost or aged manure liberally.\n'
              '2. **Seedlings & Transplanting:** Sow seeds in trays. Transplant 4-6 week old seedlings into the field on raised beds. Space them 45-60 cm apart.\n'
              '3. **Watering:** Water consistently. Uneven watering causes blossom end rot. Keep soil moist but never soggy. Water at the base (avoid leaves).\n'
              '4. **Staking & Pruning:** Support the heavy vines using wooden stakes or cages. Prune "suckers" (small branches growing in leaf joints) to increase fruit size.\n'
              '5. **Fertilizer Schedule:** Apply balanced NPK (10-10-10) or compost at planting. Switch to potassium-rich fertilizer once flowers appear to boost tomato yield.\n'
              '6. **Harvesting:** Pick when firm and fully colored (red or orange/yellow depending on variety). Let green ones ripen at room temperature indoors.';
        } else if (query.contains('cotton')) {
          botReply = '🌱 **Step-by-Step Guide to Growing Cotton:**\n\n'
              '1. **Soil & Climate:** Deep black clayey soils (which retain water) are perfect. Cotton requires 4-5 tillings and a warm climate with lots of sunshine.\n'
              '2. **Sowing:** Sow seeds directly into ridges in early summer. Space seeds 30cm apart in rows 60-90cm apart.\n'
              '3. **Watering:** Moderately drought-tolerant. Irrigate during the critical square-formation, flowering, and boll-development stages.\n'
              '4. **Fertilizer Schedule:** Apply NPK in a 80:40:40 ratio. Apply Nitrogen in splits at sowing, squaring, and peak flowering.\n'
              '5. **Pest Control:** Cotton is susceptible to Bollworms and sucking pests. Use Neem oil spray or systemic insecticides, and remove weeds early.\n'
              '6. **Harvesting:** Harvest (picking) when the cotton bolls burst open and expose the fluffy white fibers. Pick manually and dry under the sun.';
        } else if (query.contains('maize') || query.contains('corn')) {
          botReply = '🌽 **Step-by-Step Guide to Growing Maize (Corn):**\n\n'
              '1. **Soil Preparation:** Well-drained loamy to clayey soils with pH 5.5-7.5. Till the soil 2-3 times and add organic matter.\n'
              '2. **Sowing:** Sow seeds directly in the ground, 3-5 cm deep and spaced 20-25 cm apart in rows spaced 60-75 cm apart.\n'
              '3. **Water Management:** Critical water stages are: tasseling, silking, and grain filling. Irrigate immediately if leaves show wilting.\n'
              '4. **Fertilizer Schedule:** Heavy nitrogen feeder. Apply NPK in a 120:60:40 ratio. Apply Nitrogen in 3 split doses: sowing, knee-high stage, and tasseling.\n'
              '5. **Weeding:** Keep the field weed-free for the first 30-45 days. Use mechanical weeding or broadleaf herbicides.\n'
              '6. **Harvesting:** Harvest when the husks turn papery and brown, kernels are full, and they release a milky fluid when pricked.';
        } else if (query.contains('potato')) {
          botReply = '🥔 **Step-by-Step Guide to Growing Potatoes:**\n\n'
              '1. **Soil Preparation:** Loose, well-aerated, sandy-loam soil. Deep till the beds and mix plenty of compost.\n'
              '2. **Planting:** Cut seed potatoes into pieces, each containing 2-3 active "eyes". Let dry for 2 days, then plant 10cm deep in furrows spaced 60cm apart.\n'
              '3. **Earthing Up:** When plants reach 15-20cm high, draw soil up around the stems to form ridges. This prevents growing potatoes from turning green and toxic.\n'
              '4. **Watering:** Keep soil consistently moist but not soggy. Stop watering when foliage turns yellow and dies back.\n'
              '5. **Fertilization:** High Potassium requirement. Apply NPK in a 120:100:120 ratio. Add potash mid-season to increase tuber size.\n'
              '6. **Harvesting:** Ready 90-120 days after planting. Dig tubers up gently using a garden fork on a dry day, and cure them in a dark, warm room for 10 days before storing.';
        } else if (query.contains('groundnut') || query.contains('peanut')) {
          botReply = '🥜 **Step-by-Step Guide to Growing Groundnut (Peanut):**\n\n'
              '1. **Soil Preparation:** Well-drained sandy-loam soil is highly essential so that the pegs can easily penetrate into the soil to form pods.\n'
              '2. **Sowing:** Plant shelled kernels 5cm deep and spaced 15cm apart in rows spaced 30cm apart.\n'
              '3. **Watering:** Moderate water required. The pegging stage (when flowers bend and push into the soil) and pod-development stage are critical. Avoid excess water during harvesting.\n'
              '4. **Gypsum Application:** Apply Gypsum at peak flowering (45-50 days) to supply calcium which prevents empty pods ("pops").\n'
              '5. **Harvesting:** Harvest when leaf color turns yellow and the inside of the pod shells shows dark-brown markings. Pull up the entire plant and dry for 3 days.';
        } else if (query.contains('chili') || query.contains('chilli') || query.contains('pepper')) {
          botReply = '🌶️ **Step-by-Step Guide to Growing Chilies (Peppers):**\n\n'
              '1. **Soil Preparation:** Sandy loam, clay loam, or red loam soil with good drainage. Till the soil 3 times and apply compost.\n'
              '2. **Seedlings & Transplanting:** Sow seeds in nursery beds. Transplant healthy 35-40 day seedlings spaced 45cm apart.\n'
              '3. **Irrigation:** Maintain steady moisture. Irrigate every 7-10 days depending on climate. Stop watering if plants are over-logged as chilies drop flowers in wet soil.\n'
              '4. **Fertilizer Schedule:** Use NPK in a 60:60:30 ratio. Apply Nitrogen in splits at transplanting, flowering, and fruit-bearing.\n'
              '5. **Pest Control:** Protect from thrips and mites (use Neem oil spray or systemic miticides).\n'
              '6. **Harvesting:** Pick when green for vegetable market, or let them ripen fully to a vibrant red for drying.';
        } else if (query.contains('mustard')) {
          botReply = '🟡 **Step-by-Step Guide to Growing Mustard:**\n\n'
              '1. **Soil Preparation:** Sandy loam or loamy soil. Till the field 2 times to prepare a fine and weed-free seedbed.\n'
              '2. **Sowing:** Sow seeds in October-November. Sow seeds at a shallow depth of 2-3 cm, maintaining a row spacing of 30cm.\n'
              '3. **Irrigation:** Very low water requirements. Provide 2 irrigations: first at the pre-flowering stage (30 days) and second at pod-formation (60 days).\n'
              '4. **Fertilizer Schedule:** Apply NPK in a 80:40:40 ratio. Crucially apply **Sulphur** at sowing, as it increases the oil content in mustard seeds.\n'
              '5. **Harvesting:** Harvest as soon as the mustard pods turn bright golden-yellow. Avoid over-drying in the field to prevent pod shattering and seed loss.';
        } else {
          // Dynamic Generalized Crop Guide!
          // Try to extract the crop name by removing common question words
          String targetCrop = query
              .replaceAll('how to start', '')
              .replaceAll('how to grow', '')
              .replaceAll('process of', '')
              .replaceAll('step by step', '')
              .replaceAll('growing', '')
              .replaceAll('cultivate', '')
              .replaceAll('guide to', '')
              .replaceAll('guide for', '')
              .replaceAll('?', '')
              .trim();

          final String cropDisplayName = targetCrop.isNotEmpty 
              ? targetCrop.split(' ').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ')
              : 'your selected crop';

          botReply = '🌱 **Step-by-Step Guide to Growing $cropDisplayName:**\n\n'
              '1. **Soil & Site Selection:** Select a fertile, well-draining soil (sandy loam is generally ideal for most crops). Ensure the site receives 6-8 hours of direct sunlight.\n'
              '2. **Seed Bed Preparation:** Till the soil to a depth of 20-30 cm. Remove weeds, rocks, and debris. Mix in a liberal amount of organic compost or decomposed manure to enrich the soil beds.\n'
              '3. **Sowing/Planting:** Plant seeds at a depth equal to roughly twice their width. Maintain row spacing recommended for the species, and water gently immediately after planting.\n'
              '4. **Water Management:** Water deeply and regularly. Most crops prefer moist but well-drained soil. Avoid waterlogging which causes root rot.\n'
              '5. **Nutritional Care (NPK):** Apply balanced organic compost or a tailored NPK fertilizer during vegetative growth, and switch to higher potassium/phosphorus blends when flowers/fruits emerge.\n'
              '6. **Harvesting:** Harvest at peak maturity (fruits colored, grains hard, or tubers mature). Gather in dry conditions and store in a cool, ventilated shed.';
        }
      }
      
      // 2. DISEASES STEP-BY-STEP CURE AND REMEDY DETAILS
      else if (query.contains('disease') || query.contains('blight') || query.contains('blast') || query.contains('rust') || query.contains('rot') || query.contains('wilt') || query.contains('spot') || query.contains('cure') || query.contains('remedy') || query.contains('treatment')) {
        if (query.contains('late blight') || query.contains('blight') || query.contains('tomato') || query.contains('potato')) {
          botReply = '🛡️ **Step-by-Step Treatment for Late Blight (Tomato/Potato):**\n\n'
              'Late Blight is a highly destructive fungal disease. Here is how to eradicate it:\n'
              '1. **Isolate & Prune:** Immediately prune and bag all infected leaves, stems, and fruits showing dark brown, oily spots. Burn or bury them deep; never compost them!\n'
              '2. **Fungicide Application:** Spray a copper-based fungicide or chemical anti-blight spray (like Mancozeb or Ridomil Gold) thoroughly on the entire plant, including the undersides of leaves.\n'
              '3. **Foliar Management:** Stop overhead watering. Water strictly at the soil base. Late blight spores travel and multiply in leaf moisture.\n'
              '4. **Improve Spacing:** Thin out dense foliage to allow wind and sunlight to dry the plants rapidly.\n'
              '5. **Prevention:** Rotate crops next season. Do not plant tomatoes or potatoes in the same soil for 3 years.';
        } else if (query.contains('blast') || query.contains('rice blast') || query.contains('rice')) {
          botReply = '🛡️ **Step-by-Step Treatment for Rice Blast:**\n\n'
              'Rice Blast produces spindle-shaped lesions on leaves and neck rot. Follow these steps:\n'
              '1. **Sanitize the Field:** Immediately burn or deeply plow under crop residues from infected rice fields to destroy the overwintering fungal spores.\n'
              '2. **Fungicide Spray:** Spray **Tricyclazole** (75 WP at 0.6g/liter of water) or **Carbendazim** immediately upon noticing the first boat-shaped leaf spots.\n'
              '3. **Optimize Nitrogen:** Stop applying excessive Nitrogen fertilizers immediately. Excess Nitrogen creates soft, lush tissue that the blast fungus easily penetrates.\n'
              '4. **Silicon Boost:** Apply silicon-rich fertilizers (like calcium silicate) to toughen the rice leaf epidermal cell walls, acting as a physical armor.\n'
              '5. **Water Level:** Maintain a steady water level in the field; drought-stressed plants are far more susceptible to Blast.';
        } else if (query.contains('rust') || query.contains('wheat rust') || query.contains('wheat')) {
          botReply = '🛡️ **Step-by-Step Treatment for Wheat Rust (Stem, Leaf, or Stripe):**\n\n'
              'Wheat Rust spreads rapidly through wind-borne orange-red spores. Act quickly:\n'
              '1. **Early Chemical Spray:** Spray systemic fungicides like **Propiconazole (Tilt 25 EC)** or **Tebuconazole** at the rate of 1 ml per liter of water.\n'
              '2. **Dusting (Organic):** Apply sulfur dust early in the morning when dew is present to block spore germination on the leaves.\n'
              '3. **Remove Host Plants:** Eradicate alternative weed hosts (like wild grasses and barberry plants) around the field borders where the rust fungus spends its winter.\n'
              '4. **Balanced Nutrition:** Ensure rich Potassium application (P and K build cell resistance), while reducing excessive Nitrogen top-dressing.\n'
              '5. **Future Planting:** Use rust-resistant varieties next season (e.g., HD 2967, HD 3086).';
        } else if (query.contains('red rot') || query.contains('sugarcane')) {
          botReply = '🛡️ **Step-by-Step Treatment for Red Rot (Sugarcane):**\n\n'
              'Red Rot causes sugarcane stalks to rot from inside, showing red discolorations with white cross-bands. Follow these guidelines:\n'
              '1. **Uproot and Burn:** Red Rot has no chemical cure once it infests the stalk core. Immediately rogue (uproot) the infected sugarcane clumps and burn them.\n'
              '2. **Healthy Seed Setts:** For next sowing, select disease-free setts. Treat them with **Hot Water (50°C for 2 hours)** or hot-air before planting.\n'
              '3. **Sett Treatment:** Dip cuttings in **Carbendazim (0.1%)** or Trichoderma liquid formulation for 15 minutes before sowing.\n'
              '4. **Improve Drainage:** Ensure zero waterlogging. Standing water spreads Red Rot fungal spores rapidly from row to row.\n'
              '5. **Crop Rotation:** Rotate sugarcane fields with green manure, legumes, or paddy for at least 2 years to starve out the soil-borne fungus.';
        } else if (query.contains('boll rot') || query.contains('leaf spot') || query.contains('cotton')) {
          botReply = '🛡️ **Step-by-Step Treatment for Boll Rot & Leaf Spot (Cotton):**\n\n'
              'Boll Rot ruins the cotton yield by turning bolls black and rotting the fibers. Treatment steps:\n'
              '1. **Fungicidal Treatment:** Spray **Copper Oxychloride (0.3%)** combined with **Streptocycline (100 ppm)** to combat both fungal and bacterial leaf spot/boll rot.\n'
              '2. **Canopy Management:** Prune the lower dense branches to improve air circulation and allow sunlight to penetrate the cotton canopy, drying out the bolls.\n'
              '3. **Pest Suppression:** Control bollworms and sucking bugs (whiteflies, jassids) because their feeding punctures create the doorways for rot fungi to enter.\n'
              '4. **Weed Clearance:** Keep the crop line clean. Weeds lock in damp air which promotes boll rotting.\n'
              '5. **Clean Picking:** Pick burst bolls early and store them in dry, well-ventilated sheds.';
        } else {
          botReply = '🛡️ **How to treat crop diseases:**\n'
              'If you detect a disease, here is the general 4-step emergency process:\n'
              '1. **Prune & Isolate:** Cut off and destroy infected branches and leaves. Never compost them.\n'
              '2. **Base Watering Only:** Avoid wet leaves; water the soil directly.\n'
              '3. **Apply Fungicide/Antibacterial:** Use copper-based fungicide for blights/spots, and specific agents like Propiconazole for rusts or Tricyclazole for blast.\n'
              '4. **Improve Airflow:** Space your plants out.\n\n'
              'Ask me about specific diseases like *"How to cure Late Blight"* or *"Red Rot treatment"* for customized steps!';
        }
      }

      // 3. IOT SENSOR ANALYSIS & ALERTS (NPK, WATERING, TEMPERATURE)
      else if (query.contains('nitrogen') || query.contains('phosphorus') || query.contains('potassium') || query.contains('npk') || query.contains('soil') || query.contains('moisture') || query.contains('sensor') || query.contains('temp')) {
        if (query.contains('nitrogen') || query.contains(' n ')) {
          botReply = '🧪 **Nitrogen (N) Advice:**\n\n'
              'Nitrogen is critical for vegetative growth and green leafy development.\n'
              '* **If Nitrogen is Low:** Apply **Urea** (contains 46% nitrogen) at 50-100 kg/hectare. Alternatively, apply organic compost, vermicompost, or blood meal.\n'
              '* **If Nitrogen is High:** Suspend all nitrogen applications immediately and flood the field slightly to leach out excess nitrate, as excessive nitrogen causes lush green growth but delays flowering and makes plants highly prone to pest infestations.';
        } else if (query.contains('phosphorus') || query.contains(' p ')) {
          botReply = '🧪 **Phosphorus (P) Advice:**\n\n'
              'Phosphorus is essential for root establishment, flowering, and seed production.\n'
              '* **If Phosphorus is Low:** Apply **DAP (Diammonium Phosphate)** or **SSP (Single Superphosphate)**. Organic bone meal is also excellent.\n'
              '* **If Phosphorus is High:** Reduce phosphate fertilizers. Excessive P blocks the plant\'s uptake of zinc and iron, causing leaf yellowing.';
        } else if (query.contains('potassium') || query.contains(' k ')) {
          botReply = '🧪 **Potassium (K) Advice:**\n\n'
              'Potassium builds plant immunity, stem strength, drought resistance, and fruit/grain quality.\n'
              '* **If Potassium is Low:** Apply **MOP (Muriate of Potash / Potassium Chloride)** or organic wood ash.\n'
              '* **If Potassium is High:** Stop potash application. Extremely high K can cause magnesium deficiency in plants.';
        } else if (query.contains('moisture') || query.contains('water') || query.contains('irrigate')) {
          botReply = '💧 **Soil Moisture and Irrigation Management:**\n\n'
              '* **Low Soil Moisture (<50%):** Start irrigation immediately! Focus on deep base irrigation, preferably using a drip irrigation system to conserve water and prevent foliar moisture diseases.\n'
              '* **High Soil Moisture (>85%):** Ensure proper drainage. Standing water suffocates roots, stops nutrient uptake, and triggers root rot and damping-off diseases.';
        } else {
          botReply = '📊 **SmartAgri IoT Sensors:**\n'
              'We track Nitrogen (N), Phosphorus (P), Potassium (K), Soil Moisture, Humidity, and Temperature. If any sensor value goes out of range, we generate an automatic system alert in your dashboard bell and send a toast notification to your screen!';
        }
      }

      // 4. GENERAL HELP & FAQ
      else {
        botReply = '🤖 **SmartAgri Expert AI Assistant:**\n\n'
            'I can answer any detailed agricultural question! Try asking me:\n\n'
            '🌱 *How to start growing Rice step-by-step?*\n'
            '🍅 *Step-by-step process of growing Tomatoes?*\n'
            '🛡️ *How do I cure Late Blight in Tomatoes?*\n'
            '🛡️ *Red Rot treatment steps for Sugarcane?*\n'
            '🧪 *What should I do if Nitrogen is low?*\n'
            '💧 *How do I manage low soil moisture?*';
      }

      _addBotMessage(botReply);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartAgri Assistant'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.all(12.0),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primaryLight : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                        bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask your farming question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _handleSend,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
