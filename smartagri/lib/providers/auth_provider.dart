import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
// Note: In a real app, this would use a real AuthService and FirestoreService
// Since we don't have the full Firebase setup running here, we'll mock it for the UI to work

class AuthProvider extends ChangeNotifier {
  // final FirebaseAuth _auth = FirebaseAuth.instance; // Removed to prevent Firebase initialization crash
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _checkAuthState();
  }

  void _checkAuthState() {
    // For this demonstration, we'll auto-login a mock user if they were previously logged in
    // Real implementation would listen to _auth.authStateChanges()
    // Mock user:
    // _user = UserModel(uid: 'user123', email: 'test@farmer.com', fullName: 'Test Farmer', createdAt: DateTime.now());
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      // MOCK IMPLEMENTATION
      await Future.delayed(const Duration(seconds: 2));
      if (email.isNotEmpty && password.length >= 6) {
        _user = UserModel(
          uid: 'user123',
          email: email,
          fullName: 'Demo Farmer',
          createdAt: DateTime.now(),
        );
        _setLoading(false);
        return true;
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    _setLoading(true);
    _setError(null);
    
    try {
      // MOCK IMPLEMENTATION
      await Future.delayed(const Duration(seconds: 2));
      _user = UserModel(
        uid: 'user123',
        email: email,
        fullName: fullName,
        createdAt: DateTime.now(),
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    // MOCK
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
    _setLoading(false);
  }
}
