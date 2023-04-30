// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perfect_renting/admin/admin.dart';
import 'package:perfect_renting/customer/customer_homepage.dart';
import 'package:perfect_renting/notification_service.dart';
import 'package:perfect_renting/register_form.dart';
import 'ErrorMessageAlertWidget.dart';
import 'password_reset.dart';
import 'company/company_homepage2.dart';
import './new_Registration_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'company/company_homepage2.dart';
import 'firebase_options.dart';
import './notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  Notificationservice().initAwesomnotification();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(PerfectRenting());
}

TextEditingController loginemailcontroller = TextEditingController();
TextEditingController loginpwcontroller = TextEditingController();

class PerfectRenting extends StatelessWidget {
  User? user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primarySwatch: Colors.purple,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color.fromARGB(255, 8, 187, 163),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
          ),
        ),
      ),
      title: 'Perfect Renting',
      home: Main_Page(),
    );
  }
}

class Main_Page extends StatefulWidget {
  @override
  State<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {
  User? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String role = "";
  late bool validation;

  Future<bool> getvalidation() async {
    String id = FirebaseAuth.instance.currentUser!.uid.toString();
    print('User **ID: $id');

    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("User").doc(id).get();
    Map userData = doc.data() as Map;
    return userData['disabled'];
  }

  Future getUserRole() async {
    String id = FirebaseAuth.instance.currentUser!.uid.toString();
    print('User **ID: $id');

    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("User").doc(id).get();

    if (doc.exists) {
      final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      print('User ID: $id');

      if (data != null && data.containsKey('role') && data['role'] != null) {
        String role = doc.get('role');
        print('Role: $role');
        return role;
      } else {
        print('Role field not present or has a null value');
        return '';
      }
    } else {
      print('Document does not exist');
      return '';
    }
  }
  // Future<String> getUserRole() async {
  //   final User? user = _auth.currentUser;
  //   String role = "";
  //   if (user != null) {
  //     final String uid = user.uid;
  //     try {
  //       final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //           await FirebaseFirestore.instance
  //               .collection('users')
  //               .doc(uid)
  //               .get();
  //       if (snapshot.exists) {
  //         print('checking function print statement');
  //         role = snapshot.data()!['role'];
  //       }
  //     } catch (e) {
  //       print('error retrievinf user role : $e');
  //     }
  //   }

  //   return role;
  // }

  Future<void> signIn() async {
    var loginemail = loginemailcontroller.text.trim();
    var loginpw = loginpwcontroller.text.trim();

    try {
      final User? firebaseuser = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: loginemail, password: loginpw))
          .user;

      if (firebaseuser != null) {
        if (await getvalidation()) {
          ErrorMessageAlertWidget().show(
              context: context,
              text: "Your account is still under admin's review");
        } else {
          role = await getUserRole();
          if (role == 'Customer') {
            loginCustomer(context);
            print('Logged in Succefull');
          } else if (role == 'Company') {
            loginCompany(context);
            print('Logged in Succefull');
          } else if (role == 'Admin') {
            loginAdmin(context);
            print('Logged in Succefull');
          }
        }
      } else {
        print("Check Email & Password and verification");
      }
    } on FirebaseAuthException catch (e) {
      ErrorMessageAlertWidget()
          .show(context: context, text: (e.message.toString()));
    }
  }
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> signIn() async {
  //     var loginemail = loginemailcontroller.text.trim();
  //   var loginpw = loginpwcontroller.text.trim();
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: loginemail,
  //       password: loginpw,
  //     );
  //     String userId = user?.user.uid;

  //     // Retrieve the user's role from Firestore
  //     DocumentSnapshot snapshot =
  //         await _firestore.collection('users').doc(userId).get();
  //     String role = snapshot.get('role');

  //     // Navigate to the appropriate page based on the user's role
  //     if(role != null ){
  //     if (role == 'Customer') {
  //       loginCustomer(context);
  //     } else if (role == 'Company') {
  //       loginCompany(context);
  //     } else {
  //       // Handle unknown role
  //     }
  //     }
  //     else print('no role data');
  //   } on FirebaseAuthException catch (e) {
  //     // Handle login errors
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     } else {
  //       print('Error logging in: $e');
  //     }
  //   }
  // }

  @override
  void initState() {
    getUserRole();
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  void loginCustomer(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CustomerHomePage()),
    );
  }

  void loginAdmin(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Admin()),
    );
  }

  void loginCompany(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CompanyHomePage2()),
    );
  }

  bool obscureText = false;
  void registerform(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) {
        return NewRegScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: Text(
                'Perfect Renting',
                style: TextStyle(
                  color: Color.fromARGB(96, 255, 255, 255),
                ),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: Container(
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/Car_icon_alone.png'),
                      SizedBox(
                        height: 70,
                      ),
                      TextField(
                          controller: loginemailcontroller,
                          obscureText: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            fillColor: Colors.transparent,
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.name),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                          controller: loginpwcontroller,
                          obscureText: obscureText,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(
                                  Icons.visibility,
                                )),
                            fillColor: Colors.transparent,
                            labelText: 'Password',
                          ),
                          keyboardType: TextInputType.name),
                      SizedBox(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PasswordReset(),
                                ),
                              );
                            },
                            child: Text('Forgot Password?'),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: signIn,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            fixedSize: const Size(200, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color.fromARGB(96, 255, 255, 255),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () => registerform(context),
                          child: Text('Still dont have an account!?')),
                    ],
                  ),
                ),
              ),
            ),
          )
        : CustomerHomePage();
  }
}
