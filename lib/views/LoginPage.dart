import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netcars/components/boutonLogin.dart';

class LoginPage extends StatelessWidget {
  const LoginPage
  ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     body: Center(
       child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height/15,
          ),
         Image(
            image: AssetImage("assets/images/logoNetCars.png"),
            width: MediaQuery.of(context).size.height /2,
          ),
         
            SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          

          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
         BoutonLogin(),



        
     
     
     
     
     
       ]),
     ),
    );
  }
}