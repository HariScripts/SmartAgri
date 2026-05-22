import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/crop_model.dart';

class CropProvider extends ChangeNotifier {
  Map<String, CropModel> _farmCrops = {};
  String? _currentFarmId;
  bool _isLoading = false;

  CropModel? get activeCrop => _currentFarmId != null ? _farmCrops[_currentFarmId] : null;
  bool get isLoading => _isLoading;

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> jsonMap = {};
    _farmCrops.forEach((key, value) {
      jsonMap[key] = value.toJson();
    });
    await prefs.setString('farm_crops', jsonEncode(jsonMap));
  }

  Future<void> loadActiveCrop(String farmId) async {
    _isLoading = true;
    _currentFarmId = farmId;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cropsJson = prefs.getString('farm_crops');
      if (cropsJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(cropsJson);
        final Map<String, CropModel> loaded = {};
        decoded.forEach((key, value) {
          loaded[key] = CropModel.fromJson(value);
        });
        _farmCrops = loaded;
      } else {
        _farmCrops = {};
      }
    } catch (e) {
      // Error loading, ignore
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveActiveCrop(String farmId, CropModel crop) async {
    _currentFarmId = farmId;
    _farmCrops[farmId] = crop;
    await _saveData();
    notifyListeners();
  }

  Future<void> clearActiveCrop(String farmId) async {
    _farmCrops.remove(farmId);
    await _saveData();
    notifyListeners();
  }
}

