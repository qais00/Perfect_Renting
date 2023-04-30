
// import 'dart:js';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'login_complete.dart';

// signUpUser(
//   String userName,
//   String userEmail,
//   String userPassword,
//   String userRepassword,
// ) async {
//   User? userid = FirebaseAuth.instance.currentUser;
//   try {
//     await FirebaseFirestore.instance.collection('users').doc(userid!.uid).set({
//       'username': userName,
//       'useremail': userEmail,
//       'userpassword': userPassword,
//       'createdAt': DateTime.now(),
//       'userId': userid.uid,
//     }).then((value) => {
//           logincomplete2(context),
//         });
//   } on FirebaseAuthException catch (e) {
//     print('Error $e');
//   }
// }

// logincomplete2(context) {
//   Navigator.of(context).push(MaterialPageRoute(
//     builder: (_) {
//       return LoginComplete();
//     },
//   ));
// }
