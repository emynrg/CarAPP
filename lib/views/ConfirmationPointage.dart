import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netcars/constantes/colors.dart';

class ConfirmationPointage extends StatelessWidget {
  const ConfirmationPointage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Votre Pointage a \n été bien effectué',
            style: TextStyle(
              fontFamily: 'PoppinsSemiBold',
              fontSize: 25.sp,
              color: Colors.black,
            ),
          ),


        SizedBox(
            height: MediaQuery.of(context).size.width / 8,
          ),

           GestureDetector(
            // houni l fouk bsh naamel l fonction w nhotha fel ontap

            onTap: () {
              Navigator.pushNamed(context,
                  '/AcceuilPage'); // Cette ligne effectue la navigation vers la page "Home"
            },

            child: Container(
              padding: const EdgeInsets.all(23).w,
              margin: const EdgeInsets.symmetric(horizontal: 70).h,
              decoration: BoxDecoration(
                color: mainGray,
                borderRadius: BorderRadius.circular(8),
                 border: Border.all(
                  color: borderRed, // Couleur de la bordure
                  width: 2.0, // Épaisseur de la bordure
                ),
              ),
              child: Center(
                child: Text(
                  "OK",
                  style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Colors.black,
                    fontSize: 24.sp,
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}