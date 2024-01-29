// lib/Models/car.dart

class Car {
  final String vin;
  final String model;
   final List<dynamic>? carActions; // Liste des carActions, nullable
  final List<dynamic>? actionPerforms; // Liste des actionPerforms, nullable

  Car({ required this.vin, required this.model , this.carActions,
    this.actionPerforms,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      vin: json['car']['car']['vin'] as String,
      model: json['car']['car']['model'] as String,
      carActions: json['car']['car']['carActions'],
      actionPerforms: json['car']['actionPerforms'],
    );
  }

}
