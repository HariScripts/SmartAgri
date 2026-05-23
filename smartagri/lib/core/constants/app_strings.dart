class AppStrings {
  AppStrings._();

  static const String appName = 'SmartAgri';
  static const String tagline = 'Grow Smarter, Harvest Better';
  static const String copyright = '© SmartAgri 2024';

  // API Base URL (Change this to your deployed Render/Railway URL when deploying)
  static const String apiBaseUrl = 'https://smartagri-backend-kraj.onrender.com';

  // Auth
  static const String welcome = 'Welcome Back, Farmer';
  static const String signIn = 'Sign In';
  static const String signOut = 'Sign Out';
  static const String createAccount = 'Create Account';
  static const String forgotPassword = 'Forgot Password?';
  static const String orDivider = 'OR';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String resetPassword = 'Reset Password';

  // Home
  static const String activeCrop = 'Active Crop';
  static const String cropHealth = 'Crop Health';
  static const String daysToHarvest = 'Days to Harvest';
  static const String sensorStatus = 'Sensor Status';
  static const String coreModules = 'Core Modules';
  static const String cropHealthHistory = 'Crop Health History';
  static const String last30Days = 'Last 30 days';
  static const String smartAlerts = 'Smart Alerts';

  // Modules
  static const String cropRecommendation = 'Crop Recommendation';
  static const String cropRecommendationDesc =
      'AI-powered crop suggestions based on soil & sensors';
  static const String cropMaintenance = 'Crop Maintenance';
  static const String cropMaintenanceDesc =
      'Fertilizer schedules, alerts & health monitoring';
  static const String diseaseDetection = 'Disease Detection';
  static const String diseaseDetectionDesc =
      'Scan leaves to detect diseases & get treatment';

  // Farm
  static const String addFarm = 'Add New Farm';
  static const String farmName = 'Farm Name';
  static const String farmLocation = 'Farm Location';
  static const String myFarms = 'My Farms';
  static const String switchFarm = 'Switch Farm';
  static const String deleteFarm = 'Delete Farm';
  static const String viewHistory = 'View History';
  static const String noneSelected = 'None Selected';

  // Sensor
  static const String nitrogen = 'Nitrogen (N)';
  static const String phosphorus = 'Phosphorus (P)';
  static const String potassium = 'Potassium (K)';
  static const String temperature = 'Temperature';
  static const String humidity = 'Humidity';
  static const String soilMoisture = 'Soil Moisture';

  // Steps
  static const String soilClassification = 'Soil Classification';
  static const String sensorData = 'Sensor Data & Soil Results';
  static const String aiRecommendations = 'AI Crop Recommendations';

  // Notifications
  static const String smartAgriAlert = '⚠️ SmartAgri Alert';
  static const String allNormal = '✅ All conditions back to normal';
  static const String markAllRead = 'Mark All as Read';

  // Status
  static const String live = 'LIVE';
  static const String offline = 'OFFLINE';
  static const String normal = 'Normal';
  static const String critical = 'Critical';
  static const String warning = 'Warning';

  // Hive Box Names
  static const String activeCropBox = 'active_crop';
  static const String sensorBox = 'sensor_data';
  static const String settingsBox = 'settings';

  // SharedPreferences Keys
  static const String keyActiveFarmId = 'active_farm_id';
  static const String keyLastSensorTimestamp = 'last_sensor_ts';

  // Errors
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorGeneric = 'Something went wrong. Please try again.';
}
