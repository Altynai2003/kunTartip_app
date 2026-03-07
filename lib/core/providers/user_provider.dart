import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProvider extends ChangeNotifier {
  static const String _boxName = 'userBox';
  static const String _nameKey = 'userName';

  String? _userName;

  String? get userName => _userName;

  bool get isLoggedIn => _userName != null && _userName!.isNotEmpty;

  Future<void> init() async {
    final box = await Hive.openBox(_boxName);
    _userName = box.get(_nameKey);
    notifyListeners();
  }

  Future<void> saveName(String name) async {
    _userName = name;
    final box = Hive.box(_boxName);
    await box.put(_nameKey, name);
    notifyListeners();
  }

  Future<void> logout() async {
    _userName = null;
    final box = Hive.box(_boxName);
    await box.delete(_nameKey);
    notifyListeners();
  }
}
