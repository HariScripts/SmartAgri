import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/notification_model.dart';
import '../models/sensor_data_model.dart';
import '../services/notification_service.dart';
import 'sensor_provider.dart';
import 'farm_provider.dart';
import 'crop_provider.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  Timer? _reminderTimer;
  
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications(String userId, {String? activeFarmId}) async {
    // If we already have notifications loaded for this active farm, do not re-mock/reset them!
    if (activeFarmId != null && _notifications.any((n) => n.farmId == activeFarmId)) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 100));
    
    // Seed new farm notifications
    if (activeFarmId != null) {
      final int seed = activeFarmId.hashCode;
      final int issueType = seed.abs() % 5;
      
      String message = 'Low Nitrogen Detected. Apply Urea at 50 kg/hectare.';
      if (issueType == 1) {
        message = 'Low Soil Moisture Detected. Please irrigate your field immediately.';
      } else if (issueType == 2) {
        message = 'Low Phosphorus Detected. Apply DAP at 40 kg/hectare.';
      } else if (issueType == 3) {
        message = 'Low Potassium Detected. Apply MOP at 30 kg/hectare.';
      } else if (issueType == 4) {
        message = 'Low Humidity Detected. Monitor ventilation and environmental conditions.';
      }

      final nitrogenAlert = NotificationModel(
        id: 'alert_sensor_$activeFarmId',
        message: message,
        type: 'alert',
        farmId: activeFarmId,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      );
      
      final infoAlert = NotificationModel(
        id: 'info_irrigation_$activeFarmId',
        message: 'Upcoming irrigation schedule tomorrow.',
        type: 'info',
        farmId: activeFarmId,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      );

      _notifications.addAll([nitrogenAlert, infoAlert]);
      notifyListeners();

      // Trigger local system notifications for unread alerts
      if (!nitrogenAlert.isRead) {
        NotificationService.showNotification(
          '⚠️ SmartAgri Alert',
          nitrogenAlert.message,
        );
      }
    }
  }

  void solveFarmAlerts(String farmId) {
    _notifications = _notifications.map((n) {
      if (n.farmId == farmId && n.type == 'alert') {
        return NotificationModel(
          id: n.id,
          message: n.message,
          type: n.type,
          farmId: n.farmId,
          timestamp: n.timestamp,
          isRead: true, // Solved!
        );
      }
      return n;
    }).toList();
    notifyListeners();
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
    if (!notification.isRead) {
      NotificationService.showNotification(
        notification.type == 'alert' ? '⚠️ SmartAgri Alert' : 'ℹ️ SmartAgri Info',
        notification.message,
      );
    }
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = NotificationModel(
        id: _notifications[index].id,
        message: _notifications[index].message,
        type: _notifications[index].type,
        farmId: _notifications[index].farmId,
        timestamp: _notifications[index].timestamp,
        isRead: true,
      );
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) {
      return NotificationModel(
        id: n.id,
        message: n.message,
        type: n.type,
        farmId: n.farmId,
        timestamp: n.timestamp,
        isRead: true,
      );
    }).toList();
    notifyListeners();
  }

  void startPeriodicReminders(BuildContext context) {
    _reminderTimer?.cancel();
    // Periodically run reminder check every 3 hours as requested by user
    _reminderTimer = Timer.periodic(const Duration(hours: 3), (timer) {
      final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
      final farmProvider = Provider.of<FarmProvider>(context, listen: false);
      final cropProvider = Provider.of<CropProvider>(context, listen: false);
      
      final activeFarm = farmProvider.activeFarm;
      final activeCrop = cropProvider.activeCrop;
      final reading = sensorProvider.lastReading;
      
      if (activeFarm != null && activeCrop != null && reading != null) {
        final activeAlerts = _getActiveSensorAlertsForReminder(reading, activeCrop.cropName);
        for (var alert in activeAlerts) {
          NotificationService.showNotification(
            '⚠️ SmartAgri Reminder',
            '${activeFarm.farmName}: ${alert['message']}',
          );
        }
      }
    });
  }

  void stopPeriodicReminders() {
    _reminderTimer?.cancel();
  }

  List<Map<String, String>> _getActiveSensorAlertsForReminder(SensorDataModel? reading, String cropName) {
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
        'message': 'Low Nitrogen level (${reading.nitrogen} kg/ha). Apply Urea.',
        'type': 'nitrogen',
      });
    }
    if (reading.soilMoisture < minMoist) {
      list.add({
        'message': 'Low Soil Moisture (${reading.soilMoisture}%). Irrigate field.',
        'type': 'moisture',
      });
    }
    if (reading.phosphorus < 40.0) {
      list.add({
        'message': 'Low Phosphorus level (${reading.phosphorus} kg/ha). Apply DAP.',
        'type': 'phosphorus',
      });
    }
    if (reading.potassium < 40.0) {
      list.add({
        'message': 'Low Potassium level (${reading.potassium} kg/ha). Apply MOP.',
        'type': 'potassium',
      });
    }
    if (reading.humidity < 50.0) {
      list.add({
        'message': 'Low Humidity level (${reading.humidity}%). Monitor ventilation.',
        'type': 'humidity',
      });
    }
    
    return list;
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    super.dispose();
  }
}
