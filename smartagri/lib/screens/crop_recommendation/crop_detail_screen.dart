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
}

