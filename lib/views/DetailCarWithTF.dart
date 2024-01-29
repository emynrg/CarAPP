import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:netcars/Models/car.dart';
import 'package:netcars/ViewModel/carViewModels.dart';
import 'package:netcars/constantes/colors.dart';
import 'package:netcars/Models/action.dart';

final storage = FlutterSecureStorage();
final vinController = TextEditingController();

Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}

class DetailCarWithTF extends StatefulWidget {
  final String? vin;
  final String? model;
  final List<dynamic>? carActions;
  final List<Map<String, dynamic>>? actionPerforms;

  const DetailCarWithTF(
      {super.key, this.vin, this.model, this.carActions, this.actionPerforms});

  @override
  State<DetailCarWithTF> createState() => _DetailCarWithTFState();
}

class _DetailCarWithTFState extends State<DetailCarWithTF> {
  final CarService _carService = CarService();
  String? _token;

  @override
  void initState() {
    super.initState();
    vinController.text = widget.vin ?? "";

    _loadToken();
  }

  Future<void> _loadToken() async {
    String? token = await getToken();
    setState(() {
      _token = token;
    });
  }

  String _getImagePath() {
    if (widget.model == "Model S") {
      return "assets/images/teslamodelS.png";
    } else if (widget.model == "Model 3") {
      return "assets/images/teslamodel3.png";
    } else if (widget.model == "Model Y") {
      return "assets/images/teslamodely.png";
    } else if (widget.model == "Model X") {
      return "assets/images/teslamodelX.png";
    } else {
      return "assets/images/imagetest.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' Model TESLA',
                style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  fontSize: 20.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width / 23,
          ),
          
          
          Image(
            image: AssetImage(_getImagePath()),
            width: MediaQuery.of(context).size.height / 2,
          ),
           SizedBox(
            height: MediaQuery.of(context).size.height / 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Code Vin',
                style: TextStyle(
                  fontFamily: 'PoppinsSemiBold',
                  fontSize: 20.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(

            children: [
               SizedBox(
                width: MediaQuery.of(context).size.width / 16,
              ),
              Container(
                 height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 1.5,
                child: TextField(
                  controller: vinController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFD3D3D3),
                    hintText: 'WZ0WW32PLKJXT1',
                    hintStyle: TextStyle(
                      fontFamily: 'PoppinsSemiBold',
                      fontSize: 15.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(90.0)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style:
                      TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 15.sp),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 16,
              ),
              InkWell(
                onTap: () async {
                  // Récupérer le code VIN du champ de texte
                  String vin = vinController.text;
                  final Car? carDetails =
                      await _carService.fetchCarDetails(vin, _token!);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailCarWithTF(
                        vin: carDetails!.vin,
                        model: carDetails.model,
                        carActions: carDetails.carActions,
                        actionPerforms: carDetails.actionPerforms
                            ?.map((item) => item as Map<String, dynamic>)
                            .toList(),
                      ),
                    ),
                  );
                },
                child: Image(
                  image: AssetImage("assets/images/refresh.png"),
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.height / 14,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 14,
          ),
          if (widget.actionPerforms != null &&
              widget.actionPerforms!.isNotEmpty)
            Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                ),
                itemCount: widget.actionPerforms!.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isDone = widget.actionPerforms![index]['done'] ?? false;

                  return Opacity(
                    opacity: isDone
                        ? 0.5
                        : 1.0, // si done est vrai, l'opacité est de 0.5, sinon elle est de 1.0
                    child: GestureDetector(
                      onTap: isDone
                          ? null // si done est vrai, onTap est null (désactivé)
                          : () async {
                              int actionId =
                                  widget.actionPerforms![index]['id'];
                              bool isSuccess =
                                  await _carService.updateCarStatus(
                                      widget.vin!, actionId, _token!);

                              if (isSuccess) {
                                setState(() {
                                  widget.actionPerforms![index]['done'] =
                                      true; // mise à jour de l'état done
                                });
                              }

                              // Votre code d'action ici
                            },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 10.0)
                            .h,
                        decoration: BoxDecoration(
                          color: mainGray,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: borderRed,
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.actionPerforms![index]['action'] ?? 'N/A',
                            style: TextStyle(
                              fontFamily: 'PoppinsSemiBold',
                              color: Colors.black,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
        ],
      ),
    );
  }
}
