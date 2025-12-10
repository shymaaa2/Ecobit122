import 'dart:async';
import 'package:flutter/material.dart';

class GeneralStreams {
  GeneralStreams._();


  static final StreamController<Locale> _languageController =
  StreamController<Locale>.broadcast();


  static Stream<Locale> get languageStream => _languageController.stream;


  static void updateLanguage(Locale locale) {
    _languageController.sink.add(locale);
  }

  static void dispose() {
    if (!_languageController.isClosed) {
      _languageController.close();
    }
  }
}
