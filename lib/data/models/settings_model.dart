import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  SettingsModel({
    required super.monthlyLimit,
    required super.currency,
  });

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      monthlyLimit: map['monthlyLimit'] as double,
      currency: map['currency'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monthlyLimit': monthlyLimit,
      'currency': currency,
    };
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      monthlyLimit: entity.monthlyLimit,
      currency: entity.currency,
    );
  }
}
