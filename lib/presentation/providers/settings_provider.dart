import 'package:flutter/material.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repository;

  SettingsEntity _settings = SettingsEntity(monthlyLimit: 3000.0, currency: 'BRL');
  bool _isLoading = false;

  SettingsProvider(this._repository) {
    loadSettings();
  }

  SettingsEntity get settings => _settings;
  double get monthlyLimit => _settings.monthlyLimit;
  String get currency => _settings.currency;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _settings = await _repository.getSettings();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateMonthlyLimit(double limit) async {
    _settings = _settings.copyWith(monthlyLimit: limit);
    await _repository.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> updateCurrency(String currency) async {
    _settings = _settings.copyWith(currency: currency);
    await _repository.updateSettings(_settings);
    notifyListeners();
  }
}
