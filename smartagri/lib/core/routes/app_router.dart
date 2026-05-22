import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/farm/add_farm_screen.dart';
import '../../screens/farm/farm_history_screen.dart';
import '../../screens/crop_recommendation/step1_soil_scan_screen.dart';
import '../../screens/crop_recommendation/step2_sensor_data_screen.dart';
import '../../screens/crop_recommendation/step3_recommendations_screen.dart';
import '../../screens/crop_recommendation/crop_detail_screen.dart';
import '../../screens/crop_maintenance/crop_maintenance_screen.dart';
import '../../screens/disease_detection/disease_detection_screen.dart';
import '../../screens/chatbot/chatbot_screen.dart';
import '../../models/crop_model.dart';
import '../../models/farm_model.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addFarm = '/add-farm';
  static const String farmHistory = '/farm-history';
  static const String cropRecommendationStep1 = '/crop-recommendation/step1';
  static const String cropRecommendationStep2 = '/crop-recommendation/step2';
  static const String cropRecommendationStep3 = '/crop-recommendation/step3';
  static const String cropDetail = '/crop-detail';
  static const String cropMaintenance = '/crop-maintenance';
  static const String diseaseDetection = '/disease-detection';
  static const String chatbot = '/chatbot';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(const SplashScreen(), settings);

      case login:
        return _fadeRoute(const LoginScreen(), settings);

      case register:
        return _fadeRoute(const RegisterScreen(), settings);

      case home:
        return _fadeRoute(const HomeScreen(), settings);

      case addFarm:
        return _slideRoute(const AddFarmScreen(), settings);

      case farmHistory:
        final farmId = settings.arguments as String?;
        return _slideRoute(FarmHistoryScreen(farmId: farmId ?? ''), settings);

      case cropRecommendationStep1:
        return _slideRoute(const Step1SoilScanScreen(), settings);

      case cropRecommendationStep2:
        return _slideRoute(const Step2SensorDataScreen(), settings);

      case cropRecommendationStep3:
        return _slideRoute(const Step3RecommendationsScreen(), settings);

      case cropDetail:
        final crop = settings.arguments as CropModel;
        return _slideRoute(CropDetailScreen(crop: crop), settings);

      case cropMaintenance:
        return _slideRoute(const CropMaintenanceScreen(), settings);

      case diseaseDetection:
        return _slideRoute(const DiseaseDetectionScreen(), settings);

      case chatbot:
        final contextData = settings.arguments as String?;
        return _slideRoute(ChatbotScreen(initialContext: contextData ?? ''), settings);

      default:
        return _fadeRoute(
          Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
