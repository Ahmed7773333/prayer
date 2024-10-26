// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Alarm.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final MyApp _instance = MyApp._internal();

  factory MyApp() {
    return _instance;
  }

  MyApp._internal();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale('ar'),
        home: HomeScreen(),
      ),
    );
  }
}
