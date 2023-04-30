import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import './cars_List.dart';

class CompanyHomePage2 extends StatefulWidget {
  const CompanyHomePage2({super.key});

  @override
  State<CompanyHomePage2> createState() => _CompanyHomePageState2();
}

class _CompanyHomePageState2 extends State<CompanyHomePage2> {
  List<String> bookings = [];
  List<CarsList> cars = [
    CarsList(
        carName: 'Huyndai',
        carModel: 'accent',
        fuelConsumption: '12K/L',
        carImage: 'accent_image'),
    CarsList(
        carName: 'Nissan',
        carModel: 'Sunny',
        fuelConsumption: '12K/L',
        carImage: 'Nissan_image'),
    CarsList(
        carName: 'Huyndai',
        carModel: 'accent',
        fuelConsumption: '12K/L',
        carImage: 'accent_image'),
    CarsList(
        carName: 'BMW',
        carModel: 'm520',
        fuelConsumption: '6K/L',
        carImage: 'BM_image'),
  ];
  void addBooking() {
    setState(() {
      bookings.add('New Car added');
    });
  }

  // void startAddNewCar(BuildContext context) {
  //   showModalBottomSheet(context: context, builder: (_) {
  //     return ;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 32, 148, 129),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 116, 39, 93),
        title: Text(
          'Perfect Renting',
          style: TextStyle(
            color: Color.fromARGB(96, 255, 255, 255),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 5.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.drive_eta,
                      size: 72.0, color: Color.fromARGB(255, 116, 39, 93)),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color.fromARGB(255, 116, 39, 93)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: bookings.isEmpty
                          ? Text('No cars yet')
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
        onPressed: () {},
        label: Text(
          'List Your Car',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 116, 39, 93),
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
              color: Color.fromARGB(255, 116, 39, 93),
            ),
            child: Text(
              'Perfect Renting',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem('View Listed Cars', Icons.directions_car, () {}),
          _buildDrawerItem('Support', Icons.help_outline, () {}),
          _buildDrawerItem('Profile', Icons.person_outline, () {}),
          _buildDrawerItem('App Settings', Icons.settings_outlined, () {}),
          _buildDrawerItem('Logout', Icons.logout_rounded, () async {
            FirebaseAuth.instance.signOut();
            User? user;
            try
            {
              user!.delete();
            }
            catch (e)
            {

            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Main_Page()),
            );
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
}
