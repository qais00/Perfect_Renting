import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:perfect_renting/ErrorMessageAlertWidget.dart';
import 'package:perfect_renting/main.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController forgetpasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Perfect Renting',
          style: TextStyle(
            color: Color.fromARGB(96, 255, 255, 255),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Main_Page()),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 32, 148, 129),
      body: Container(
        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://img.myloview.com/posters/distressed-black-texture-dark-grainy-texture-on-white-background-dust-overlay-textured-grain-noise-particles-rusted-white-effect-grunge-design-elements-vector-illustration-eps-10-700-253300231.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment(0.0, -.9),
                opacity: 10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                    controller: forgetpasswordcontroller,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                      enabledBorder: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress),
                    SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () async {
                    var forgotemail = forgetpasswordcontroller.text.trim();
                    if (forgotemail.isEmpty) {
                     ErrorMessageAlertWidget().show(context: context, text: "Please Enter A valid email address");
                      return;
                    }
                    try {
                      // Send the password reset email
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: forgotemail);
                       ErrorMessageAlertWidget().show(context: context, text: "Email Sent!");
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Main_Page()),
                      );
                    } on FirebaseAuthException catch (e) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text(e.message.toString()))
                      // );
                      ErrorMessageAlertWidget().show(context: context, text: e.message.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: const Text(
                    'Reset PAssword',
                    style: TextStyle(
                      color: Color.fromARGB(96, 255, 255, 255),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
