class SettingsEntity {
  final double monthlyLimit;
  final String currency;

  SettingsEntity({
    required this.monthlyLimit,
    required this.currency,
  });

  SettingsEntity copyWith({
    double? monthlyLimit,
    String? currency,
  }) {
    return SettingsEntity(
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      currency: currency ?? this.currency,
    );
  }
}
