import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

class Car {
  final String rentalCompany;
  final String model;
  final String image;
  final double price;
  final double gasConsumption;
  final double rating;

  Car({
    required this.rentalCompany,
    required this.model,
    required this.image,
    required this.price,
    required this.gasConsumption,
    required this.rating,
  });
}



class CustomerHomePage extends StatelessWidget {
  @override
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
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.uid).collection("cars").get(),
          builder: (context, snapshot) 
          {
            if(!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);

            print(snapshot.data!.docs);
          return SizedBox.shrink();

          // return ListView.builder(
          //   itemCount: cars.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return Card(
          //       margin: EdgeInsets.all(10.0),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Container(
          //             margin: EdgeInsets.all(10.0),
          //             child: Image.network(
          //               'https://cs.copart.com/v1/AUTH_svc.pdoc00001/PIX117/a3c31a22-60bd-4f92-bc5b-4b67bd36cdaa.JPG',
          //               semanticLabel: cars[index].image,
          //               height: 100,
          //               width: 120,
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   cars[index].rentalCompany,
          //                   style: TextStyle(
          //                     fontSize: 18.0,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 SizedBox(height: 5.0),
          //                 Text(
          //                   cars[index].model,
          //                   style: TextStyle(
          //                     fontSize: 16.0,
          //                   ),
          //                 ),
          //                 SizedBox(height: 5),
          //                 SizedBox(height: 5.0),
          //                 Text(
          //                   'Price: \$${cars[index].price.toString()} per day',
          //                   style: TextStyle(
          //                     fontSize: 16.0,
          //                   ),
          //                 ),
          //                 SizedBox(height: 5.0),
          //                 Text(
          //                   'Gas Consumption: ${cars[index].gasConsumption.toString()}L/100km',
          //                   style: TextStyle(
          //                     fontSize: 16.0,
          //                   ),
          //                 ),
          //                 SizedBox(height: 5.0),
          //                 Row(
          //                   children: [
          //                     Icon(
          //                       Icons.star,
          //                       color: Colors.amber,
          //                       size: 16.0,
          //                     ),
          //                     Text(
          //                       cars[index].rating.toString(),
          //                       style: TextStyle(
          //                         fontSize: 16.0,
          //                       ),
          //                     ),
          //                     Row(
          //                       mainAxisAlignment: MainAxisAlignment.end,
          //                       children: [
          //                         IconButton(
          //                           icon: Icon(Icons.book_online),
          //                           onPressed: () {
          //                             print('booked');
          //                           },
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //                 SizedBox(height: 10.0),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // );
          }
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.directions_car),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
