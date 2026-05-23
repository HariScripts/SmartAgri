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
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                IconButton(
                  icon: const Icon(Icons.bubble_chart_outlined, color: Colors.white, size: 22),
                  tooltip: 'View Decision Clusters',
                  onPressed: () => _showPairPlotDialog(context),
                ),
              ],
            ),
          ),
          
          // Cluster Color Legend Row on main screen
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.grey.shade100,
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
            const SizedBox(height: 12),
            // --- NEW STATISTICAL FIT DASHBOARD ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryLight.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics_outlined, color: AppColors.primary, size: 16),
                      const SizedBox(width: 6),
                      const Text(
                        "Statistical Fit (Soil Scan vs Historical Mean)",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildFitMetric("Nitrogen (N) fit", 85, crop.cropName == 'Rice' ? 90 : (crop.cropName == 'Wheat' ? 80 : (crop.cropName == 'Tomato' ? 28 : 50))),
                  _buildFitMetric("Phosphorus (P) fit", 42, crop.cropName == 'Rice' ? 42 : (crop.cropName == 'Wheat' ? 40 : (crop.cropName == 'Tomato' ? 65 : 45))),
                  _buildFitMetric("Potassium (K) fit", 56, crop.cropName == 'Rice' ? 43 : (crop.cropName == 'Wheat' ? 40 : (crop.cropName == 'Tomato' ? 175 : 55))),
                ],
              ),
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

  Widget _buildFitMetric(String nutrient, double scanned, double mean) {
    final double diff = (scanned - mean).abs();
    final double pctDiff = (diff / mean) * 100;
    final bool isOptimal = pctDiff <= 25; // 25% deviation is considered highly suitable/optimal
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nutrient,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54),
          ),
          Row(
            children: [
              Text(
                'Scan: ${scanned.toInt()} | Mean: ${mean.toInt()}  ',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isOptimal ? AppColors.success.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isOptimal ? 'Optimal' : 'Adjust Required',
                  style: TextStyle(
                    color: isOptimal ? AppColors.success : Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPairPlotDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
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
                  Row(
                    children: [
                      Icon(Icons.bubble_chart_outlined, color: AppColors.primary, size: 28),
                      const SizedBox(width: 10),
                      const Text(
                        'AI Crop Decision Clusters',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  if (!isWideScreen)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(ctx),
                    )
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
                  _buildDialogLegendDot(const Color(0xFF3B82F6), 'Rice (High N)'),
                  _buildDialogLegendDot(const Color(0xFFEF4444), 'Tomato (High K)'),
                  _buildDialogLegendDot(const Color(0xFFF59E0B), 'Cotton (Balanced)'),
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
                  'http://localhost:5000/plots/11_crop_pairplot.png?v=${DateTime.now().millisecondsSinceEpoch}',
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

  Widget _buildDialogLegendDot(Color color, String label) {
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
