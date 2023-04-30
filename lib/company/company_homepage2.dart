import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import './cars_List.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import './Cars_ListPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

File? _selectedImage;

class CompanyHomePage2 extends StatefulWidget {
  const CompanyHomePage2({super.key});

  @override
  State<CompanyHomePage2> createState() => _CompanyHomePageState2();
}

class _CompanyHomePageState2 extends State<CompanyHomePage2> {
  List<String> bookings = [];
  void addBooking() {
    setState(() {
      bookings.add('New booking');
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Perfect Renting', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.drive_eta, size: 72.0, color: Colors.deepPurple),
                  SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Expanded(
                      child: bookings.isEmpty
                          ? Text('No bookings yet')
                          : ListView.builder(
                              itemCount: bookings.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(bookings[index]),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showListYourCarDialog,
        label: Text(
          'Add a Car',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Perfect Renting',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem('View Listed Cars', Icons.directions_car, () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CarsListPage(),
            ));
          }),
          _buildDrawerItem('Support', Icons.help_outline, () {}),
          _buildDrawerItem('Profile', Icons.person_outline, () {}),
          _buildDrawerItem('App Settings', Icons.settings_outlined, () {}),
          _buildDrawerItem('Logout', Icons.logout_outlined, () async {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  await Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Main_Page()
            ));
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData iconData, VoidCallback onTap) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> _showListYourCarDialog() async {
    final _modelController = TextEditingController();
    final _brandController = TextEditingController();
    final _yearController = TextEditingController();
    final _priceController = TextEditingController();


    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Add a Car'),
            content: SingleChildScrollView(
              child: AddCarDialog(
                brandController: _brandController,
                priceController: _priceController,
                yearController: _yearController,
                modelController: _modelController,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final model = _modelController.text;
                  final brand = _brandController.text;
                  final year = _yearController.text;
                  final price = _priceController.text;
                  final imageBytes = _selectedImage?.readAsBytesSync();

                  if (model.isNotEmpty &&
                      brand.isNotEmpty &&
                      year.isNotEmpty &&
                      price.isNotEmpty) {
                    final data = {
                      'Model': model,
                      'Brand': brand,
                      'Year': year,
                      'Price': price,
                      'Available': 'True',
                    };

                    final storageRef = FirebaseStorage.instance.ref();
                    Reference? imagesRef = storageRef
                        .child(FirebaseAuth.instance.currentUser!.uid)
                        .child('Car Images')
                        .child('$model.png');
                    imagesRef.putFile(_selectedImage!);
                    try {
                      await FirebaseFirestore.instance
                          .collection('/Cars')
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .collection("Cars")
                          .add(data);
                          
                    } catch (e) {
                      print(e);
                    }
                  }
                  setState(() {
                     _selectedImage = null;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
            ],
          );
        });
  }
}


class AddCarDialog extends StatefulWidget
{
  final TextEditingController modelController;
  final TextEditingController brandController;
  final TextEditingController yearController;
  final TextEditingController priceController;
  const AddCarDialog({
    super.key,
    required this.modelController,
    required this.brandController,
    required this.yearController,
    required this.priceController,
  });

  @override
  State<AddCarDialog> createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: widget.modelController,
                  decoration: InputDecoration(
                    hintText: 'Model',
                  ),
                ),
                TextField(
                  controller: widget.brandController,
                  decoration: InputDecoration(
                    hintText: 'Brand',
                  ),
                ),
                TextField(
                  controller: widget.yearController,
                  decoration: InputDecoration(
                    hintText: 'Year',
                  ),
                ),
                TextField(
                  controller: widget.priceController,
                  decoration: InputDecoration(
                    hintText: 'Price per day',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () async {
                     final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.camera);

                    setState(() {
                      if (pickedFile != null) {
                        _selectedImage = File(pickedFile.path);
                      } else {
                        print('No image selected.');
                      }
                    });
                  },
                  icon: Icon(Icons.image),
                  label: Text('Upload Picture'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                ),
                if (_selectedImage != null)
                  Flexible(
                    child: Image.file(
                      _selectedImage!,
                      height: 150,
                      width: 150,
                    ),
                  ),
              ],
            );
  }
}