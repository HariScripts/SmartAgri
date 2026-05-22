import 'dart:js' as js;

class NotificationService {
  static Future<void> initialize() async {
    if (js.context.hasProperty('Notification')) {
      final permission = js.context['Notification']['permission'];
      if (permission != 'granted' && permission != 'denied') {
        js.context['Notification'].callMethod('requestPermission');
      }
    }
  }

  static Future<void> showNotification(String title, String body) async {
    if (js.context.hasProperty('Notification')) {
      final permission = js.context['Notification']['permission'];
      if (permission == 'granted') {
        js.context.callMethod('eval', [
          'new Notification("$title", { body: "$body", icon: "assets/assets/images/logo.png" })'
        ]);
      } else {
        // Fallback: request permission and show if granted
        js.context['Notification'].callMethod('requestPermission').then((result) {
          if (result == 'granted') {
            js.context.callMethod('eval', [
              'new Notification("$title", { body: "$body", icon: "assets/assets/images/logo.png" })'
            ]);
          }
        });
      }
    }
  }

  static Future<void> startBackgroundAlerts() async {
    // Web periodic background alerts (can run while tab is open/active)
  }
}
