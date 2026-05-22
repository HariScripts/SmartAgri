import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/farm_provider.dart';
import 'providers/crop_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/weather_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Local Notifications and Background alerts!
  await NotificationService.initialize();
  await NotificationService.startBackgroundAlerts();

  // Initialize Providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FarmProvider()),
        ChangeNotifierProvider(create: (_) => CropProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const SmartAgriApp(),
    ),
  );
}

