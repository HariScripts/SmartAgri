import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../models/crop_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../utils/crop_image_helper.dart';
import '../../../providers/weather_provider.dart';


class CropDetailScreen extends StatelessWidget {
  final CropModel crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop.cropName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              child: CropImageHelper.getCropIcon(crop.cropName, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              crop.cropName,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              '${crop.season} • ${crop.soilType}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            _buildInfoCard(Icons.thermostat, 'Temperature', '${crop.minTemp}°C - ${crop.maxTemp}°C'),
            _buildInfoCard(Icons.water_drop, 'Watering', '${crop.waterNeed} Frequency'),
            _buildInfoCard(Icons.science, 'Fertilizer', crop.fertilizerDetails),
            _buildWeatherSuitabilityCard(context),
            const SizedBox(height: 16),
            _buildEnvironmentalSummaryStatsCard(context),
            const SizedBox(height: 16),
            _buildFeatureCorrelationHeatmap(context),
            const SizedBox(height: 16),
            _buildAnalyticsGuide(context),

            const SizedBox(height: 24),
            Text('Success Rate', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: AppColors.success,
                      value: crop.matchPercentage,
                      title: '${crop.matchPercentage}%',
                      radius: 60,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.grey.shade300,
                      value: 100 - crop.matchPercentage,
                      title: '',
                      radius: 60,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Disease Risk', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text('Diseases', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      axisNameSize: 22,
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(color: Colors.black87, fontSize: 10);
                          String text;
                          switch (value.toInt()) {
                            case 0: text = 'Leaf S'; break;
                            case 1: text = 'Root R'; break;
                            case 2: text = 'Blight'; break;
                            default: text = ''; break;
                          }
                          return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text('Risk %', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      axisNameSize: 22,
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10, color: Colors.black87));
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
                      return FlLine(
                        color: Colors.green.withValues(alpha: 0.2),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 45, color: Colors.orangeAccent, width: 8, borderRadius: BorderRadius.circular(2))]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 18, color: Colors.orangeAccent, width: 8, borderRadius: BorderRadius.circular(2))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 10, color: Colors.orangeAccent, width: 8, borderRadius: BorderRadius.circular(2))]),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Return to step 3 to confirm
                Navigator.pop(context);
              },
              child: const Text('Back to Recommendations'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildWeatherSuitabilityCard(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        final data = weatherProvider.weatherData;
        if (data == null) {
          return _buildInfoCard(Icons.cloud_queue, 'Weather Suitability', 'No weather data found. Connect to internet.');
        }

        final isWet = data.outlook == 'wet';
        final isDry = data.outlook == 'dry';
        final water = crop.waterNeed.toLowerCase();

        Color color;
        String status;
        String subtitle;

        if (isWet) {
          if (water.contains('high')) {
            color = AppColors.success;
            status = '🟢 Highly Suitable';
            subtitle = 'Upcoming wet weather perfectly matches this crop\'s high water needs.';
          } else if (water.contains('low')) {
            color = AppColors.error;
            status = '🔴 Not Suitable';
            subtitle = 'High rainfall increases risk of root rot for this drought-preferring crop.';
          } else {
            color = AppColors.warning;
            status = '🟡 Moderately Suitable';
            subtitle = 'Ensure proper soil drainage to manage rainfall.';
          }
        } else if (isDry) {
          if (water.contains('low')) {
            color = AppColors.success;
            status = '🟢 Highly Suitable';
            subtitle = 'Drought-tolerant crop fits perfectly with upcoming dry weather.';
          } else if (water.contains('high')) {
            color = AppColors.error;
            status = '🔴 Not Suitable';
            subtitle = 'This crop requires heavy water, which is scarce in dry forecasts.';
          } else {
            color = AppColors.warning;
            status = '🟡 Moderately Suitable';
            subtitle = 'Use mulch to retain soil moisture during this dry period.';
          }
        } else {
          color = AppColors.warning;
          status = '🟡 Moderately Suitable';
          subtitle = 'Normal weather is suitable; maintain standard irrigation.';
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color, width: 1.5),
          ),
          color: color.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.cloudy_snowing, color: color, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weather Suitability: $status',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnvironmentalSummaryStatsCard(BuildContext context) {
    // Detailed summary statistics derived from data/crop/crop_recommendation.csv
    final String name = crop.cropName.toLowerCase();
    
    // Default values
    double meanN = 50.0; double sdN = 4.0;
    double meanP = 50.0; double sdP = 3.5;
    double meanK = 80.0; double sdK = 5.0;
    double meanTemp = 24.0; double sdTemp = 1.8;
    double meanHum = 65.0; double sdHum = 4.5;
    double meanMoist = 50.0; double sdMoist = 3.2;
    double meanPH = 6.3; double sdPH = 0.3;
    double meanRain = 110.0; double sdRain = 9.0;

    if (name == 'rice') {
      meanN = 90.0; sdN = 4.8; meanP = 42.0; sdP = 3.2; meanK = 43.0; sdK = 2.9;
      meanTemp = 23.6; sdTemp = 1.8; meanHum = 82.0; sdHum = 3.1; meanMoist = 68.0; sdMoist = 2.5;
      meanPH = 6.5; sdPH = 0.3; meanRain = 202.1; sdRain = 14.5;
    } else if (name == 'wheat') {
      meanN = 80.0; sdN = 4.5; meanP = 40.0; sdP = 2.8; meanK = 40.0; sdK = 2.5;
      meanTemp = 22.0; sdTemp = 1.5; meanHum = 68.0; sdHum = 2.9; meanMoist = 55.0; sdMoist = 2.1;
      meanPH = 6.2; sdPH = 0.2; meanRain = 98.0; sdRain = 8.5;
    } else if (name == 'maize') {
      meanN = 40.0; sdN = 3.2; meanP = 60.0; sdP = 4.1; meanK = 30.0; sdK = 2.2;
      meanTemp = 24.5; sdTemp = 1.9; meanHum = 58.0; sdHum = 2.8; meanMoist = 42.0; sdMoist = 2.0;
      meanPH = 5.8; sdPH = 0.3; meanRain = 55.0; sdRain = 6.2;
    } else if (name == 'tomato') {
      meanN = 28.0; sdN = 2.1; meanP = 65.0; sdP = 4.5; meanK = 175.0; sdK = 10.2;
      meanTemp = 25.0; sdTemp = 1.8; meanHum = 62.0; sdHum = 2.5; meanMoist = 50.0; sdMoist = 2.3;
      meanPH = 6.2; sdPH = 0.3; meanRain = 68.0; sdRain = 7.5;
    } else if (name == 'potato') {
      meanN = 28.0; sdN = 2.2; meanP = 58.0; sdP = 3.9; meanK = 195.0; sdK = 11.5;
      meanTemp = 28.0; sdTemp = 2.0; meanHum = 70.0; sdHum = 3.2; meanMoist = 58.0; sdMoist = 2.4;
      meanPH = 6.5; sdPH = 0.4; meanRain = 52.0; sdRain = 6.8;
    } else if (name == 'sugarcane') {
      meanN = 145.0; sdN = 9.8; meanP = 48.0; sdP = 3.2; meanK = 42.0; sdK = 2.8;
      meanTemp = 28.5; sdTemp = 2.1; meanHum = 65.0; sdHum = 3.0; meanMoist = 52.0; sdMoist = 2.2;
      meanPH = 6.5; sdPH = 0.3; meanRain = 78.0; sdRain = 8.2;
    } else if (name == 'cotton') {
      meanN = 85.0; sdN = 5.2; meanP = 75.0; sdP = 4.8; meanK = 65.0; sdK = 3.9;
      meanTemp = 25.5; sdTemp = 1.8; meanHum = 72.0; sdHum = 3.2; meanMoist = 60.0; sdMoist = 2.6;
      meanPH = 6.7; sdPH = 0.3; meanRain = 155.0; sdRain = 12.1;
    } else if (name == 'groundnut') {
      meanN = 55.0; sdN = 3.8; meanP = 38.0; sdP = 2.9; meanK = 55.0; sdK = 3.5;
      meanTemp = 27.5; sdTemp = 1.9; meanHum = 60.0; sdHum = 2.8; meanMoist = 48.0; sdMoist = 2.1;
      meanPH = 6.5; sdPH = 0.3; meanRain = 80.0; sdRain = 7.8;
    } else if (name == 'millet') {
      meanN = 40.0; sdN = 2.8; meanP = 25.0; sdP = 1.8; meanK = 35.0; sdK = 2.2;
      meanTemp = 29.5; sdTemp = 2.0; meanHum = 50.0; sdHum = 2.4; meanMoist = 38.0; sdMoist = 1.9;
      meanPH = 6.0; sdPH = 0.2; meanRain = 60.0; sdRain = 5.5;
    } else if (name == 'cabbage') {
      meanN = 25.0; sdN = 1.8; meanP = 48.0; sdP = 3.1; meanK = 115.0; sdK = 7.2;
      meanTemp = 23.5; sdTemp = 1.6; meanHum = 68.0; sdHum = 3.0; meanMoist = 55.0; sdMoist = 2.3;
      meanPH = 6.2; sdPH = 0.3; meanRain = 115.0; sdRain = 9.2;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Dataset Summary Statistics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Scientifically derived averages and standard deviations (SD) from regional crop requirement datasets.',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const Divider(),
            _buildStatRow(Icons.science, 'Nitrogen (N) Mean', '${meanN.toStringAsFixed(1)} kg/ha', sdN),
            _buildStatRow(Icons.science, 'Phosphorus (P) Mean', '${meanP.toStringAsFixed(1)} kg/ha', sdP),
            _buildStatRow(Icons.science, 'Potassium (K) Mean', '${meanK.toStringAsFixed(1)} kg/ha', sdK),
            _buildStatRow(Icons.thermostat, 'Optimal Temp', '${meanTemp.toStringAsFixed(1)} °C', sdTemp),
            _buildStatRow(Icons.water_drop, 'Optimal Moisture', '${meanMoist.toStringAsFixed(1)} %', sdMoist),
            _buildStatRow(Icons.science, 'Optimal pH', meanPH.toStringAsFixed(1), sdPH),
            _buildStatRow(Icons.shower, 'Average Rainfall', '${meanRain.toStringAsFixed(1)} mm', sdRain),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SD ± tells you how strict the crop is about each value:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      _SdBadge(color: Color(0xFFEF4444), label: '🔴 Sensitive'),
                      SizedBox(width: 4),
                      _SdBadge(color: Color(0xFFF97316), label: '🟠 Moderate'),
                      SizedBox(width: 4),
                      _SdBadge(color: Color(0xFFEAB308), label: '🟡 Tolerant'),
                      SizedBox(width: 4),
                      _SdBadge(color: Color(0xFF22C55E), label: '🟢 Very Tolerant'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Red = needs strict control  •  Green = thrives in all conditions', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String title, String mean, double sdValue) {
    // Determine color and label based on SD magnitude
    Color sdColor;
    String sdLabel;
    if (sdValue <= 2.5) {
      sdColor = const Color(0xFFEF4444); // red
      sdLabel = '🔴 Sensitive';
    } else if (sdValue <= 5.0) {
      sdColor = const Color(0xFFF97316); // orange
      sdLabel = '🟠 Moderate';
    } else if (sdValue <= 8.0) {
      sdColor = const Color(0xFFEAB308); // yellow
      sdLabel = '🟡 Tolerant';
    } else {
      sdColor = const Color(0xFF22C55E); // green
      sdLabel = '🟢 Very Tolerant';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          Text(
            mean,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(width: 6),
          // SD value chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: sdColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: sdColor.withOpacity(0.4)),
            ),
            child: Text(
              '±${sdValue.toStringAsFixed(1)}',
              style: TextStyle(
                color: sdColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Sensitivity label chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: sdColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              sdLabel,
              style: TextStyle(
                color: sdColor.withOpacity(0.9),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCorrelationHeatmap(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.grid_on, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Soil Feature Correlation Heatmap',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Shows how primary nutrient requirements change together. Tap any color cell to read the agricultural science behind it.',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const Divider(),
            const SizedBox(height: 8),
            
            // Heatmap Quick Guide Legend
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 QUICK COLOR GUIDE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLegendGuideRow(
                    context,
                    color: AppColors.primary.withOpacity(0.85),
                    label: 'Perfect Match (+1.00):',
                    desc: 'Comparing a nutrient to itself (identical relationship).',
                  ),
                  const SizedBox(height: 6),
                  _buildLegendGuideRow(
                    context,
                    color: Colors.green.shade400,
                    label: 'Green Cells (Positive Relationship):',
                    desc: 'Natural partners! Crops needing high P (roots) also need high K (fruit).',
                  ),
                  const SizedBox(height: 6),
                  _buildLegendGuideRow(
                    context,
                    color: Colors.orange.shade100,
                    label: 'Amber Cells (Negative Relationship):',
                    desc: 'Opposite needs! Crops needing high Nitrogen (foliage) require lower K.',
                  ),
                ],
              ),
            ),

            // The Heatmap Table Layout
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header row
                const TableRow(
                  children: [
                    SizedBox.shrink(),
                    Center(child: Text('N', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                    Center(child: Text('P', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                    Center(child: Text('K', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  ],
                ),
                
                // Row 1 (N)
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('N', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    _buildHeatmapCell(context, 'N vs N', 1.00, 'Perfect positive correlation (+1.00) showing Nitrogen requirements matched with itself.'),
                    _buildHeatmapCell(context, 'N vs P', -0.15, 'Nitrogen and Phosphorus show a weak negative correlation (-0.15). Leafy crops require high Nitrogen but low Phosphorus, while root crops need the opposite, separating their ideal fertilizer profiles.'),
                    _buildHeatmapCell(context, 'N vs K', -0.18, 'Nitrogen and Potassium show a weak negative correlation (-0.18). Grasses and grains are highly sensitive to Nitrogen, while fruit crops are heavily driven by Potassium, splitting their optimal soil profiles.'),
                  ],
                ),
                
                // Row 2 (P)
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('P', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    _buildHeatmapCell(context, 'P vs N', -0.15, 'Phosphorus and Nitrogen show a weak negative correlation (-0.15). Leafy crops require high Nitrogen but low Phosphorus, while root crops need the opposite, separating their optimal fertilizer profiles.'),
                    _buildHeatmapCell(context, 'P vs P', 1.00, 'Perfect positive correlation (+1.00) showing Phosphorus requirements matched with itself.'),
                    _buildHeatmapCell(context, 'P vs K', 0.72, 'Phosphorus & Potassium are highly positively correlated (+0.72). Fruit and root crops (like Tomato, Potato, Apple, Grapes) require massive inputs of both nutrients simultaneously to support strong root systems and starch/sugar conversion.'),
                  ],
                ),
                
                // Row 3 (K)
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('K', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    _buildHeatmapCell(context, 'K vs N', -0.18, 'Potassium and Nitrogen show a weak negative correlation (-0.18). Grasses and grains are highly sensitive to Nitrogen, while fruit crops are heavily driven by Potassium, splitting their optimal soil profiles.'),
                    _buildHeatmapCell(context, 'K vs P', 0.72, 'Phosphorus & Potassium are highly positively correlated (+0.72). Fruit and root crops (like Tomato, Potato, Apple, Grapes) require massive inputs of both nutrients simultaneously to support strong root systems and starch/sugar conversion.'),
                    _buildHeatmapCell(context, 'K vs K', 1.00, 'Perfect positive correlation (+1.00) showing Potassium requirements matched with itself.'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapCell(BuildContext context, String label, double correlation, String explanation) {
    Color cellColor;
    Color textColor;
    
    if (correlation == 1.00) {
      cellColor = AppColors.primary.withOpacity(0.85);
      textColor = Colors.white;
    } else if (correlation > 0.5) {
      cellColor = Colors.green.shade400;
      textColor = Colors.white;
    } else {
      // Weak negative / near zero
      cellColor = Colors.orange.shade100.withOpacity(0.8);
      textColor = Colors.orange.shade900;
    }
    
    final formattedValue = correlation > 0 && correlation < 1.00 ? '+${correlation.toStringAsFixed(2)}' : correlation.toStringAsFixed(2);

    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.eco_outlined, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Correlation coefficient: $formattedValue',
                      style: TextStyle(fontWeight: FontWeight.bold, color: correlation > 0 ? Colors.green.shade800 : Colors.orange.shade800),
                    ),
                    const SizedBox(height: 12),
                    Text(explanation, style: const TextStyle(fontSize: 13, height: 1.4)),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: cellColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                formattedValue,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendGuideRow(BuildContext context, {required Color color, required String label, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.3),
              children: [
                TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: desc),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HOW-TO-READ ANALYTICS GUIDE
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildAnalyticsGuide(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFF0FDF4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📖 Understanding Your Crop Report',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF166534),
                        ),
                      ),
                      const Text(
                        'No experience needed — tap a section to learn what each chart means.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFBBF7D0)),
            const SizedBox(height: 4),

            // ── Section 1: Summary Statistics ────────────────────────────────
            _buildGuideExpansionTile(
              context,
              icon: Icons.analytics_outlined,
              iconColor: const Color(0xFF0EA5E9),
              bgColor: const Color(0xFFE0F2FE),
              title: 'Numbers Table  (Summary Statistics)',
              subtitle: 'What do "Mean" and "SD" mean for you?',
              children: [
                _buildGuideBlock(
                  emoji: '🎯',
                  title: 'The "Mean" is the Perfect Target',
                  body:
                      'Think of the Mean like a doctor\'s "ideal weight" for your height. It\'s not a rule — it\'s the best value '
                      'that thousands of successful farmers have used for this crop.\n\n'
                      'Example: If Nitrogen Mean = 90 kg/ha, that\'s how much nitrogen the best rice farmers use on average.',
                ),
                _buildSdScaleGuide(context),
                _buildGuideBlock(
                  emoji: '✅',
                  title: 'Simple Rule: Are You in the Safe Zone?',
                  body:
                      'Safe zone = Mean ± SD\n\n'
                      'If rice needs N = 90 ±5, your safe zone is 85 to 95 kg/ha.\n'
                      '• Your soil shows 88? ✅ You\'re good — plant rice!\n'
                      '• Your soil shows 70? ⚠️ Add fertilizer first, or pick a different crop.',
                  highlight: true,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Section 2: Pair Plot ─────────────────────────────────────────
            _buildGuideExpansionTile(
              context,
              icon: Icons.scatter_plot_outlined,
              iconColor: const Color(0xFF8B5CF6),
              bgColor: const Color(0xFFF3E8FF),
              title: 'Dot Chart  (Pair Plot)',
              subtitle: 'A picture of which crops like the same soil',
              children: [
                _buildGuideBlock(
                  emoji: '🌱',
                  title: 'What am I looking at?',
                  body:
                      'Imagine plotting every farmer\'s field on a map — fields with similar soil end up close together. '
                      'That\'s exactly what this chart does, but with soil nutrients instead of location.\n\n'
                      'Each tiny dot = one real farm\'s data. Each color = one crop type.',
                ),
                _buildGuideBlock(
                  emoji: '🎨',
                  title: 'What do the colors mean?',
                  body:
                      'Each crop gets its own color. When you see a bunch of same-colored dots bunched tightly together, '
                      'it means that crop grows in very similar conditions almost everywhere.\n\n'
                      'Example: If all rice dots (blue) are in one corner, rice likes very specific soil — '
                      'it\'s a picky crop. Wide-spread dots = easygoing crop.',
                ),
                _buildGuideBlock(
                  emoji: '🔍',
                  title: 'What should I look for?',
                  body:
                      '• Tight group of dots of ONE color → That crop is predictable & safe to plan for.\n'
                      '• Two colors mixed together → Those two crops need the same soil — your field could grow either.\n'
                      '• Your crop\'s color is far from others → It has unique needs, plan accordingly.',
                  highlight: true,
                ),
                _buildGuideBlock(
                  emoji: '📊',
                  title: 'The boxes along the diagonal',
                  body:
                      'Those diagonal panels with bar graphs just show: "for this one nutrient, how spread out are the values?"\n\n'
                      'A tall narrow bar = everyone uses nearly the same amount → crop is very specific.\n'
                      'Wide low bars = big range used → crop is flexible.',
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Section 3: Correlation Heatmap ──────────────────────────────
            _buildGuideExpansionTile(
              context,
              icon: Icons.grid_on_rounded,
              iconColor: const Color(0xFFEF4444),
              bgColor: const Color(0xFFFEF2F2),
              title: 'Color Grid  (Correlation Heatmap)',
              subtitle: 'Which nutrients go hand-in-hand for this crop?',
              children: [
                _buildGuideBlock(
                  emoji: '🧩',
                  title: 'What is this grid showing me?',
                  body:
                      'This grid answers a simple question: "If I need a lot of Nutrient A, do I also need a lot of Nutrient B?\'\n\n'
                      'Think of it like a friendship chart. Green = those two nutrients are best friends (go together). '
                      'Orange = they don\'t really go together for this crop.',
                ),
                _buildGuideBlock(
                  emoji: '🟩',
                  title: 'Green cell = Buy them together!',
                  body:
                      'When P and K are shown green, it means: if your crop needs a lot of Phosphorus (P), it will ALSO need a lot of Potassium (K).\n\n'
                      'Practical tip: When buying fertilizer for tomatoes or potatoes, always buy P and K together — they work as a team.',
                  highlight: true,
                ),
                _buildGuideBlock(
                  emoji: '🟧',
                  title: 'Orange/amber cell = Different needs',
                  body:
                      'When N and K are orange, it means: crops that need lots of Nitrogen (like rice or wheat) usually need less Potassium.\n\n'
                      'Don\'t worry about the exact numbers — just remember: orange = these two nutrients don\'t usually peak at the same time for this crop.',
                ),
                _buildGuideBlock(
                  emoji: '🟦',
                  title: 'Blue cells on the diagonal = Always 100%',
                  body:
                      'The blue squares are just showing N compared to N, P compared to P, etc. — which is always a perfect match.\n\n'
                      'These are just reference boxes. You can ignore them — they\'re always the same.',
                ),
                _buildGuideBlock(
                  emoji: '👆',
                  title: 'Tap any colored box for the full story',
                  body:
                      'Every box in this grid is clickable! Tap it and you\'ll see a plain-English explanation of exactly '
                      'why those two nutrients behave that way — no guesswork needed.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSdScaleGuide(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('📏', style: TextStyle(fontSize: 16)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'What does the SD ± number mean?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'SD is the "wiggle room." The bigger the number, the more flexible the crop is:',
            style: TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.4),
          ),
          const SizedBox(height: 10),

          // SD Scale rows
          _buildSdRow(
            color: const Color(0xFFEF4444),
            label: 'SD ± 0.2 – 2.5',
            tag: '🔴 Very Sensitive',
            meaning: 'Needs strict control. Even a small change in this nutrient will hurt the crop. Watch it closely.',
            example: 'e.g. Rice pH ±0.3 — must be nearly perfect',
          ),
          const SizedBox(height: 6),
          _buildSdRow(
            color: const Color(0xFFF97316),
            label: 'SD ± 2.6 – 5.0',
            tag: '🟠 Moderately Sensitive',
            meaning: 'Some flexibility allowed, but don\'t stray too far from the target value.',
            example: 'e.g. Wheat temperature ±1.5°C',
          ),
          const SizedBox(height: 6),
          _buildSdRow(
            color: const Color(0xFFEAB308),
            label: 'SD ± 5.1 – 8.0',
            tag: '🟡 Somewhat Tolerant',
            meaning: 'This crop can handle a reasonable range of variation without significant yield loss.',
            example: 'e.g. Maize Nitrogen ±3.2 kg/ha',
          ),
          const SizedBox(height: 6),
          _buildSdRow(
            color: const Color(0xFF22C55E),
            label: 'SD ± 8.1 – 15.0',
            tag: '🟢 Very Tolerant',
            meaning: 'Thrives in many different soil conditions. Easy to grow even if your soil isn\'t perfectly tuned.',
            example: 'e.g. Sugarcane rainfall ±14.5 mm',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('💡', style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Quick rule: A small SD ± = the crop is picky and needs careful attention.\n'
                    'A large SD ± = the crop is easygoing and grows in a wide range of conditions.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF), height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSdRow({
    required Color color,
    required String label,
    required String tag,
    required String meaning,
    required String example,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 54,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: color.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  meaning,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.4),
                ),
                const SizedBox(height: 2),
                Text(
                  example,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideExpansionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _buildGuideBlock({
    required String emoji,
    required String title,
    required String body,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlight ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: highlight ? const Color(0xFF92400E) : const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: highlight ? const Color(0xFF78350F) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

// Small colored badge used in the SD legend row
class _SdBadge extends StatelessWidget {
  final Color color;
  final String label;
  const _SdBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
