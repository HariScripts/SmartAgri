import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/farm_model.dart';
import 'package:uuid/uuid.dart';

class FarmProvider extends ChangeNotifier {
  List<FarmModel> _farms = [];
  FarmModel? _activeFarm;
  bool _isLoading = false;

  List<FarmModel> get farms => _farms;
  FarmModel? get activeFarm => _activeFarm;
  bool get isLoading => _isLoading;

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String farmsJson = jsonEncode(_farms.map((f) => f.toJson()).toList());
    await prefs.setString('saved_farms', farmsJson);
    if (_activeFarm != null) {
      await prefs.setString('active_farm_id', _activeFarm!.id);
    }
  }

  Future<void> loadFarms(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? farmsJson = prefs.getString('saved_farms');
      final String? activeId = prefs.getString('active_farm_id');

      if (farmsJson != null) {
        final List<dynamic> decoded = jsonDecode(farmsJson);
        _farms = decoded.map((e) => FarmModel.fromJson(e)).toList();
        
        if (activeId != null) {
          try {
            _activeFarm = _farms.firstWhere((farm) => farm.id == activeId);
          } catch (_) {
            if (_farms.isNotEmpty) _activeFarm = _farms.first;
          }
        } else if (_farms.isNotEmpty) {
          _activeFarm = _farms.first;
        }
      } else {
        _farms = [
          FarmModel(
            id: 'farm1',
            farmName: 'Green Acres',
            location: 'Pune, Maharashtra',
            userId: userId,
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          FarmModel(
            id: 'farm2',
            farmName: 'Golden Fields',
            location: 'Nashik, Maharashtra',
            userId: userId,
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
        ];
        _activeFarm = _farms.first;
        await _saveData();
      }
    } catch (e) {
      // In case of error, just use empty or mock
    }

    _isLoading = false;
    notifyListeners();
  }

  void switchFarm(String farmId) {
    try {
      _activeFarm = _farms.firstWhere((farm) => farm.id == farmId);
      _saveData();
      notifyListeners();
    } catch (e) {
      // Farm not found
    }
  }

  Future<bool> addFarm(String farmName, String location, String userId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    
    final newFarm = FarmModel(
      id: const Uuid().v4(),
      farmName: farmName,
      location: location,
      userId: userId,
      createdAt: DateTime.now(),
    );

    _farms.add(newFarm);
    _activeFarm = newFarm; // Switch to the new farm automatically
    
    await _saveData();

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> addCropToHistory(String farmId, CropHistoryModel history) async {
    final index = _farms.indexWhere((f) => f.id == farmId);
    if (index != -1) {
      final farm = _farms[index];
      final updatedHistory = List<CropHistoryModel>.from(farm.cropHistory)..insert(0, history);
      final updatedFarm = farm.copyWith(cropHistory: updatedHistory);
      _farms[index] = updatedFarm;
      if (_activeFarm?.id == farmId) {
        _activeFarm = updatedFarm;
      }
      await _saveData();
      notifyListeners();
    }
  }
}

