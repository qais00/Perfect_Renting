// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:perfect_renting/customer/customer_homepage.dart';
// import 'package:perfect_renting/notification_service.dart';
// import 'package:perfect_renting/register_form.dart';
// import '../main.dart';
// import '../new_Registration_Screen.dart';
// import '../ErrorMessageAlertWidget.dart';
// import '../password_reset.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import '../firebase_options.dart';
// import '../notification_service.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';

// class CustomerLoginPage extends StatefulWidget {
//   CustomerLoginPage({super.key});

//   @override
//   State<CustomerLoginPage> createState() => _CustomerLoginPageState();
// }

// class _CustomerLoginPageState extends State<CustomerLoginPage> {
//   TextEditingController loginemailcontroller = TextEditingController();

//   TextEditingController loginpwcontroller = TextEditingController();

//   User? user;

//   Future signIn() async {
//     var loginemail = loginemailcontroller.text.trim();
//     var loginpw = loginpwcontroller.text.trim();

//     try {
//       final User? firebaseuser = (await FirebaseAuth.instance
//               .signInWithEmailAndPassword(email: loginemail, password: loginpw))
//           .user;

//       if (firebaseuser != null) {
//         loginCustomer(context);
//         print('Logged in Succefull');
//       } else {
//         print("Check Email & Password and verification");
//       }
//     } on FirebaseAuthException catch (e) {
//       ErrorMessageAlertWidget()
//           .show(context: context, text: (e.message.toString()));
//     }
//   }

//   // final FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//   }

//   void loginCustomer(context) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => CustomerHomePage()),
//     );
//   }

//   bool obscureText = false;

//   void registerform(BuildContext context) {
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (_) {
//         return NewRegScreen();
//       },
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           'Perfect Renting',
//           style: TextStyle(
//             color: Color.fromARGB(96, 255, 255, 255),
//           ),
//         ),
//          leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => {
//             // Navigate to the second screen and replace the current screen in the stack
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => Main_Page(),
//               ),
//             )
//           },
//         ),
//       ),
//       resizeToAvoidBottomInset: false,
//       body: GestureDetector(
//         onTap: FocusScope.of(context).unfocus,
//         child: Container(
//           margin: EdgeInsets.all(0.0),
//           padding: EdgeInsets.all(2.0),
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: NetworkImage(
//                       'https://img.myloview.com/posters/distressed-black-texture-dark-grainy-texture-on-white-background-dust-overlay-textured-grain-noise-particles-rusted-white-effect-grunge-design-elements-vector-illustration-eps-10-700-253300231.jpg'),
//                   fit: BoxFit.cover,
//                   alignment: Alignment(0.0, -.9),
//                   opacity: 10)),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Image.asset('assets/images/user.png'),
//                 SizedBox(
//                   height: 70,
//                 ),
//                 TextField(
//                     controller: loginemailcontroller,
//                     obscureText: false,
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.email),
//                       fillColor: Colors.transparent,
//                       labelText: 'Email',
//                     ),
//                     keyboardType: TextInputType.name),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 TextField(
//                     controller: loginpwcontroller,
//                     obscureText: obscureText,
//                     obscuringCharacter: '*',
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.password),
//                       suffixIcon: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               obscureText = !obscureText;
//                             });
//                           },
//                           child: Icon(
//                             Icons.visibility,
//                           )),
//                       fillColor: Colors.transparent,
//                       labelText: 'Password',
//                     ),
//                     keyboardType: TextInputType.name),
//                 SizedBox(
//                   height: 1,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PasswordReset(),
//                           ),
//                         );
//                       },
//                       child: Text('Forgot Password?'),
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                   onPressed: signIn,
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.purple,
//                       fixedSize: const Size(200, 50),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50))),
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(
//                       color: Color.fromARGB(96, 255, 255, 255),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
