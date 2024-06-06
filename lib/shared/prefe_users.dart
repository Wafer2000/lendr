import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lendr/firebase/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUser {
  static late SharedPreferences _prefs;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _prefs = await SharedPreferences.getInstance();
  }

  String get uid {
    return _prefs.getString('uid') ?? '';
  }

  set uid(String value) {
    _prefs.setString('uid', value);
  }

  String get loanId {
    return _prefs.getString('loanId') ?? '';
  }

  set loanId(String value) {
    _prefs.setString('loanId', value);
  }
}