import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:perfect_renting/ErrorMessageAlertWidget.dart';
import './reg_complete.dart';
import 'package:email_validator/email_validator.dart';
import 'package:email_auth/email_auth.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import './notification_service.dart';

class NewRegScreen extends StatefulWidget {
  const NewRegScreen({super.key});

  @override
  State<NewRegScreen> createState() => _NewRegScreenState();
}

enum Customertype { jordanian, non_jordanian, company }

const List<String> gender = ['Male', 'Female'];

class _NewRegScreenState extends State<NewRegScreen> {
  String imageUrl = '';
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  final _formkey = GlobalKey<FormState>();
  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';
  String _userRepassowrd = '';
  String _userGender = '';
  String _userNationality = '';
  TextEditingController _usercon = TextEditingController();
  TextEditingController _emailcon = TextEditingController();
  TextEditingController _mobilenumber = TextEditingController();
  TextEditingController _userpasswordcon = TextEditingController();
  TextEditingController _repasswordcon = TextEditingController();
  String mygender = gender.first;
  bool drivingL = false;
  bool nationalID = false;
  bool passport = false;
  bool commercialrecord = false;
  bool obscureText = true;
  bool obscureText2 = true;
  Map<String, XFile?> images = {};
  bool isLoading = false;

  User? currentUSer = FirebaseAuth.instance.currentUser;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  // Future<void> sendverification() async {
  //   if (currentUSer != null) {
  //     try {
  //       await currentUSer!.sendEmailVerification();
  //       print('email sent!');
  //     } catch (e) {
  //       print('error');
  //     }
  //   } else {
  //     print('no user');
  //   }
  // }

  Future<void> sendgmail() async {
    try {
      var sendingemail = 'oma20160581@std.psut.edu.jo';
      var userEmail = 'ramahizahi@gmail.com';
      var password = 'fexvmjixomybbgci';
      var message = Message();
      message.subject = "Subject From Flutter";
      message.text =
          'Hi Admins, ${_usercon.text} has registered on your application , please check his uploded form!';
      message.from = Address(sendingemail.toString());
      message.recipients.add(userEmail);

      var smtpServer = gmail(userEmail, password);
      await send(message, smtpServer);
      // ErrorMessageAlertWidget().show(
      //     context: context,
      //     text:
      //         'Your Registration has been recived , please wait for an email reply');
    } catch (e) {
      print('${e.toString()}');
    }
  }

  Future signUP(BuildContext context) async {
    if (!_formkey.currentState!.validate()) return;

    if (_customertype == Customertype.jordanian) {
      if (drivingL && nationalID) {
      } else {
        ErrorMessageAlertWidget()
            .show(context: context, text: "Please Upload the Images");
        return;
      }
    } else if (_customertype == Customertype.non_jordanian) if (drivingL &&
        passport) {
    } else {
      ErrorMessageAlertWidget()
          .show(context: context, text: "Please Upload the Images");
      return;
    }
    else if (_customertype == Customertype.company) {
      if (commercialrecord) {
      } else {
        ErrorMessageAlertWidget()
            .show(context: context, text: "Please Upload the Images");
        return;
      }
    }

    var userName = _usercon.text.trim();
    var userEmail = _emailcon.text.trim();
    var userPassword = _userpasswordcon.text.trim();
    var userRepassword = _repasswordcon.text.trim();
    var mobilenumber = _mobilenumber.text.trim();

    print(userName);
    print(userEmail);
    print(userPassword);
    print(userRepassword);
    print(mobilenumber);
    print(images);

    setState(() {
      isLoading = true;
    });
    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);

      FirebaseFirestore.instance.collection("User").doc(user.user!.uid).set({
        'Mobilenumber': mobilenumber,
        'username': userName,
        'useremail': userEmail,
        'userpassword': userPassword,
        'role': _customertype == Customertype.company ? 'Company' : 'Customer',
        'gender': mygender.trim().toString(),
        'createdAt': DateTime.now(),
        'disabled': true,
      });
      Notificationservice().drawnotification();
      final FirebaseStorage _storage = FirebaseStorage.instance;
      for (String key in images.keys.toList()) {
        print(images[key]);
        final ref =
            _storage.ref().child(user.user!.email.toString()).child('$key.png');
        await ref.putData(await images[key]!.readAsBytes());
      }
      // ignore: use_build_context_synchronously

      await sendgmail();
      //  await sendverification();
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ErrorMessageAlertWidget()
          .show(context: context, text: e.message.toString());
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ErrorMessageAlertWidget().show(context: context, text: e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _trysubmit() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState?.save();
      print(_userName);
      print(_userEmail);
      print(_userPassword);
      print(_userRepassowrd);
    }
  }

  bool isChecked = false;

  void regcomplete(context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) {
        return RegComplete();
      },
    ));
  }

  Customertype? _customertype = Customertype.jordanian;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Perfect Renting',
          style: TextStyle(
            color: Color.fromARGB(96, 255, 255, 255),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://img.myloview.com/posters/distressed-black-texture-dark-grainy-texture-on-white-background-dust-overlay-textured-grain-noise-particles-rusted-white-effect-grunge-design-elements-vector-illustration-eps-10-700-253300231.jpg'),
                fit: BoxFit.cover),
          ),
          child: Card(
            color: Colors.transparent,
            margin: EdgeInsets.all(20),
            elevation: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            value?.contains(
                              RegExp('[^A-Za-z0-9]'),
                            );

                            if (value!.isEmpty) {
                              return 'Please enter a valid name.';
                            }

                            return null;
                          },
                          controller: _usercon,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (!EmailValidator.validate(
                              value.toString(),
                            )) {
                              return 'Please provide a valid email adress.';
                            }

                            return null;
                          },
                          controller: _emailcon,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            fillColor: Colors.transparent,
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value?.length != 10)
                              return 'Mobile Number must be of 10 digit';
                            else
                              return null;
                          },
                          controller: _mobilenumber,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.transparent,
                            prefixIcon: Icon(
                              Icons.numbers,
                            ),
                            hintText: 'Enter phone number',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                !value.contains(
                                  RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
                                )) {
                              return 'Password in Invalid';
                            }

                            return null;
                          },
                          controller: _userpasswordcon,
                          obscureText: obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(Icons.visibility),
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.password,
                              ),
                              fillColor: Colors.transparent,
                              labelText: 'Password',
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value != _userpasswordcon.text) {
                              return 'Password is not match';
                            }

                            return null;
                          },
                          controller: _confirmPass,
                          obscureText: obscureText2,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: Icon(Icons.visibility),
                              onTap: () {
                                setState(() {
                                  obscureText2 = !obscureText2;
                                });
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.password,
                            ),
                            fillColor: Colors.transparent,
                            labelText: 'Re-enter your password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              DropdownButton<String>(
                                value: mygender,
                                icon: const Icon(Icons.person_3_rounded),
                                elevation: 16,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                underline: Container(
                                  height: 2,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    mygender = value!;
                                  });
                                },
                                items: gender.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: const Text('Jordanian'),
                                leading: Radio<Customertype>(
                                  value: Customertype.jordanian,
                                  groupValue: _customertype,
                                  onChanged: (Customertype? value) {
                                    setState(() {
                                      _customertype = value;
                                      images.clear();
                                      drivingL = false;
                                      nationalID = false;
                                      passport = false;
                                      commercialrecord = false;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Non-Jordanian'),
                                leading: Radio<Customertype>(
                                  value: Customertype.non_jordanian,
                                  groupValue: _customertype,
                                  onChanged: (Customertype? value) {
                                    setState(() {
                                      _customertype = value;
                                      images.clear();
                                      drivingL = false;
                                      nationalID = false;
                                      passport = false;
                                      commercialrecord = false;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Company account?'),
                                leading: Radio<Customertype>(
                                  value: Customertype.company,
                                  groupValue: _customertype,
                                  onChanged: (Customertype? value) {
                                    setState(() {
                                      _customertype = value;
                                      images.clear();
                                      drivingL = false;
                                      nationalID = false;
                                      passport = false;
                                      commercialrecord = false;
                                    });
                                  },
                                ),
                              ),
                              _customertype == Customertype.jordanian
                                  ? Row(
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                textStyle:
                                                    TextStyle(fontSize: 10),
                                                backgroundColor: Colors.purple,
                                                fixedSize: const Size(130, 30),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50))),
                                            onPressed: () async {
                                              final ImagePicker _picker =
                                                  ImagePicker();
                                              final XFile? image =
                                                  await _picker.pickImage(
                                                      source:
                                                          ImageSource.camera);

                                              if (image == null) {
                                                return;
                                              }
                                              drivingL = true;
                                              images['DrivingLicense'] = image;
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.camera_enhance),
                                                Text(
                                                  'DrivingLicense',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        96, 255, 255, 255),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        SizedBox(width: 5),
                                        SizedBox(
                                          width: 105,
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                final ImagePicker _picker =
                                                    ImagePicker();
                                                final XFile? image =
                                                    await _picker.pickImage(
                                                        source:
                                                            ImageSource.camera);

                                                if (image == null) {
                                                  return;
                                                }
                                                images['nationalID'] = image;
                                                nationalID = true;
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  textStyle:
                                                      TextStyle(fontSize: 10),
                                                  backgroundColor:
                                                      Colors.purple,
                                                  fixedSize:
                                                      const Size(105, 30),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50))),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.camera_enhance),
                                                  Text(
                                                    'NationalID',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          96, 255, 255, 255),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    )
                                  : (_customertype ==
                                          Customertype.non_jordanian)
                                      ? Wrap(
                                          children: <Widget>[
                                            ElevatedButton(
                                                onPressed: () async {
                                                  final ImagePicker _picker =
                                                      ImagePicker();
                                                  final XFile? image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .camera);

                                                  if (image == null) {
                                                    return;
                                                  }
                                                  drivingL = true;
                                                  images['DrivingLicense'] =
                                                      image;
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  textStyle: TextStyle(
                                                      fontSize: 10,
                                                      inherit: false),
                                                  backgroundColor:
                                                      Colors.purple,
                                                  fixedSize:
                                                      const Size(142, 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.camera_enhance),
                                                    Text(
                                                      'Driving License',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            96, 255, 255, 255),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  final ImagePicker _picker =
                                                      ImagePicker();
                                                  final XFile? image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .camera);

                                                  if (image == null) {
                                                    return;
                                                  }
                                                  passport = true;
                                                  images['Passport'] = image;
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    textStyle: TextStyle(
                                                        fontSize: 10),
                                                    backgroundColor:
                                                        Colors.purple,
                                                    fixedSize: const Size(
                                                        124, 10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50))),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.camera_enhance),
                                                    Text(
                                                      'Passport',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            96, 255, 255, 255),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  final ImagePicker _picker =
                                                      ImagePicker();
                                                  final XFile? image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .camera);

                                                  if (image == null) {
                                                    return;
                                                  }
                                                  commercialrecord = true;
                                                  images['CommercialRecord'] =
                                                      image;
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  textStyle: TextStyle(
                                                      fontSize: 10,
                                                      inherit: true),
                                                  backgroundColor:
                                                      Colors.purple,
                                                  fixedSize:
                                                      const Size(142, 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.camera_enhance),
                                                    Text(
                                                      'CommercialRecord',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            96, 255, 255, 255),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                            ]),

                        ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    try {
                                      await signUP(context);
                                    } catch (e) {
                                      ErrorMessageAlertWidget().show(
                                          context: context, text: e.toString());
                                    }
                                  },

                            // onLongPress: () => regcomplete(context),

                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 12),
                                backgroundColor: Colors.purple,
                                fixedSize: const Size(200, 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            child: isLoading
                                ? CircularProgressIndicator()
                                : const Text(
                                    'Sign up',
                                    style: TextStyle(
                                      color: Color.fromARGB(96, 255, 255, 255),
                                    ),
                                  )),
                        // ElevatedButton(
                        //     onPressed: sendgmail
                        //     ,
                        //     // onLongPress: () => regcomplete(context),

                        //     style: ElevatedButton.styleFrom(
                        //         textStyle: TextStyle(fontSize: 12),
                        //         backgroundColor: Colors.purple,
                        //         fixedSize: const Size(200, 30),
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(50))),
                        //     child: const Text(
                        //       'send activation to admins',
                        //       style: TextStyle(
                        //         color: Color.fromARGB(96, 255, 255, 255),
                        //       ),
                        //     )),
                      ]),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
