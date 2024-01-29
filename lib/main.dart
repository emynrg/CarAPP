import 'package:flutter/material.dart';
import 'package:netcars/views/AcceuilPage.dart';
import 'package:netcars/views/SplashScreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return ScreenUtilInit(
       designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return MaterialApp(
        
      routes: {
        '/AcceuilPage': (context) => AcceuilPage(),
       
      }, 
      debugShowCheckedModeBanner: false,
        
        home: Splash());
      }
      
    );
   
  }
}

