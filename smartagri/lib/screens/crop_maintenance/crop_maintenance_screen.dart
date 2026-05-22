import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_router.dart';
import '../../providers/crop_provider.dart';
import '../../providers/farm_provider.dart';
import '../../models/farm_model.dart';
import '../../providers/sensor_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/weather_provider.dart';
import '../../widgets/notification_bell.dart';
import '../home/widgets/crop_health_chart.dart';
import '../../utils/crop_image_helper.dart';
import '../../models/sensor_data_model.dart';
import 'dart:math' as math;

class CropMaintenanceScreen extends StatelessWidget {
  const CropMaintenanceScreen({super.key});

  List<Map<String, String>> _getActiveSensorAlerts(SensorDataModel? reading, String cropName) {
    if (reading == null) return [];
    
    final List<Map<String, String>> list = [];
    
    double minN = 80.0;
    double minMoist = 70.0;
    if (cropName == 'Wheat') {
      minN = 100.0;
      minMoist = 50.0;
    } else if (cropName == 'Sugarcane') {
      minN = 150.0;
      minMoist = 60.0;
    }
    
    if (reading.nitrogen < minN) {
      list.add({
        'title': 'Low Nitrogen Detected',
        'message': 'Nitrogen level is ${reading.nitrogen} kg/ha (Minimum required: ${minN.toInt()} kg/ha). Apply Urea immediately to restore leafy growth.',
        'type': 'nitrogen',
      });
    }
    
    if (reading.soilMoisture < minMoist) {
      list.add({
        'title': 'Low Soil Moisture Detected',
        'message': 'Soil moisture is ${reading.soilMoisture}% (Minimum required: ${minMoist.toInt()}%). Irrigate the field immediately to prevent wilting.',
        'type': 'moisture',
      });
    }

    if (reading.phosphorus < 40.0) {
      list.add({
        'title': 'Low Phosphorus Detected',
        'message': 'Phosphorus level is ${reading.phosphorus} kg/ha (Minimum required: 40 kg/ha). Apply DAP to support root development.',
        'type': 'phosphorus',
      });
    }

    if (reading.potassium < 40.0) {
      list.add({
        'title': 'Low Potassium Detected',
        'message': 'Potassium level is ${reading.potassium} kg/ha (Minimum required: 40 kg/ha). Apply MOP to enhance disease resistance.',
        'type': 'potassium',
      });
    }

    if (reading.humidity < 50.0) {
      list.add({
        'title': 'Low Humidity Detected',
        'message': 'Air humidity is ${reading.humidity}% (Minimum required: 50%). Monitor ventilation to optimize transpiration.',
        'type': 'humidity',
      });
    }
    
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cropMaintenance),
        actions: const [
          NotificationBell(),
          SizedBox(width: 16),
        ],
      ),
      body: Consumer3<CropProvider, FarmProvider, SensorProvider>(
        builder: (context, cropProvider, farmProvider, sensorProvider, child) {
          final activeCrop = cropProvider.activeCrop;
          final activeFarm = farmProvider.activeFarm;

          if (activeCrop == null || activeFarm == null) {
            return const Center(child: Text('No active crop. Please select a crop first.'));
          }

          final elapsedDays = DateTime.now().difference(activeCrop.selectedAt).inDays;
          int remainingDays = activeCrop.daysToHarvest - elapsedDays;
          if (remainingDays < 0) remainingDays = 0;
          
          final sensorReading = sensorProvider.lastReading;
          final activeAlerts = _getActiveSensorAlerts(sensorReading, activeCrop.cropName);
          
          double health = activeCrop.healthPercentage;
          if (activeAlerts.isNotEmpty) {
            health = (health - (activeAlerts.length * 30)).clamp(10.0, 100.0);
          }
          String healthStatus = 'Good';
          Color healthColor = AppColors.success;
          if (health < 40) {
            healthStatus = 'Critical';
            healthColor = AppColors.error;
          } else if (health < 70) {
            healthStatus = 'Needs Attention';
            healthColor = AppColors.warning;
          }
          
          List<double> dynamicHealthData = [];
          for (int i = 0; i <= elapsedDays; i++) {
            dynamicHealthData.add(math.max(10.0, health - (i % 3) * 2.0));
          }
          dynamicHealthData.last = health;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80), // Space for bottom bar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Active Crop Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        gradient: AppColors.maintenanceModuleGradient,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                child: CropImageHelper.getCropIcon(activeCrop.cropName, size: 24),
                                backgroundColor: Colors.transparent,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activeCrop.cropName,
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
                                    ),
                                    Text(
                                      activeFarm.farmName,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(activeCrop.season, style: const TextStyle(color: Colors.white)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Days Remaining: $remainingDays',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: elapsedDays / activeCrop.daysToHarvest,
                            backgroundColor: Colors.white.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final historyItem = CropHistoryModel(
                                  cropName: activeCrop.cropName,
                                  year: DateTime.now().year,
                                  yieldPercentage: health,
                                  healthData: dynamicHealthData,
                                  mistakes: activeAlerts.map<String>((a) => a['message'] ?? '').toList(),
                                );
                                await farmProvider.addCropToHistory(activeFarm.id, historyItem);
                                await cropProvider.clearActiveCrop(activeFarm.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Yield completed. Crop moved to history.')),
                                );
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primaryDark,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Is the yield over?', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Responsive Crop Health and Live Sensor Grid Split Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 900) {
                            return SizedBox(
                              height: 360, // Symmetrical vertical size for both cards
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: _buildCropHealthSection(context, health, healthStatus, healthColor, sensorReading),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 6,
                                    child: _buildLiveSensorSection(context, sensorReading, sensorProvider, activeFarm.id, activeCrop.cropName),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildCropHealthSection(context, health, healthStatus, healthColor, sensorReading),
                                const SizedBox(height: 24),
                                _buildLiveSensorSection(context, sensorReading, sensorProvider, activeFarm.id, activeCrop.cropName),
                              ],
                            );
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Smart Alerts Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Smart Alerts & Remedies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Builder(
                            builder: (context) {
                              if (activeAlerts.isEmpty) {
                                return Card(
                                  color: AppColors.success.withValues(alpha: 0.1),
                                  child: const ListTile(
                                    leading: Icon(Icons.check_circle, color: AppColors.success, size: 40),
                                    title: Text('✅ All Conditions Optimal', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                                    subtitle: Text('Your crop is thriving! Keep up the current care routine.'),
                                  ),
                                );
                              }

                              return Column(
                                children: activeAlerts.map((a) {
                                  final isNitrogen = a['type'] == 'nitrogen';
                                  final isMoisture = a['type'] == 'moisture';
                                  final isPhosphorus = a['type'] == 'phosphorus';
                                  final isPotassium = a['type'] == 'potassium';
                                  final isHumidity = a['type'] == 'humidity';

                                  final solveLabel = isNitrogen 
                                      ? 'Solve (Apply Urea)' 
                                      : (isMoisture 
                                          ? 'Solve (Irrigate Field)' 
                                          : (isPhosphorus 
                                              ? 'Solve (Apply DAP)' 
                                              : (isPotassium 
                                                  ? 'Solve (Apply MOP)' 
                                                  : 'Solve (Ventilate/Humidify)')));

                                  final solveIcon = isNitrogen 
                                      ? Icons.science 
                                      : (isMoisture 
                                          ? Icons.water_drop 
                                          : (isPhosphorus 
                                              ? Icons.grass 
                                              : (isPotassium 
                                                  ? Icons.bolt 
                                                  : Icons.wind_power)));

                                  return Card(
                                    color: AppColors.error.withValues(alpha: 0.1),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.warning, color: AppColors.error),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'CRITICAL ALERT',
                                                  style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(a['message'] ?? ''),
                                          const SizedBox(height: 12),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                // 1. Solve the alert in notifications
                                                Provider.of<NotificationProvider>(context, listen: false).solveFarmAlerts(activeFarm.id);
                                                
                                                // 2. Update simulated sensor data back to a normal healthy range
                                                sensorProvider.updateSensorData(
                                                  activeFarm.id,
                                                  SensorDataModel(
                                                    nitrogen: 95.0, // Optimal N level
                                                    phosphorus: 42.0,
                                                    potassium: 56.0,
                                                    temperature: 28.5,
                                                    humidity: 65.0,
                                                    soilMoisture: 75.0, // Optimal Moisture
                                                    timestamp: DateTime.now(),
                                                    status: 'Normal',
                                                  ),
                                                );

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: AppColors.success,
                                                    content: Row(
                                                      children: [
                                                        const Icon(Icons.check_circle, color: Colors.white),
                                                        const SizedBox(width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            isNitrogen 
                                                                ? 'Urea applied successfully! Nitrogen level restored to 95 kg/ha. Crop health is now 100%!'
                                                                : (isMoisture 
                                                                    ? 'Field irrigated successfully! Soil Moisture level restored to 75%. Crop health is now 100%!'
                                                                    : (isPhosphorus 
                                                                        ? 'DAP applied successfully! Phosphorus level restored to 55 kg/ha. Crop health is now 100%!'
                                                                        : (isPotassium 
                                                                            ? 'MOP applied successfully! Potassium level restored to 55 kg/ha. Crop health is now 100%!'
                                                                            : 'Ventilation optimized! Humidity level restored to 75%. Crop health is now 100%!'))),
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(solveIcon, color: Colors.white, size: 16),
                                              label: Text(solveLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.success,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Fertilizer Schedule
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Fertilizer Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _buildTimelineCard('Day 0 - Basal Dressing', 'Apply DAP + MOP at 50kg/ha each', 'Completed', true),
                          _buildTimelineCard('Day 30 - First Top-Dress', 'Apply Urea at 30kg/ha', 'Upcoming', false),
                          _buildTimelineCard('Day 60 - Second Top-Dress', 'Apply NPK as required', 'Upcoming', false),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Irrigation Schedule
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Irrigation Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Consumer<WeatherProvider>(
                            builder: (context, weatherProvider, child) {
                              final weatherData = weatherProvider.weatherData;
                              final maxRainProb = weatherData?.maxRainProbability ?? 0.0;
                              final showSmartSkip = maxRainProb >= 60.0;

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(color: AppColors.blueLight),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.water_drop, color: AppColors.blue, size: 40),
                                      title: const Text('Next Irrigation: Tomorrow'),
                                      subtitle: const Text('Frequency: Every 7 days\nAmount: 40mm per session'),
                                    ),
                                    if (showSmartSkip) ...[
                                      const Divider(height: 1, indent: 16, endIndent: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        margin: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.thunderstorm, color: AppColors.error),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                '🌧️ Smart Skip Recommended: High rain probability (${maxRainProb.toInt()}%) forecasted! Delay irrigation to save water.',
                                                style: const TextStyle(
                                                  color: AppColors.error,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Expert Disease Risk Analysis Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade100, width: 1),
                        ),
                        elevation: 1,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.shield_outlined, color: Colors.blueGrey.shade600, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Expert Disease Risk Analysis',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'AI Brain',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 180,
                                child: _buildDiseaseRiskChart(activeCrop.cropName),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Crop Health History Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade100, width: 1),
                        ),
                        elevation: 1,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.trending_up, color: Colors.redAccent.shade100, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Crop Health History',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Expert Track',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CropHealthChart(healthData: dynamicHealthData),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Maintenance Instructions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Crop Care Instructions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Card(
                            child: Column(
                              children: [
                                _buildExpansionTile('🌱 Growth Stage Care', 'Ensure the crop receives adequate sunlight and is kept free from competing weeds.'),
                                _buildExpansionTile('💧 Watering Guide', 'Maintain moist but not waterlogged soil. Deep watering is preferred.'),
                                _buildExpansionTile('🧪 Nutrient Management', 'Follow the specific NPK ratios provided in the fertilizer schedule.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
              
              // Bottom Floating Buttons
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
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
                      onPressed: () => Navigator.of(context).pushNamed(AppRouter.chatbot, arguments: activeCrop.cropName),
                      backgroundColor: AppColors.blue,
                      icon: const Icon(Icons.chat, color: Colors.white),
                      label: const Text('Chat', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimelineCard(String title, String subtitle, String status, bool isCompleted) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isCompleted ? Icons.check_circle : Icons.circle_outlined,
          color: isCompleted ? AppColors.success : Colors.grey,
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isCompleted ? Colors.black : Colors.grey)),
        subtitle: Text(subtitle),
        trailing: Text(status, style: TextStyle(color: isCompleted ? AppColors.success : Colors.grey)),
      ),
    );
  }
  
  Widget _buildExpansionTile(String title, String content) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content),
        ),
      ],
    );
  }

  Widget _buildDiseaseRiskChart(String cropName) {
    // Mock data for bar chart
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()}%',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            axisNameWidget: const Text(
              'Disease Name',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            axisNameSize: 22,
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final titles = ['Blight', 'Rust', 'Rot'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    titles[value.toInt() % titles.length], 
                    style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: const Text(
              'Disease %',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            axisNameSize: 22,
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: AppColors.divider, width: 1),
            left: BorderSide(color: AppColors.divider, width: 1),
            right: BorderSide.none,
            top: BorderSide.none,
          ),
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 65, color: AppColors.error, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 45, color: AppColors.warning, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 20, color: AppColors.success, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
        ],
      ),
    );
  }

  Widget _buildCropHealthSection(
    BuildContext context, 
    double health, 
    String healthStatus, 
    Color healthColor, 
    SensorDataModel? sensorReading,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Current Crop Health',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 32),
            CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 12.0,
              percent: health / 100,
              center: Text(
                '${health.toInt()}%',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
              ),
              progressColor: const Color(0xFF4D7C0F), 
              backgroundColor: Colors.grey.shade100,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 24),
            Text(
              healthStatus,
              style: const TextStyle(
                color: Color(0xFF4D7C0F), 
                fontWeight: FontWeight.w900, 
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sensorReading != null ? 'Last updated: Just now' : 'No telemetry data available',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveSensorSection(
    BuildContext context,
    SensorDataModel? reading,
    SensorProvider provider,
    String farmId,
    String cropName,
  ) {
    final bool isOffline = reading == null;

    final n = reading?.nitrogen ?? 0.0;
    final p = reading?.phosphorus ?? 0.0;
    final k = reading?.potassium ?? 0.0;
    final temp = reading?.temperature ?? 0.0;
    final hum = reading?.humidity ?? 0.0;
    final moist = reading?.soilMoisture ?? 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isOffline ? Icons.sensors_off : Icons.sensors, 
                      color: isOffline ? Colors.red.shade400 : const Color(0xFF10B981), 
                      size: 18
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Live Sensor Data',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isOffline ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isOffline ? Colors.red.shade300 : const Color(0xFF10B981), 
                      width: 1
                    ),
                  ),
                  child: Text(
                    isOffline ? 'OFFLINE' : 'LIVE',
                    style: TextStyle(
                      color: isOffline ? Colors.red.shade700 : const Color(0xFF047857),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Symmetrical Column of Rows (decouples height from width to prevent overflows)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildMaintenanceSensorCard('N', isOffline ? '-' : n.toStringAsFixed(1), 'kg/ha', Icons.science_outlined, isOffline)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMaintenanceSensorCard('P', isOffline ? '-' : p.toStringAsFixed(1), 'kg/ha', Icons.filter_hdr_outlined, isOffline)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildMaintenanceSensorCard('K', isOffline ? '-' : k.toStringAsFixed(1), 'kg/ha', Icons.opacity_outlined, isOffline)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMaintenanceSensorCard('Temp', isOffline ? '-' : temp.toStringAsFixed(1), '°C', Icons.thermostat_outlined, isOffline)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildMaintenanceSensorCard('Humidity', isOffline ? '-' : hum.toStringAsFixed(1), '%', Icons.cloud_queue_outlined, isOffline)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMaintenanceSensorCard('Moisture', isOffline ? '-' : moist.toStringAsFixed(0), '%', Icons.water_drop_outlined, isOffline)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (isOffline)
              ElevatedButton.icon(
                onPressed: () {
                  provider.setLive(cropName);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Color(0xFF10B981),
                      content: Text('⚡ IoT Sensors connected successfully! Telemetry is now LIVE.'),
                    ),
                  );
                },
                icon: const Icon(Icons.flash_on, color: Colors.white, size: 14),
                label: const Text(
                  'Connect Sensors (Make Live)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        provider.setOffline();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.redAccent,
                            content: Text('🔌 Sensors disconnected. System is now OFFLINE.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.power_off, color: Colors.redAccent, size: 12),
                      label: const Text(
                        'Disconnect',
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade200, width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final random = math.Random();
                        provider.updateSensorData(
                          farmId,
                          SensorDataModel(
                            nitrogen: 85.0 + random.nextDouble() * 15,
                            phosphorus: 42.0 + random.nextDouble() * 10,
                            potassium: 42.0 + random.nextDouble() * 15,
                            temperature: 24.0 + random.nextDouble() * 6,
                            humidity: 70.0 + random.nextDouble() * 10,
                            soilMoisture: 72.0 + random.nextDouble() * 10,
                            timestamp: DateTime.now(),
                            status: 'Normal',
                          ),
                        );
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sensors refreshed successfully!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.autorenew, color: Color(0xFF10B981), size: 12),
                      label: const Text(
                        'Refresh',
                        style: TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF10B981), width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceSensorCard(String label, String value, String unit, IconData icon, bool isOffline) {
    return Container(
      height: 66, // Exact fixed height for the sensor cards
      decoration: BoxDecoration(
        color: isOffline ? Colors.grey.shade50 : const Color(0xFFF8FAFC), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1), // Uniform border (prevents crashes)
      ),
      child: Row(
        children: [
          // High-fidelity left-side vertical accent border (grey if offline, green if live!)
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: isOffline ? Colors.grey.shade300 : const Color(0xFF10B981),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          
          // Main telemetry card content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 12, color: isOffline ? Colors.grey.shade400 : const Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 10, 
                          fontWeight: FontWeight.bold, 
                          color: isOffline ? Colors.grey.shade400 : const Color(0xFF64748B)
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w900, 
                          color: isOffline ? Colors.grey.shade400 : const Color(0xFF1E293B)
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 9, 
                          color: isOffline ? Colors.grey.shade400 : const Color(0xFF64748B), 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: isOffline ? Colors.grey.shade100 : const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isOffline ? Icons.link_off : Icons.check, 
                              size: 10, 
                              color: isOffline ? Colors.grey.shade400 : const Color(0xFF10B981)
                            ),
                            const SizedBox(width: 2),
                            Text(
                              isOffline ? 'OFFLINE' : 'OK',
                              style: TextStyle(
                                fontSize: 9,
                                color: isOffline ? Colors.grey.shade500 : const Color(0xFF047857),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
