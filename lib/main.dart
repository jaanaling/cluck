import 'package:cluckmazing_recipe/src/app/presentation/app_root.dart';
import 'package:cluckmazing_recipe/src/core/dependency_injection.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencyInjection();


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const AppRoot(),
  );
}
