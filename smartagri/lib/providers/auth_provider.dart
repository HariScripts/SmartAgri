import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── Local credential store ──────────────────────────────────────────────
  // Maps email (lowercase) → { password, fullName }
  // Pre-seeded with the account the user already created.
  final Map<String, Map<String, String>> _accounts = {
    'farmer12345@gmail.com': {
      'password': 'farmer12345',
      'fullName': 'Farmer',
    },
  };

  AuthProvider() {
    _checkAuthState();
  }

  void _checkAuthState() {
    // No persistent session — user must log in each session.
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

  /// Sign in with exact email + password match.
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final key = email.trim().toLowerCase();
      final account = _accounts[key];

      if (account == null) {
        _setError('No account found for "$email". Please register first.');
        _setLoading(false);
        return false;
      }

      if (account['password'] != password) {
        _setError('Incorrect password. Please try again.');
        _setLoading(false);
        return false;
      }

      // ✅ Correct credentials
      _user = UserModel(
        uid: key.hashCode.toString(),
        email: email.trim(),
        fullName: account['fullName'] ?? 'Farmer',
        createdAt: DateTime.now(),
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Login failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  /// Register a new account — email must be unique.
  Future<bool> register(String email, String password, String fullName) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final key = email.trim().toLowerCase();

      if (_accounts.containsKey(key)) {
        _setError('An account with this email already exists. Please log in.');
        _setLoading(false);
        return false;
      }

      if (password.length < 6) {
        _setError('Password must be at least 6 characters.');
        _setLoading(false);
        return false;
      }

      // Save new account credentials
      _accounts[key] = {
        'password': password,
        'fullName': fullName,
      };

      _user = UserModel(
        uid: key.hashCode.toString(),
        email: email.trim(),
        fullName: fullName,
        createdAt: DateTime.now(),
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Registration failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    _user = null;
    _setLoading(false);
  }
}
