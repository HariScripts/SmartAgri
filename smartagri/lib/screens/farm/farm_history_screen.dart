import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/farm_provider.dart';
import '../../core/routes/app_router.dart';
import '../home/widgets/crop_health_chart.dart';
import '../../utils/crop_image_helper.dart';

class FarmHistoryScreen extends StatelessWidget {
  final String farmId;

  const FarmHistoryScreen({super.key, required this.farmId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.home);
            },
          ),
        ],
      ),
      body: Consumer<FarmProvider>(
        builder: (context, farmProvider, child) {
          final farm = farmProvider.farms.firstWhere((f) => f.id == farmId, orElse: () => farmProvider.activeFarm!);
          final history = farm.cropHistory;

          if (history.isEmpty) {
            return const Center(
              child: Text('No history available for this farm yet.'),
            );
          }

          return _buildCropHistoryTab(history, farm.farmName);
        },
      ),
    );
  }

  Widget _buildCropHistoryTab(List history, String farmName) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          child: ListTile(
            onTap: () => _showCropDetailDialog(context, item, farmName),
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: CropImageHelper.getCropIcon(item.cropName, size: 24),
            ),
            title: Text(item.cropName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Year: ${item.year} | Farm: $farmName'),
            trailing: Chip(
              label: Text('Yield: ${item.yieldPercentage.toInt()}%'),
              backgroundColor: item.yieldPercentage > 80 ? AppColors.success.withValues(alpha: 0.2) : AppColors.amber.withValues(alpha: 0.2),
            ),
          ),
        );
      },
    );
  }



  void _showCropDetailDialog(BuildContext context, dynamic item, String farmName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.transparent,
                    child: CropImageHelper.getCropIcon(item.cropName, size: 48),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.cropName,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Farm: $farmName | Year: ${item.year}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              
              const Text(
                'Yield Performance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Center(
                child: CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 10.0,
                  percent: item.yieldPercentage / 100,
                  center: Text(
                    '${item.yieldPercentage.toInt()}%',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  progressColor: item.yieldPercentage > 80 ? AppColors.success : AppColors.amber,
                  backgroundColor: Colors.grey.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              
              const SizedBox(height: 24),
              const Text(
                'Crop Health Timeline',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: CropHealthChart(
                  healthData: (item.healthData as List<dynamic>).cast<double>(),
                  aspectRatio: 3.5,
                ),
              ),
              
              const SizedBox(height: 24),
              const Text(
                'Mistakes / Observations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (item.mistakes.isEmpty)
                Card(
                  color: AppColors.success.withValues(alpha: 0.1),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success),
                        SizedBox(width: 12),
                        Text(
                          'Perfect crop cycle! No mistakes recorded.',
                          style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...item.mistakes.map<Widget>((m) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.warning, color: AppColors.warning),
                    title: Text(m),
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }
}
