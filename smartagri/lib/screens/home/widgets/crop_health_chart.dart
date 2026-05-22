import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';

class CropHealthChart extends StatelessWidget {
  final List<double> healthData; // 0-100 values
  final double aspectRatio;

  const CropHealthChart({
    super.key,
    required this.healthData,
    this.aspectRatio = 3.5,
  });

  @override
  Widget build(BuildContext context) {
    // If no data, provide a default flat line at 80%
    final data = healthData.isEmpty ? List.generate(30, (_) => 80.0) : healthData;
    
    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 20,
              verticalInterval: 5,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: AppColors.divider,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: AppColors.divider,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                axisNameWidget: const Text(
                  'Days',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                axisNameSize: 22,
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 5,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'D${value.toInt()}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                axisNameWidget: const Text(
                  'Health Percent',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                axisNameSize: 22,
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}%',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.left,
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            minX: 0,
            maxX: (data.length - 1).toDouble() > 0 ? (data.length - 1).toDouble() : 1,
            minY: 0,
            maxY: 100,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: AppColors.chartGreen,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                shadow: const Shadow(
                  blurRadius: 8,
                  color: Colors.black26,
                  offset: Offset(0, 4),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.chartGreen.withValues(alpha: 0.3),
                      AppColors.chartGreen.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
