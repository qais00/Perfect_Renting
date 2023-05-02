import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Car {
  final String Model;
  final String Price;
  final String Brand;
  final String companyEmail;
  Car({
    required this.Model,
    required this.Price,
    required this.Brand,
    required this.companyEmail,
  });
}

class CustomerHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://img.myloview.com/posters/distressed-black-texture-dark-grainy-texture-on-white-background-dust-overlay-textured-grain-noise-particles-rusted-white-effect-grunge-design-elements-vector-illustration-eps-10-700-253300231.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              title: Text('Perfect Renting'),
              backgroundColor: Colors.purple,
            ),
            drawer: Drawer(
                child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Perfect Renting',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Profile'),
                            content: Column(
                              children: <Widget>[
                                Text('name:'),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('cancel'))
                            ],
                          );
                        });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text('My Bookings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Main_Page()));
                  },
                ),
              ],
            )),
            body: StreamBuilder<List<Car>>(
                stream: getCars(),
                builder: (context, snapshot) {
                  print('snapshot data length: ${snapshot.data?.length}');
                  print('test4');
                  if (!snapshot.hasData) {
                    print('test5');
                    return Center(child: CircularProgressIndicator());
                  }

                  final cars = snapshot.data!;
                  return ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (BuildContext context, int index) {
                      print('test1');
                      final car = cars[index];
                      return Card(
                        margin: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.all(10.0),
                                child: FutureBuilder<String>(
                                  future: FirebaseStorage.instance
                                      .ref(
                                          'Cars/${car.companyEmail}/${car.Model}.png')
                                      .getDownloadURL(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.data != null) {
                                      print('test2');
                                      return Image.network(
                                        snapshot.data!,
                                        semanticLabel:
                                            car.Brand + ' ' + car.Model,
                                        height: 100,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      );
                                    } else if (snapshot.hasError) {
                                      return Image.asset(
                                        'assets\images\Car_icon_alone.png',
                                        height: 100,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    car.Brand,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    car.Model,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'Price: \$${car.Price} per day',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.book_online),
                                        onPressed: () {
                                          print('booked');
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                })));
  }
}

Stream<List<Car>> getCars() async* {
  final carsCollection = FirebaseFirestore.instance.collection('Cars');
  final snapshot = await carsCollection.get();

  for (final doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final companyEmail = doc.id;

    final carsData =
        await carsCollection.doc(companyEmail).collection('Cars').get();

    if (carsData != null) {
      final carsList = carsData.docs.map((car) => car.data()).toList();
      final cars = carsList
          .map((carData) => Car(
                Model: carData['Model'] ?? '',
                Price: carData['Price'].toString(),
                Brand: carData['Brand'] ?? '',
                companyEmail: companyEmail,
              ))
          .toList();
      yield cars;
    }
  }
}
