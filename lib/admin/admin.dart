import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('activate'),
              onPressed: () {},
            ),
            ElevatedButton(
                child: Text('logout'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  await Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Main_Page()));
                }),
          ],
        ),
      ),
    );
  }
}
