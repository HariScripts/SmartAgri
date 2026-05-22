import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/crop_provider.dart';
import '../../providers/sensor_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/weather_provider.dart';
import '../../widgets/notification_bell.dart';
import '../farm/farm_sidebar.dart';
import 'widgets/farm_header.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/weather_widget.dart';
import 'widgets/crop_health_chart.dart';
import 'widgets/module_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../utils/crop_image_helper.dart';
import '../../models/sensor_data_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      final farmProvider = Provider.of<FarmProvider>(context, listen: false);
      await farmProvider.loadFarms(authProvider.user!.uid);
      
      // Load other data based on active farm
      if (farmProvider.activeFarm != null) {
        final cropProvider = Provider.of<CropProvider>(context, listen: false);
        await cropProvider.loadActiveCrop(farmProvider.activeFarm!.id);
        
        // Start sensor polling
        final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
        sensorProvider.startAutoRefresh(farmProvider.activeFarm!.id, cropProvider.activeCrop?.cropName ?? 'Rice');
        
        final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        notificationProvider.loadNotifications(authProvider.user!.uid, activeFarmId: farmProvider.activeFarm!.id);
        notificationProvider.startPeriodicReminders(context);

        // Fetch Weather Forecast
        Provider.of<WeatherProvider>(context, listen: false).fetchWeather(farmProvider.activeFarm!.location);

      }
    }
  }

  void _showProfileSheet() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    authProvider.user?.fullName.substring(0, 1).toUpperCase() ?? 'F',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(authProvider.user?.fullName ?? 'Farmer'),
                subtitle: Text(authProvider.user?.email ?? ''),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.switch_account_outlined),
                title: const Text('Switch Account'),
                onTap: () async {
                  Navigator.pop(context);
                  await authProvider.signOut();
                  if (mounted) Navigator.of(context).pushReplacementNamed(AppRouter.login);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('Logout', style: TextStyle(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(authProvider);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.signOut();
              if (mounted) Navigator.of(context).pushReplacementNamed(AppRouter.login);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const FarmSidebar(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Consumer<FarmProvider>(
          builder: (context, farmProvider, child) {
            return Text(farmProvider.activeFarm?.farmName ?? AppStrings.appName);
          },
        ),
        actions: [
          const NotificationBell(),
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: Icon(Icons.person, size: 18, color: AppColors.primary),
            ),
            onPressed: _showProfileSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer3<FarmProvider, CropProvider, SensorProvider>(
        builder: (context, farmProvider, cropProvider, sensorProvider, child) {
          if (farmProvider.isLoading || cropProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (farmProvider.farms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.agriculture, size: 80, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text('No farms found', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRouter.addFarm),
                    child: const Text(AppStrings.addFarm),
                  )
                ],
              ),
            );
          }

          final activeFarm = farmProvider.activeFarm!;
          final activeCrop = cropProvider.activeCrop;
          final lastSensorReading = sensorProvider.lastReading;

          // Compute Days to harvest
          int daysRemaining = 0;
          double computedHealth = 100.0;
          if (activeCrop != null) {
            final elapsed = DateTime.now().difference(activeCrop.selectedAt).inDays;
            daysRemaining = activeCrop.daysToHarvest - elapsed;
            if (daysRemaining < 0) daysRemaining = 0;

            final activeAlerts = _getActiveSensorAlerts(lastSensorReading, activeCrop.cropName);
            
            computedHealth = activeCrop.healthPercentage;
            if (activeAlerts.isNotEmpty) {
              computedHealth = (computedHealth - (activeAlerts.length * 30)).clamp(10.0, 100.0);
            }
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FarmHeader(
                  farmName: activeFarm.farmName,
                  location: activeFarm.location,
                  onSwitchTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                WeatherWidget(
                  location: activeFarm.location,
                  onRetry: () => Provider.of<WeatherProvider>(context, listen: false).fetchWeather(activeFarm.location),
                ),

                
                // Dashboard Cards
                SizedBox(
                  height: 140,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: [
                      DashboardCard(
                        title: AppStrings.activeCrop,
                        value: activeCrop?.cropName ?? 'No Active Crop',
                        icon: Icons.grass,
                        emojiIcon: activeCrop != null ? CropImageHelper.getCropIcon(activeCrop.cropName, size: 24) : null,
                        subtitle: activeCrop != null ? '${daysRemaining == activeCrop.daysToHarvest ? 0 : activeCrop.daysToHarvest - daysRemaining}th day' : '-',
                      ),
                      DashboardCard(
                        title: AppStrings.cropHealth,
                        value: activeCrop != null ? '${computedHealth.toInt()}%' : '-',
                        icon: Icons.favorite,
                        customValueWidget: activeCrop != null ? CircularPercentIndicator(
                          radius: 30.0,
                          lineWidth: 6.0,
                          percent: computedHealth / 100,
                          center: Text(
                            '${computedHealth.toInt()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          progressColor: computedHealth > 70 
                              ? AppColors.success 
                              : computedHealth > 40 
                                  ? AppColors.warning 
                                  : AppColors.error,
                        ) : const Text('-', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      DashboardCard(
                        title: AppStrings.daysToHarvest,
                        value: activeCrop != null ? daysRemaining.toString() : '-',
                        icon: Icons.calendar_today,
                        subtitle: activeCrop != null ? 'days remaining' : '',
                      ),
                      DashboardCard(
                        title: AppStrings.sensorStatus,
                        value: lastSensorReading != null ? AppStrings.live : AppStrings.offline,
                        icon: Icons.sensors,
                        subtitle: lastSensorReading != null 
                            ? 'Updated ${timeago.format(lastSensorReading.timestamp)}' 
                            : 'No data',
                        customValueWidget: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            if (lastSensorReading != null) {
                              sensorProvider.setOffline();
                            } else {
                              sensorProvider.setLive(activeCrop?.cropName ?? 'Rice');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: lastSensorReading != null ? AppColors.success : AppColors.error,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  lastSensorReading != null ? Icons.sensors : Icons.sensors_off,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  lastSensorReading != null ? AppStrings.live : AppStrings.offline,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Core Modules
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.coreModules,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ModuleCard(
                        name: AppStrings.cropRecommendation,
                        description: AppStrings.cropRecommendationDesc,
                        icon: Icons.energy_savings_leaf,
                        gradient: AppColors.cropModuleGradient,
                        onTap: () => Navigator.of(context).pushNamed(AppRouter.cropRecommendationStep1),
                      ),
                      ModuleCard(
                        name: AppStrings.cropMaintenance,
                        description: AppStrings.cropMaintenanceDesc,
                        icon: Icons.spa,
                        gradient: AppColors.maintenanceModuleGradient,
                        onTap: () {
                          if (activeCrop == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a crop first using Crop Recommendation')),
                            );
                            return;
                          }
                          Navigator.of(context).pushNamed(AppRouter.cropMaintenance);
                        },
                      ),
                      ModuleCard(
                        name: AppStrings.diseaseDetection,
                        description: AppStrings.diseaseDetectionDesc,
                        icon: Icons.biotech,
                        gradient: AppColors.diseaseModuleGradient,
                        onTap: () => Navigator.of(context).pushNamed(AppRouter.diseaseDetection),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Smart Assistant',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ModuleCard(
                        name: 'SmartAgri Chatbot',
                        description: 'Get instant AI guidance for your farm.',
                        icon: Icons.chat_bubble_outline,
                        gradient: LinearGradient(colors: [AppColors.primary, AppColors.blue]),
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRouter.chatbot, 
                          arguments: activeCrop?.cropName ?? 'general farming'
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Smart Alerts Preview
                Consumer<NotificationProvider>(
                  builder: (context, notifProvider, child) {
                    final unreadAlerts = notifProvider.notifications.where((n) => !n.isRead && (n.type == 'alert' || n.type == 'critical')).toList();
                    if (unreadAlerts.isEmpty) return const SizedBox.shrink();
                    
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        color: AppColors.error.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.error),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.warning, color: AppColors.error),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppStrings.smartAlerts,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                unreadAlerts.first.message,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Open notification bell sheet
                                    // Hack: find bell icon and tap it
                                  },
                                  child: const Text('View All'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
