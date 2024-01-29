// lib/ViewModel/car_service.dart

import 'package:http/http.dart' as http;
import 'package:netcars/Models/action.dart';
import 'dart:convert';
import 'package:netcars/Models/car.dart';
import 'package:netcars/Models/car2.dart';
import 'package:netcars/Models/carResponse.dart';

class CarService {
  final String baseUrl =
      "http://13.39.243.121:8033/netCarsDelivery/carToDeliver";
  final int siteId = 1;

  Future<Car?> fetchCarDetails(String vin, String token) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    final response = await http.get(
      Uri.parse("$baseUrl/$vin?siteId=$siteId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print(Car.fromJson(json.decode(response.body)));
      return Car.fromJson(json.decode(response.body));
    } else {
      print('Erreur lors de la récupération des détails de la voiture');
      return null;
    }
  }



  Future<bool> updateCarStatus(String vin, int actionId, String token) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    final url = Uri.parse(
            "http://13.39.243.121:8033/netCarsDelivery/carAction")
        .replace(queryParameters: {
      'idAction': actionId.toString(),
      'idSite': siteId.toString(),
      'vin': vin,
    });

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      print('Erreur lors de la mise à jour du statut de la voiture');
      return false;
    }
  }


Future<List<Car2>?> fetchCarsByVinSuffix(
      String vinSuffix, String token) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/endsWith/$vinSuffix?siteId=$siteId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Check if the key "car" exists in the response JSON
      if (jsonResponse.containsKey('car')) {
        // Check if "car" is a list
        if (jsonResponse['car'] is List<dynamic>) {
          // Use the Car2 class to map the JSON response
          List<Car2> cars = List<Car2>.from(
            jsonResponse['car'].map((carJson) => Car2.fromJson(carJson)),
          );

          print(cars);
          return cars;
        } else {
          print('La clé "car" existe, mais ce n\'est pas une liste');
          return null;
        }
      } else {
        print('La clé "car" est absente de la réponse JSON');
        return null;
      }
    } else {
      print(response.statusCode);
      print('Erreur lors de la récupération des voitures par suffixe de VIN');
      return null;
    }
  }







}
