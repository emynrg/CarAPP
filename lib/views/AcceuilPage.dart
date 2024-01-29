import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netcars/Models/car.dart';
import 'package:netcars/Models/car2.dart';
import 'package:netcars/ViewModel/carViewModels.dart';
import 'package:netcars/constantes/colors.dart';
import 'package:netcars/views/CarList.dart';
import 'package:netcars/views/ConfirmationOCR.dart';
import 'package:netcars/views/ConfirmationPointage.dart';
import 'package:netcars/views/CameraPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

final storage = FlutterSecureStorage();

Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}

class AcceuilPage extends StatefulWidget {
  const AcceuilPage({Key? key}) : super(key: key);

  @override
  State<AcceuilPage> createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
  String? _token;
  final CarService _carService = CarService();
  TextEditingController _codeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await getToken();
  }

  void navigateToCarDetailsPage(String vin) async {
    final Car? carDetails = await _carService.fetchCarDetails(vin, _token!);
    if (carDetails != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationOCRPage(
            vin: carDetails.vin,
            model: carDetails.model,
            carActions: carDetails.carActions,
            actionPerforms: carDetails.actionPerforms
                ?.map((item) => item as Map<String, dynamic>)
                .toList(),
          ),
        ),
      );
    }
  }


Future<void> _showCodeInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Saisir les 6 derniers caractères du code VIN'),
          content: TextField(
            controller: _codeController,
            maxLength: 6,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Entrez les caractères',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text(
                "Annuler",
                style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Utilisez _codeController.text pour obtenir la saisie
                String codeVin = _codeController.text;

                // Récupérez la liste des voitures
                List<Car2>? vinList =
                    await CarService().fetchCarsByVinSuffix(codeVin, _token!);

                // Fermer le dialogue
                Navigator.of(context).pop();

                // Vérifiez si la liste des voitures n'est pas nulle
                if (vinList != null) {
                  // Naviguez vers la page CarList en passant la liste des voitures
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarList(carList: vinList),
                    ),
                  );
                } else {
                  // Affichez un message d'erreur si la liste est nulle
                  print('Aucune voiture trouvée.');
                }
              },
              child: Text(
                "Valider",
                style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width / 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfirmationPointage()));
                },
                child: _buildCustomContainer(
                    "assets/images/pointage.png", 'Pointage'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 10,
              ),
              GestureDetector(
                onTap: () async {
                  final vin = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraPage()),
                  );
                  if (vin != null) {
                    navigateToCarDetailsPage(vin);
                  }
                },
                child:
                    _buildCustomContainer("assets/images/camera.png", 'Action'),
              ),
               SizedBox(
                height: MediaQuery.of(context).size.width / 10,
              ),
              GestureDetector(
                onTap: () async {
                  await _showCodeInputDialog();
                },
                child: _buildCustomContainer(
                    "assets/images/taper.png", 'taper code vin'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomContainer(String imagePath, String label) {
    return Container(
      padding: EdgeInsets.all(20).w,
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        color: mainGray,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderRed,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            image: AssetImage(imagePath),
            width: MediaQuery.of(context).size.height / 8,
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PoppinsSemiBold',
              fontSize: label == 'Pointage' ? 20.sp : 18.sp,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
