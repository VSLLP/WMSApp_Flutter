import 'package:epicor/app.dart';
import 'package:epicor/src/config/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

setupServices() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.colorDataHeaderColor,
  ));
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  runApp(const MyApp());
}
