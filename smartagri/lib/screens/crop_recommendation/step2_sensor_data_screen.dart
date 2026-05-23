import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_router.dart';
import '../../../models/crop_model.dart';
import '../../../providers/crop_provider.dart';
import '../../../providers/farm_provider.dart';
import '../../../utils/crop_image_helper.dart';

class Step2SensorDataScreen extends StatelessWidget {
  const Step2SensorDataScreen({super.key});

  List<CropModel> getRecommendations(String soil) {
    if (soil == 'Alluvial Soil') {
      return [
        CropModel(cropName: 'Rice', season: 'Kharif', soilType: soil, matchPercentage: 96.0, healthPercentage: 100.0, daysToHarvest: 120, minTemp: 22.0, maxTemp: 35.0, waterNeed: 'High', fertilizerDetails: 'NPK 120:60:60', diseaseRisk: 25.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Wheat', season: 'Rabi', soilType: soil, matchPercentage: 92.0, healthPercentage: 100.0, daysToHarvest: 140, minTemp: 10.0, maxTemp: 25.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 100:50:50', diseaseRisk: 15.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Sugarcane', season: 'Perennial', soilType: soil, matchPercentage: 89.0, healthPercentage: 100.0, daysToHarvest: 365, minTemp: 20.0, maxTemp: 35.0, waterNeed: 'High', fertilizerDetails: 'NPK 250:100:100', diseaseRisk: 20.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Jute', season: 'Kharif', soilType: soil, matchPercentage: 85.0, healthPercentage: 100.0, daysToHarvest: 130, minTemp: 24.0, maxTemp: 37.0, waterNeed: 'High', fertilizerDetails: 'NPK 60:30:30', diseaseRisk: 18.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Maize', season: 'Kharif', soilType: soil, matchPercentage: 82.0, healthPercentage: 100.0, daysToHarvest: 100, minTemp: 21.0, maxTemp: 27.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 120:60:40', diseaseRisk: 22.0, selectedAt: DateTime.now()),
      ];
    } else if (soil == 'Red Soil') {
      return [
        CropModel(cropName: 'Groundnut', season: 'Kharif', soilType: soil, matchPercentage: 94.0, healthPercentage: 100.0, daysToHarvest: 110, minTemp: 25.0, maxTemp: 30.0, waterNeed: 'Low', fertilizerDetails: 'NPK 20:40:40', diseaseRisk: 20.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Millet', season: 'Kharif', soilType: soil, matchPercentage: 88.0, healthPercentage: 100.0, daysToHarvest: 90, minTemp: 26.0, maxTemp: 33.0, waterNeed: 'Low', fertilizerDetails: 'NPK 40:20:20', diseaseRisk: 10.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Cotton', season: 'Kharif', soilType: soil, matchPercentage: 85.0, healthPercentage: 100.0, daysToHarvest: 150, minTemp: 21.0, maxTemp: 30.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 100:50:50', diseaseRisk: 25.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Pulses', season: 'Zaid', soilType: soil, matchPercentage: 83.0, healthPercentage: 100.0, daysToHarvest: 70, minTemp: 20.0, maxTemp: 30.0, waterNeed: 'Low', fertilizerDetails: 'NPK 20:40:20', diseaseRisk: 15.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Tobacco', season: 'Kharif', soilType: soil, matchPercentage: 80.0, healthPercentage: 100.0, daysToHarvest: 120, minTemp: 20.0, maxTemp: 32.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 80:40:40', diseaseRisk: 30.0, selectedAt: DateTime.now()),
      ];
    } else if (soil == 'Loamy Soil') {
      return [
        CropModel(cropName: 'Tomato', season: 'Year-round', soilType: soil, matchPercentage: 95.0, healthPercentage: 100.0, daysToHarvest: 80, minTemp: 18.0, maxTemp: 28.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 100:50:50', diseaseRisk: 30.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Potato', season: 'Rabi', soilType: soil, matchPercentage: 89.0, healthPercentage: 100.0, daysToHarvest: 100, minTemp: 15.0, maxTemp: 22.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 120:80:100', diseaseRisk: 35.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Onion', season: 'Rabi', soilType: soil, matchPercentage: 87.0, healthPercentage: 100.0, daysToHarvest: 120, minTemp: 13.0, maxTemp: 25.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 100:50:50', diseaseRisk: 20.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Carrot', season: 'Rabi', soilType: soil, matchPercentage: 85.0, healthPercentage: 100.0, daysToHarvest: 90, minTemp: 10.0, maxTemp: 20.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 80:40:40', diseaseRisk: 15.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Spinach', season: 'Year-round', soilType: soil, matchPercentage: 82.0, healthPercentage: 100.0, daysToHarvest: 45, minTemp: 10.0, maxTemp: 25.0, waterNeed: 'High', fertilizerDetails: 'NPK 60:30:30', diseaseRisk: 10.0, selectedAt: DateTime.now()),
      ];
    } else if (soil == 'Clay Soil') {
      return [
        CropModel(cropName: 'Cabbage', season: 'Rabi', soilType: soil, matchPercentage: 91.0, healthPercentage: 100.0, daysToHarvest: 90, minTemp: 15.0, maxTemp: 20.0, waterNeed: 'High', fertilizerDetails: 'NPK 120:60:60', diseaseRisk: 25.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Broccoli', season: 'Rabi', soilType: soil, matchPercentage: 88.0, healthPercentage: 100.0, daysToHarvest: 80, minTemp: 15.0, maxTemp: 22.0, waterNeed: 'High', fertilizerDetails: 'NPK 120:60:60', diseaseRisk: 20.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Cauliflower', season: 'Rabi', soilType: soil, matchPercentage: 85.0, healthPercentage: 100.0, daysToHarvest: 100, minTemp: 15.0, maxTemp: 25.0, waterNeed: 'High', fertilizerDetails: 'NPK 120:60:60', diseaseRisk: 22.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Peas', season: 'Rabi', soilType: soil, matchPercentage: 82.0, healthPercentage: 100.0, daysToHarvest: 60, minTemp: 10.0, maxTemp: 20.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 20:40:40', diseaseRisk: 15.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Beans', season: 'Kharif', soilType: soil, matchPercentage: 80.0, healthPercentage: 100.0, daysToHarvest: 55, minTemp: 15.0, maxTemp: 28.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 20:40:40', diseaseRisk: 18.0, selectedAt: DateTime.now()),
      ];
    } else {
      return [
        CropModel(cropName: 'Cotton', season: 'Kharif', soilType: soil, matchPercentage: 95.0, healthPercentage: 100.0, daysToHarvest: 150, minTemp: 21.0, maxTemp: 30.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 100:50:50', diseaseRisk: 30.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Sugarcane', season: 'Perennial', soilType: soil, matchPercentage: 88.0, healthPercentage: 100.0, daysToHarvest: 365, minTemp: 25.0, maxTemp: 35.0, waterNeed: 'High', fertilizerDetails: 'NPK 250:100:100', diseaseRisk: 40.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Soybean', season: 'Kharif', soilType: soil, matchPercentage: 85.0, healthPercentage: 100.0, daysToHarvest: 120, minTemp: 20.0, maxTemp: 30.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 20:60:40', diseaseRisk: 25.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Sunflower', season: 'Rabi', soilType: soil, matchPercentage: 82.0, healthPercentage: 100.0, daysToHarvest: 100, minTemp: 20.0, maxTemp: 25.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 60:40:40', diseaseRisk: 20.0, selectedAt: DateTime.now()),
        CropModel(cropName: 'Sorghum', season: 'Kharif', soilType: soil, matchPercentage: 80.0, healthPercentage: 100.0, daysToHarvest: 110, minTemp: 25.0, maxTemp: 32.0, waterNeed: 'Low', fertilizerDetails: 'NPK 80:40:40', diseaseRisk: 15.0, selectedAt: DateTime.now()),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final soilType = ModalRoute.of(context)?.settings.arguments as String? ?? 'Loamy Soil';
    final recommendations = getRecommendations(soilType);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Analysed — Fetching Sensor Data...'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            heroTag: 'homeBtnStep2',
            onPressed: () => Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.home),
            backgroundColor: const Color(0xFF2D4B37),
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'chatBtnStep2',
            onPressed: () => Navigator.of(context).pushNamed(AppRouter.chatbot, arguments: 'crop recommendation'),
            backgroundColor: const Color(0xFF10B981),
            icon: const Icon(Icons.chat, color: Colors.white),
            label: const Text('Chat', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepDot(true, 'Step 1'),
                _buildLine(true),
                _buildStepDot(true, 'Step 2 (Final)', isCurrent: true),
              ],
            ),
            const SizedBox(height: 32),

            // Responsive Split Layout matching Image 1
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildLeftColumn(context, soilType),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 6,
                        child: _buildRightColumn(context),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLeftColumn(context, soilType),
                      const SizedBox(height: 32),
                      _buildRightColumn(context),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 48),

            // AI Crop Recommendations Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AI Crop Recommendations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showPairPlotDialog(context),
                  icon: const Icon(Icons.bubble_chart_outlined, color: Color(0xFF10B981)),
                  label: const Text(
                    'AI Pair Plot Clusters',
                    style: TextStyle(
                      color: Color(0xFF047857),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFECFDF5),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFFA7F3D0)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Cluster Color Legend Row on main screen
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Text(
                    'AI Cluster Key: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildMainScreenLegendDot(const Color(0xFF3B82F6), 'Rice'),
                  const SizedBox(width: 12),
                  _buildMainScreenLegendDot(const Color(0xFF10B981), 'Tomato'),
                  const SizedBox(width: 12),
                  _buildMainScreenLegendDot(const Color(0xFFF59E0B), 'Cotton'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final crop = recommendations[index];
                return _buildCropCard(context, crop);
              },
            ),
            const SizedBox(height: 80), // Padding for Floating Action Buttons
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, String soilType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
            SizedBox(width: 8),
            Text(
              'Soil Classification Result',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
        
        // Cream result container
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB), // Pale cream
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFEF3C7), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.spa, color: Color(0xFFD97706), size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CNN CLASSIFICATION · RESNET-50',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        soilType,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Confidence: 99%',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildMetadataRow('pH Range', '5.5 - 7.0'),
                        const SizedBox(height: 10),
                        _buildMetadataRow('Nutrients', 'Low'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        _buildMetadataRow('Drainage', 'Excellent'),
                        const SizedBox(height: 10),
                        _buildMetadataRow('Moisture', 'Low'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Suitable Crops Title
        const Text(
          'SUITABLE CROPS FOR THIS SOIL',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCropBadge('Maize'),
            _buildCropBadge('Cotton'),
            _buildCropBadge('Wheat'),
            _buildCropBadge('Pulses'),
            _buildCropBadge('Tomato'),
            _buildCropBadge('Onion'),
            _buildCropBadge('Potato'),
            _buildCropBadge('Fruits'),
            _buildCropBadge('Spices'),
          ],
        ),
        
        // Amendments Bulb Container
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDCFCE7), width: 1),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xFF10B981), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Amendment: Add FYM 20t/ha. Use drip irrigation. Apply mulch to reduce evaporation. Add micro-nutrients.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF065F46),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          children: [
            const Icon(Icons.link, color: Color(0xFF64748B), size: 20),
            const SizedBox(width: 8),
            const Text(
              'Live IoT Sensor Data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 6 Sensor cards Grid matching values and states of Image 1
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.6,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildSensorCard(
              label: 'N - Nitrogen',
              value: '62.2',
              unit: 'kg/ha',
              icon: Icons.science_outlined,
              status: 'Normal',
            ),
            _buildSensorCard(
              label: 'P - Phosphorus',
              value: '39.2',
              unit: 'kg/ha',
              icon: Icons.filter_hdr_outlined,
              status: 'Normal',
            ),
            _buildSensorCard(
              label: 'K - Potassium',
              value: '24.8',
              unit: 'kg/ha',
              icon: Icons.opacity_outlined,
              status: 'Warning',
            ),
            _buildSensorCard(
              label: 'Temperature',
              value: '22.5',
              unit: '°C',
              icon: Icons.thermostat_outlined,
              status: 'Normal',
            ),
            _buildSensorCard(
              label: 'Humidity',
              value: '82.2',
              unit: '%',
              icon: Icons.cloud_queue_outlined,
              status: 'Warning',
            ),
            _buildSensorCard(
              label: 'Soil Moisture',
              value: '78.7',
              unit: '%',
              icon: Icons.water_drop_outlined,
              status: 'Normal',
            ),
          ],
        ),
        
        // Caption
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Last fetched: Just now · Auto-updates every hour',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCropBadge(String crop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1FAE5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco, size: 12, color: Color(0xFF059669)),
          const SizedBox(width: 4),
          Text(
            crop,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF047857),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required String status,
  }) {
    final isWarning = status == 'Warning';
    final cardBg = isWarning ? const Color(0xFFFFFBEB) : const Color(0xFFF0FDF4);
    final cardBorder = isWarning ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5);
    final iconColor = isWarning ? const Color(0xFFD97706) : const Color(0xFF059669);
    final badgeBg = isWarning ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5);
    final badgeText = isWarning ? '▲ Warning' : '✔ Normal';
    final badgeTextColor = isWarning ? const Color(0xFFB45309) : const Color(0xFF047857);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot(bool isCompleted, String label, {bool isCurrent = false}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent ? const Color(0xFF2D4B37) : (isCompleted ? const Color(0xFF2D4B37) : Colors.grey.shade300),
          ),
          child: isCompleted && !isCurrent
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : (isCurrent ? const Icon(Icons.circle, size: 10, color: Colors.white) : null),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? const Color(0xFF2D4B37) : Colors.grey,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isCompleted) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted ? const Color(0xFF2D4B37) : Colors.grey.shade300,
    );
  }

  Widget _buildCropCard(BuildContext context, CropModel crop) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFECFDF5), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.transparent,
                      child: CropImageHelper.getCropIcon(crop.cropName, size: 24),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      crop.cropName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: crop.matchPercentage > 80 ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: crop.matchPercentage > 80 ? const Color(0xFF10B981) : const Color(0xFFFBBF24),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${crop.matchPercentage.toInt()}% Match',
                    style: TextStyle(
                      color: crop.matchPercentage > 80 ? const Color(0xFF047857) : const Color(0xFFB45309),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(crop.season, style: const TextStyle(color: Colors.grey)),
            const Divider(),
            Row(
              children: [
                Expanded(child: _buildCropPropertyRow(Icons.thermostat, '${crop.minTemp.toInt()}°C - ${crop.maxTemp.toInt()}°C')),
                Expanded(child: _buildCropPropertyRow(Icons.water_drop, '${crop.waterNeed} Water')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCropPropertyRow(Icons.science, crop.fertilizerDetails)),
                Expanded(child: _buildCropPropertyRow(Icons.warning, '${crop.diseaseRisk}% Disease Risk')),
              ],
            ),
            _buildStatisticalFitDashboard(context, crop),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRouter.cropDetail, arguments: crop);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF10B981)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Details', style: TextStyle(color: Color(0xFF064E3B))),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmCropSelection(context, crop),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Select', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropPropertyRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  void _confirmCropSelection(BuildContext context, CropModel crop) {
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);
    final activeFarm = farmProvider.activeFarm;

    if (activeFarm == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No active farm found.')));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Crop Selection'),
        content: Text('Confirm ${crop.cropName} for ${activeFarm.farmName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final cropProvider = Provider.of<CropProvider>(context, listen: false);
              await cropProvider.saveActiveCrop(activeFarm.id, crop);
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.cropMaintenance, ModalRoute.withName(AppRouter.home));
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticalFitDashboard(BuildContext context, CropModel crop) {
    const liveN = 62.2;
    const liveP = 39.2;
    const liveK = 24.8;
    
    final name = crop.cropName.toLowerCase();
    double targetN = 50.0;
    double targetP = 50.0;
    double targetK = 80.0;
    
    if (name == 'rice') {
      targetN = 90.0; targetP = 42.0; targetK = 43.0;
    } else if (name == 'wheat') {
      targetN = 80.0; targetP = 40.0; targetK = 40.0;
    } else if (name == 'maize') {
      targetN = 40.0; targetP = 60.0; targetK = 30.0;
    } else if (name == 'tomato') {
      targetN = 28.0; targetP = 65.0; targetK = 175.0;
    } else if (name == 'potato') {
      targetN = 28.0; targetP = 58.0; targetK = 195.0;
    } else if (name == 'sugarcane') {
      targetN = 145.0; targetP = 48.0; targetK = 42.0;
    } else if (name == 'cotton') {
      targetN = 85.0; targetP = 75.0; targetK = 65.0;
    } else if (name == 'groundnut') {
      targetN = 55.0; targetP = 38.0; targetK = 55.0;
    } else if (name == 'millet') {
      targetN = 40.0; targetP = 25.0; targetK = 35.0;
    } else if (name == 'cabbage') {
      targetN = 25.0; targetP = 48.0; targetK = 115.0;
    }

    double getFitRatio(double live, double target) {
      if (target == 0) return 1.0;
      final diff = (live - target).abs();
      final ratio = 1.0 - (diff / target);
      return ratio.clamp(0.0, 1.0);
    }

    final fitN = getFitRatio(liveN, targetN);
    final fitP = getFitRatio(liveP, targetP);
    final fitK = getFitRatio(liveK, targetK);
    final overallFit = ((fitN + fitP + fitK) / 3.0) * 100;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.analytics_outlined, color: Color(0xFF475569), size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Statistical Fit to AI Crop Model',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: overallFit > 85 ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${overallFit.toStringAsFixed(1)}% Fit',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: overallFit > 85 ? const Color(0xFF047857) : const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildFitBar('Nitrogen (N)', liveN, targetN, fitN, const Color(0xFF3B82F6)),
          const SizedBox(height: 6),
          _buildFitBar('Phosphorus (P)', liveP, targetP, fitP, const Color(0xFF10B981)),
          const SizedBox(height: 6),
          _buildFitBar('Potassium (K)', liveK, targetK, fitK, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _buildFitBar(String label, double live, double target, double ratio, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label: ${live.toStringAsFixed(1)} vs Target ${target.toStringAsFixed(0)} kg/ha',
              style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
            Text(
              '${(ratio * 100).toStringAsFixed(0)}% Match',
              style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  void _showPairPlotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isWideScreen = screenWidth > 900;

        // Build all explanation elements to place on the left (wide screen) or top (narrow screen)
        Widget buildDetailsColumn() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bubble_chart_outlined, color: Color(0xFF10B981), size: 28),
                      SizedBox(width: 10),
                      Text(
                        'AI Crop Decision Clusters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (!isWideScreen)
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, color: Colors.white60),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'This pairwise cluster matrix represents how the AI classification models split different crop groups based on N-P-K nutrient profiles. Zoom/pinch to inspect decision boundaries.',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
              ),
              const SizedBox(height: 12),
              
              // Visual Interpretation Guide
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔍 HOW TO UNDERSTAND THIS GRAPH:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDialogGuideRow(
                      icon: Icons.bubble_chart_outlined,
                      color: const Color(0xFF38BDF8),
                      title: 'Colored Clusters:',
                      desc: 'Each cluster represents a different crop family (e.g. Rice, Tomato, Cotton) grouped by their nutrient requirements.',
                    ),
                    const SizedBox(height: 6),
                    _buildDialogGuideRow(
                      icon: Icons.grid_view_rounded,
                      color: const Color(0xFF34D399),
                      title: 'Grid Panels:',
                      desc: 'Different combinations plotted together (e.g., Nitrogen vs Phosphorus). Diagonal panels show data distribution curves.',
                    ),
                    const SizedBox(height: 6),
                    _buildDialogGuideRow(
                      icon: Icons.ads_click,
                      color: const Color(0xFFFBBF24),
                      title: 'AI Decision Zones:',
                      desc: 'The AI recommends a crop by placing your live soil scan coordinates on this map to see which crop sweet-spot it falls into.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              const Text(
                '🎨 QUICK KEY:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildLegendDot(const Color(0xFF3B82F6), 'Rice (High N)'),
                  _buildLegendDot(const Color(0xFFEF4444), 'Tomato (High K)'),
                  _buildLegendDot(const Color(0xFFF59E0B), 'Cotton (Balanced)'),
                ],
              ),
              const SizedBox(height: 16),
              
              const Text(
                '💡 Key Observation: There is a strong distinct cluster separation for Fruit crops (high Potassium K requirement) shown in the bottom right panels, whereas cereal crops (like Wheat & Rice) form overlapping diagonal boundaries at higher Nitrogen N levels.',
                style: TextStyle(
                  color: Color(0xFFA7F3D0),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ],
          );
        }

        Widget buildPlotContainer() {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155), width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: InteractiveViewer(
              maxScale: 10.0,
              minScale: 1.0,
              boundaryMargin: EdgeInsets.zero,
              child: SizedBox.expand(
                child: Image.network(
                  '${AppStrings.apiBaseUrl}/plots/11_crop_pairplot.png?v=${DateTime.now().millisecondsSinceEpoch}',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF10B981),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'http://10.0.2.2:5000/plots/11_crop_pairplot.png?v=${DateTime.now().millisecondsSinceEpoch}',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context2, error2, stackTrace2) {
                        return _buildClusterMockup();
                      },
                    );
                  },
                ),
              ),
            ),
          );
        }

        return Dialog(
          backgroundColor: const Color(0xFF0F172A),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: screenWidth * 0.95,
            height: screenHeight * 0.90,
            padding: const EdgeInsets.all(24),
            child: isWideScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left Panel - Explanations
                      SizedBox(
                        width: 340,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: buildDetailsColumn(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.close),
                              label: const Text('Close Visualization'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E293B),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Color(0xFF334155)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Right Panel - The Plot itself
                      Expanded(
                        child: buildPlotContainer(),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top - Title & Explanations (Scrollable if small screen)
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: buildDetailsColumn(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Bottom - The Plot itself
                      Expanded(
                        flex: 5,
                        child: buildPlotContainer(),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildClusterMockup() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: Colors.white30, size: 24),
          const SizedBox(height: 6),
          const Text(
            'Visual AI Decision Matrix (Local Vector Simulation)',
            style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildScatterCell('N vs P', [
                  const Offset(0.2, 0.8), const Offset(0.25, 0.75), const Offset(0.3, 0.85),
                  const Offset(0.7, 0.3), const Offset(0.75, 0.25), const Offset(0.8, 0.35),
                  const Offset(0.5, 0.5), const Offset(0.55, 0.48), const Offset(0.48, 0.52),
                ]),
                _buildScatterCell('N vs K', [
                  const Offset(0.15, 0.2), const Offset(0.2, 0.15), const Offset(0.22, 0.25),
                  const Offset(0.8, 0.8), const Offset(0.85, 0.75), const Offset(0.78, 0.82),
                  const Offset(0.45, 0.45), const Offset(0.5, 0.48), const Offset(0.52, 0.42),
                ]),
                _buildScatterCell('P vs N', [
                  const Offset(0.8, 0.2), const Offset(0.75, 0.25), const Offset(0.85, 0.3),
                  const Offset(0.3, 0.7), const Offset(0.25, 0.75), const Offset(0.35, 0.8),
                  const Offset(0.5, 0.5), const Offset(0.48, 0.55), const Offset(0.52, 0.48),
                ]),
                _buildScatterCell('P vs K', [
                  const Offset(0.2, 0.2), const Offset(0.25, 0.18), const Offset(0.18, 0.24),
                  const Offset(0.75, 0.78), const Offset(0.82, 0.85), const Offset(0.7, 0.72),
                  const Offset(0.5, 0.5), const Offset(0.55, 0.52), const Offset(0.48, 0.48),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScatterCell(String title, List<Offset> points) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _ScatterPainter(points),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogGuideRow({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.3),
              children: [
                TextSpan(text: '$title ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                TextSpan(text: desc, style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainScreenLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF475569),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ScatterPainter extends CustomPainter {
  final List<Offset> points;
  _ScatterPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paintRice = Paint()..color = const Color(0xFF3B82F6)..style = PaintingStyle.fill;
    final paintTomato = Paint()..color = const Color(0xFF10B981)..style = PaintingStyle.fill;
    final paintCotton = Paint()..color = const Color(0xFFF59E0B)..style = PaintingStyle.fill;

    final axisPaint = Paint()..color = Colors.white10..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axisPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), axisPaint);

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final offset = Offset(p.dx * size.width, (1 - p.dy) * size.height);
      Paint dotPaint;
      if (i < 3) {
        dotPaint = paintRice;
      } else if (i < 6) {
        dotPaint = paintTomato;
      } else {
        dotPaint = paintCotton;
      }
      canvas.drawCircle(offset, 4.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
