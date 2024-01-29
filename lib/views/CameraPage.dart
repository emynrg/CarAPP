import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netcars/Models/car.dart';
import 'package:netcars/ViewModel/carViewModels.dart';
import 'package:netcars/constantes/colors.dart';
import 'package:netcars/views/ConfirmationOCR.dart';
import 'package:netcars/views/ConfirmationPointage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  final textRecogniser = TextRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras![0], ResolutionPreset.max);
    await cameraController!.initialize();
    setState(() {});
  }

  Future<void> takePictureAndScanVin(BuildContext context) async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      print("La caméra n'est pas initialisée");
      return;
    }

    try {
      final picture = await cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(picture.path);
      final recognisedText = await textRecogniser.processImage(inputImage);
      final vin = extractVinFromText(recognisedText.text);

      if (vin != null) {
        Navigator.pop(context, vin);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text('Aucun VIN valide trouvé. Veuillez réessayer.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Erreur lors de la prise de la photo: $e');
    }
  }

  String? extractVinFromText(String text) {
    final RegExp vinRegex = RegExp(r"^[A-HJ-NPR-Z0-9]{17}$");
    Iterable<Match> matches = vinRegex.allMatches(text);
    return matches.isNotEmpty ? matches.first.group(0) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          cameraController != null && cameraController!.value.isInitialized
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white
                            .withOpacity(0.5), // Couleur claire pour l'ombre
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CameraPreview(cameraController!),
                )
              : CircularProgressIndicator(),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Container(),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                        0.5), // Couleur foncée pour la partie non ombrée
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            child: ElevatedButton(
              onPressed: () => takePictureAndScanVin(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20.0),
                shape: CircleBorder(),
              ),
              child: Icon(
                Icons.camera_alt,
                size: 40.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    textRecogniser.close();
    super.dispose();
  }
}
