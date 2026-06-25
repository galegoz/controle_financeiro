import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final DatabaseHelper _databaseHelper;

  SettingsRepositoryImpl(this._databaseHelper);

  @override
  Future<SettingsEntity> getSettings() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('settings', limit: 1);

    if (maps.isNotEmpty) {
      return SettingsModel.fromMap(maps.first);
    } else {
      return SettingsEntity(monthlyLimit: 3000.0, currency: 'BRL');
    }
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    final db = await _databaseHelper.database;
    final model = SettingsModel.fromEntity(settings);

    // Como é sempre 1 linha na tabela
    final maps = await db.query('settings', limit: 1);
    if (maps.isNotEmpty) {
      final id = maps.first['id'];
      await db.update(
        'settings',
        model.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      await db.insert('settings', model.toMap());
    }
  }
}
