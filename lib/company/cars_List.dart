import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  String Brand;
  String Model;
  int Price;
  int Year;

  Car({
    required this.Model,
    required this.Year,
    required this.Price,
    required this.Brand,
  });
  factory Car.fromSnapshot(QueryDocumentSnapshot<Object?> snapshot) {
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    final String id = snapshot.id;
    return Car(
        Price: data['Price'],
        Brand: data['Brand'],
        Model: data['Model'],
        Year: data['Year']);
  }
}
