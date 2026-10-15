import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';

enum AuthState { initial, roleSelection, login, otp, authenticated }

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  bool _isPartner = false;
  UserModel? _user;
  String _phoneNumber = '';

  AuthState get state => _state;
  bool get isPartner => _isPartner;
  UserModel? get user => _user;
  String get phoneNumber => _phoneNumber;
  bool get isAuthenticated => _state == AuthState.authenticated;

  void setRoleSelection() {
    _state = AuthState.roleSelection;
    notifyListeners();
  }

  void selectRole(bool isPartner) {
    _isPartner = isPartner;
    _state = AuthState.login;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
  }

  void sendOtp() {
    _state = AuthState.otp;
    notifyListeners();
  }

  void verifyOtp(String otp) {
    // Mock verification - accept any 4-digit OTP
    _user = MockData.currentUser.copyWith(isPartner: _isPartner);
    _state = AuthState.authenticated;
    notifyListeners();
  }

  void logout() {
    _state = AuthState.initial;
    _user = null;
    _isPartner = false;
    _phoneNumber = '';
    notifyListeners();
  }
}
