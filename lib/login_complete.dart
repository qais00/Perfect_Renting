import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:perfect_renting/main.dart';

class LoginComplete extends StatefulWidget {
  LoginComplete();

  @override
  State<LoginComplete> createState() => _LoginCompleteState();
}

class _LoginCompleteState extends State<LoginComplete> {
   String username = loginemailcontroller.text;
 void logout(context) {
    Navigator.of(context).pop();
      
    
  }
  
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      // drawer: DropdownButtonHideUnderline(child: Text('lol')),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 32, 148, 129),
      appBar: AppBar(
        actions: [
          GestureDetector(child: Icon(Icons.logout),onTap: () {
            FirebaseAuth.instance.signOut();
            logout(context);
             },)
        ],
        backgroundColor: Color.fromARGB(255, 116, 39, 93),
        title: Text(
          'Perfect Renting',
          style: TextStyle(
            color: Color.fromARGB(96, 255, 255, 255),
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Welcome again $username',
              style: TextStyle(
                  color: Color.fromARGB(255, 116, 39, 93),
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          ElevatedButton(
            onPressed: () {
               FirebaseAuth.instance.signOut();
            logout(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 116, 39, 93),
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Color.fromARGB(96, 255, 255, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
