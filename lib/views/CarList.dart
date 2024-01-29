import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:netcars/Models/car.dart';
import 'package:netcars/Models/car2.dart';
import 'package:netcars/ViewModel/carViewModels.dart';
import 'package:netcars/views/ConfirmationOCR.dart';


final storage = FlutterSecureStorage();

Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}


class CarList extends StatefulWidget {
  final List<Car2> carList;

  const CarList({Key? key, required this.carList}) : super(key: key);

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
    String? _token;

  final CarService _carService =CarService(); // Instanciez la classe CarService



@override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await getToken();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des voitures'),
      ),
      body: ListView.builder(
        itemCount: widget.carList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('VIN: ${widget.carList[index].vin}'),
            subtitle: Text('Modèle: ${widget.carList[index].model}'),
            onTap: () {
              // Gérez le clic sur la cellule
              _handleCellClick(widget.carList[index]);
            },
          );
        },
      ),
    );
  }

  Future<void> _handleCellClick(Car2 selectedCar) async {
    // Utilisez la méthode fetchCarDetails pour récupérer les détails de la voiture
    final Car? carDetails = await _carService.fetchCarDetails(selectedCar.vin, _token!);

    // Vérifiez si les détails de la voiture ne sont pas nuls
    if (carDetails != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationOCRPage(
            vin: selectedCar.vin,
            model: selectedCar.model,
            carActions: selectedCar.carActions,
            actionPerforms: selectedCar.actionPerforms
                ?.map((item) => item as Map<String, dynamic>)
                .toList(),
          ),
        ),
      );
      print('Détails de la voiture: $carDetails');
    } else {
      // Affichez un message d'erreur si les détails de la voiture sont nuls
      print('Aucun détail de voiture trouvé pour le VIN: $selectedCar.vin');
    }
  }
}
