import 'package:netcars/Models/car2.dart'; // Importez le nouveau modèle Car2

class CarResponse {
  final List<Car2> cars; // Utilisez maintenant la liste d'objets Car2

  CarResponse({required this.cars});

  factory CarResponse.fromJson(dynamic json) {
    if (json is List) {
      // Si le JSON est une liste, mappage direct vers la liste d'objets Car2
      List<Car2> carList =
          json.map((carJson) => Car2.fromJson(carJson)).toList();
      return CarResponse(cars: carList);
    } else if (json is Map<String, dynamic>) {
      // Si le JSON est une carte, extrayez la liste et effectuez le mappage
      List<Car2> carList = (json['car'] as List<dynamic>)
          .map((carJson) => Car2.fromJson(carJson))
          .toList();
      return CarResponse(cars: carList);
    } else {
      // Gérer d'autres cas si nécessaire
      throw Exception("Format JSON non pris en charge");
    }
  }
}
