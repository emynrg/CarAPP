
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:netcars/views/LoginPage.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Vous pouvez ajouter votre code d'initialisation ici.
    Future.delayed(Duration(seconds: 5)).then((value) => {
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (ctx) => LoginPage())),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            SizedBox(
              height: MediaQuery.of(context).size.height /100,
            ),
            Image(
              image: AssetImage("assets/images/logoNetCars.png"),
              width: 300.w,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 80,
            ),
            SpinKitFadingCircle(
              color: Color.fromARGB(255, 233, 50, 50),
              size: 50.0,
            ),
            
           
          ],
        ),
      ),
    );
  }
}
