// lib/Models/car.dart

class Car2 {
  final String vin;
  final String model;
  final List<dynamic>? carActions; // Liste des carActions, nullable
  final List<dynamic>? actionPerforms; // Liste des actionPerforms, nullable

  Car2({
    required this.vin,
    required this.model,
    this.carActions,
    this.actionPerforms,
  });

  factory Car2.fromJson(Map<String, dynamic> json) {
  
    return Car2(
      vin: json['car']['vin'] as String,
      model: json['car']['model'] as String,
      carActions: json['car']['carActions'],
      actionPerforms: json['actionPerforms'],
    );
  }
}
