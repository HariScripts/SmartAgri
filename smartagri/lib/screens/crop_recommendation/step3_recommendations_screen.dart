import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_router.dart';
import '../../../models/crop_model.dart';
import '../../../providers/crop_provider.dart';
import '../../../providers/farm_provider.dart';
import '../../../providers/weather_provider.dart';
import '../../../widgets/custom_button.dart';


class Step3RecommendationsScreen extends StatelessWidget {
  const Step3RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final soilType = ModalRoute.of(context)?.settings.arguments as String? ?? 'Black Soil';

    List<CropModel> getRecommendations(String soil) {
      if (soil == 'Alluvial Soil') {
        return [
          CropModel(cropName: 'Rice', season: 'Kharif', soilType: soil, matchPercentage: 96.0, healthPercentage: 100.0, daysToHarvest: 120, minTemp: 22.0, maxTemp: 35.0, waterNeed: 'High', fertilizerDetails: 'NPK 120:60:60', diseaseRisk: 25.0, selectedAt: DateTime.now()),
          CropModel(cropName: 'Wheat', season: 'Rabi', soilType: soil, matchPercentage: 92.0, healthPercentage: 100.0, daysToHarvest: 140, minTemp: 10.0, maxTemp: 25.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 100:50:50', diseaseRisk: 15.0, selectedAt: DateTime.now()),
        ];
      } else if (soil == 'Red Soil') {
        return [
          CropModel(cropName: 'Groundnut', season: 'Kharif', soilType: soil, matchPercentage: 94.0, healthPercentage: 100.0, daysToHarvest: 110, minTemp: 25.0, maxTemp: 30.0, waterNeed: 'Low', fertilizerDetails: 'NPK 20:40:40', diseaseRisk: 20.0, selectedAt: DateTime.now()),
          CropModel(cropName: 'Millet', season: 'Kharif', soilType: soil, matchPercentage: 88.0, healthPercentage: 100.0, daysToHarvest: 90, minTemp: 26.0, maxTemp: 33.0, waterNeed: 'Low', fertilizerDetails: 'NPK 40:20:20', diseaseRisk: 10.0, selectedAt: DateTime.now()),
        ];
      } else if (soil == 'Loamy Soil') {
        return [
          CropModel(cropName: 'Tomato', season: 'Year-round', soilType: soil, matchPercentage: 95.0, healthPercentage: 100.0, daysToHarvest: 80, minTemp: 18.0, maxTemp: 28.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 100:50:50', diseaseRisk: 30.0, selectedAt: DateTime.now()),
          CropModel(cropName: 'Potato', season: 'Rabi', soilType: soil, matchPercentage: 89.0, healthPercentage: 100.0, daysToHarvest: 100, minTemp: 15.0, maxTemp: 22.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 120:80:100', diseaseRisk: 35.0, selectedAt: DateTime.now()),
        ];
      } else if (soil == 'Clay Soil') {
        return [
          CropModel(cropName: 'Cabbage', season: 'Rabi', soilType: soil, matchPercentage: 91.0, healthPercentage: 100.0, daysToHarvest: 90, minTemp: 15.0, maxTemp: 20.0, waterNeed: 'High', fertilizerDetails: 'NPK 120:60:60', diseaseRisk: 25.0, selectedAt: DateTime.now()),
        ];
      } else {
        // Default / Black Soil
        return [
          CropModel(cropName: 'Cotton', season: 'Kharif', soilType: soil, matchPercentage: 95.0, healthPercentage: 100.0, daysToHarvest: 150, minTemp: 21.0, maxTemp: 30.0, waterNeed: 'Medium', fertilizerDetails: 'NPK 100:50:50', diseaseRisk: 30.0, selectedAt: DateTime.now()),
          CropModel(cropName: 'Sugarcane', season: 'Perennial', soilType: soil, matchPercentage: 88.0, healthPercentage: 100.0, daysToHarvest: 365, minTemp: 25.0, maxTemp: 35.0, waterNeed: 'High', fertilizerDetails: 'NPK 250:100:100', diseaseRisk: 40.0, selectedAt: DateTime.now()),
        ];
      }
    }

    final List<CropModel> recommendations = getRecommendations(soilType);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.aiRecommendations),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            heroTag: 'homeBtn',
            onPressed: () => Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.home),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'chatBtn',
            onPressed: () => Navigator.of(context).pushNamed(AppRouter.chatbot, arguments: 'crop recommendations'),
            backgroundColor: AppColors.blue,
            icon: const Icon(Icons.chat, color: Colors.white),
            label: const Text('Chat', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Analysis Summary Bar
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildSummaryChip('Soil: $soilType'),
                  _buildSummaryChip('N: 85'),
                  _buildSummaryChip('P: 42'),
                  _buildSummaryChip('K: 56'),
                  _buildSummaryChip('Temp: 28°C'),
                ],
              ),
            ),
          ),
          
          // Seasonal Weather Recommendation Banner
          Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              final data = weatherProvider.weatherData;
              if (data == null || data.outlook == 'normal') return const SizedBox.shrink();
              
              final isWet = data.outlook == 'wet';
              final color = isWet ? Colors.blue.shade800 : AppColors.amberDark;
              final icon = isWet ? Icons.thunderstorm : Icons.wb_sunny;
              final msg = isWet 
                  ? "🌧️ Rainy Season Approaching! Rice and other water-loving crops are highly suitable." 
                  : "☀️ Dry Weather Approaching! Choose drought-tolerant crops (Groundnut, Millet) to conserve water.";
              
              return Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  border: Border.all(color: color, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        msg,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final crop = recommendations[index];
                return _buildCropCard(context, crop);
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.home);
                },
                child: const Text('Start New Scan'),
              ),
            ),
          ),
          const SizedBox(height: 60), // Space for floating buttons
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildCropCard(BuildContext context, CropModel crop) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.primaryLight, width: 2),
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
                    const Icon(Icons.eco, color: AppColors.primary),
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
                    color: crop.matchPercentage > 80 ? AppColors.success : AppColors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${crop.matchPercentage.toInt()}% Match',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Text(crop.season, style: const TextStyle(color: Colors.grey)),
            const Divider(),
            Row(
              children: [
                Expanded(child: _buildPropertyRow(Icons.thermostat, '${crop.minTemp.toInt()}°C - ${crop.maxTemp.toInt()}°C')),
                Expanded(child: _buildPropertyRow(Icons.water_drop, '${crop.waterNeed} Water')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildPropertyRow(Icons.science, crop.fertilizerDetails)),
                Expanded(child: _buildPropertyRow(Icons.warning, '${crop.diseaseRisk}% Disease Risk')),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRouter.cropDetail, arguments: crop);
                    },
                    child: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmCropSelection(context, crop),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                    child: const Text('Select'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyRow(IconData icon, String text) {
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
}
