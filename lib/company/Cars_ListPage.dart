import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import './cars_List.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CarsListPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  Future<String> _getImageUrl(String model) async {
    final ref =
        FirebaseStorage.instance.ref().child('Cars/${user.email}/$model.png');
    return await ref.getDownloadURL();
  }

  Widget buildCarTile(BuildContext context, DocumentSnapshot car) {
    final model = car['Model'];
    final brand = car['Brand'];
    final year = car['Year'];
    final price = car['Price'];

    return FutureBuilder<String>(
      future: _getImageUrl(model),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return ListTile(
              title: Text('Error loading car image'),
              subtitle: Text('$brand $model ($year)\n\$$price per day'),
            );
          }
          final imageUrl = snapshot.data!;
          return ListTile(
            leading: Image.network(imageUrl, width: 100, fit: BoxFit.cover),
            title: Text('$brand $model ($year)'),
            subtitle: Text('\$$price per day'),
          );
        } else {
          return ListTile(
            title: Text('Loading...'),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cars'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Cars')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("Cars")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              // Map car = document.data() as Map;
              return buildCarTile(context, document);
            }).toList(),
          );
        },
      ),
    );
  }
}
