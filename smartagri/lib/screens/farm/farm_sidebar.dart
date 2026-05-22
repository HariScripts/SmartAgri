import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/sensor_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/crop_provider.dart';
import '../../providers/weather_provider.dart';


class FarmSidebar extends StatelessWidget {
  const FarmSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primary,
      child: Consumer2<AuthProvider, FarmProvider>(
        builder: (context, authProvider, farmProvider, child) {
          final farms = farmProvider.farms;
          final activeFarm = farmProvider.activeFarm;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Section
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.eco, color: Colors.white, size: 32),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.appName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (activeFarm != null) ...[
                        Text(
                          activeFarm.farmName,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          activeFarm.location,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                const Divider(color: AppColors.accentDark),
                
                // Middle Section - My Farms
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Text(
                    AppStrings.myFarms,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: farms.length,
                    itemBuilder: (context, index) {
                      final farm = farms[index];
                      final isActive = activeFarm?.id == farm.id;
                      
                      return ListTile(
                        leading: const Icon(Icons.home, color: Colors.white),
                        title: Text(
                          farm.farmName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          farm.location,
                          style: TextStyle(
                            color: AppColors.accent.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isActive)
                              const Icon(Icons.check_circle, color: AppColors.accent),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: Colors.white),
                              onSelected: (value) {
                                if (value == 'history') {
                                  Navigator.pop(context); // close drawer
                                  Navigator.of(context).pushNamed(
                                    AppRouter.farmHistory,
                                    arguments: farm.id,
                                  );
                                } else if (value == 'delete') {
                                  // TODO: Show delete confirmation
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'history',
                                  child: Text(AppStrings.viewHistory),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text(AppStrings.deleteFarm, style: TextStyle(color: AppColors.error)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () async {
                          farmProvider.switchFarm(farm.id);
                          final cropProvider = Provider.of<CropProvider>(context, listen: false);
                          await cropProvider.loadActiveCrop(farm.id);
                          
                          if (context.mounted) {
                            Provider.of<SensorProvider>(context, listen: false)
                                .startAutoRefresh(farm.id, cropProvider.activeCrop?.cropName ?? 'Rice');
                             final notifProvider = Provider.of<NotificationProvider>(context, listen: false);
                             await notifProvider.loadNotifications(authProvider.user!.uid, activeFarmId: farm.id);
                             notifProvider.startPeriodicReminders(context);
                             // Fetch new weather forecast dynamically!
                             Provider.of<WeatherProvider>(context, listen: false).fetchWeather(farm.location);
                          }
                          
                          if (context.mounted) {
                            Navigator.pop(context); // close drawer
                          }
                        },
                      );
                    },
                  ),
                ),
                
                // Bottom Section
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed(AppRouter.addFarm);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amber,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(AppStrings.addFarm),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.accentDark),
                      TextButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          await authProvider.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed(AppRouter.login);
                          }
                        },
                        icon: const Icon(Icons.logout, color: AppColors.error),
                        label: const Text(AppStrings.signOut, style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
