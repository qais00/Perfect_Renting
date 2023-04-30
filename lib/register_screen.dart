import 'dart:io';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:perfect_renting/login_complete.dart';
import 'package:perfect_renting/main.dart';
import 'package:perfect_renting/register_form.dart';
import './reg_complete.dart';

enum Customertype { jordanian, non_jordanian }

const List<String> gender = ['Male', 'Female'];
// enum Gender { male, female }

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  String? mygender = null;
  Customertype? _customertype = Customertype.jordanian;
  
  @override
  Widget build(BuildContext context) {
    void regcomplete(context) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return RegComplete();
        },
      ));
    }

    return IntrinsicHeight(
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(

        //   child: Icon(Icons.arrow_back_ios_new_sharp),
        //   elevation: Checkbox.width,
        //   backgroundColor: Color.fromARGB(255, 116, 39, 93),
        //   onPressed: () {
        //     Navigator.of(context).pop(true);
        //   },

        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 116, 39, 93),
          title: const Text(
            'Perfect Renting',
            style: TextStyle(
              color: Color.fromARGB(96, 255, 255, 255),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 32, 148, 129),
        body: TextButton(
          onPressed: () => {/*Navigator.of(context).pop(true)*/},
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/Car_icon_alone.png',
                    ),
                    alignment: Alignment(1.1, -0.7),
                    opacity: 10)),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          labelText: 'FullName',
                        ),
                        keyboardType: TextInputType.name),
                  ),
                  SizedBox(
                    width: 200,
                    child: const TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 13.0),
                        labelText: 'E-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        labelText: 'Password',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        labelText: 'Re-enter your password',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                    DropdownButton<String>(
                      value: mygender,
                      icon: const Icon(Icons.person_3_rounded),
                      elevation: 16,
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
                      items:
                          gender.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                   
                  ]),
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                    ListTile(
                      title: const Text('Jordanian'),
                      leading: Radio<Customertype>(
                        value: Customertype.jordanian,
                        groupValue: _customertype,
                        onChanged: (Customertype? value) {
                          setState(() {
                            _customertype = value;
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
                          });
                        },
                      ),
                    ),
                    _customertype == Customertype.jordanian
                        ? Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 10),
                                      backgroundColor:
                                          Color.fromARGB(255, 116, 39, 93),
                                      fixedSize: const Size(100, 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  child: const Text(
                                    'Driving License',
                                    style: TextStyle(
                                      color: Color.fromARGB(96, 255, 255, 255),
                                    ),
                                  )),
                              SizedBox(width: 5),
                              ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 10),
                                      backgroundColor:
                                          Color.fromARGB(255, 116, 39, 93),
                                      fixedSize: const Size(80, 30),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  child: const Text(
                                    'NationalID',
                                    style: TextStyle(
                                      color: Color.fromARGB(96, 255, 255, 255),
                                    ),
                                  )),
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 10),
                                      backgroundColor:
                                          Color.fromARGB(255, 116, 39, 93),
                                      fixedSize: const Size(100, 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  child: const Text(
                                    'Passport',
                                    style: TextStyle(
                                      color: Color.fromARGB(96, 255, 255, 255),
                                    ),
                                  )),
                              ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 10),
                                      backgroundColor:
                                          Color.fromARGB(255, 116, 39, 93),
                                      fixedSize: const Size(100, 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  child: const Text(
                                    'Driving License',
                                    style: TextStyle(
                                      color: Color.fromARGB(96, 255, 255, 255),
                                    ),
                                  )),
                            ],
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () => regcomplete(context),
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 12),
                                backgroundColor:
                                    Color.fromARGB(255, 116, 39, 93),
                                fixedSize: const Size(200, 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Color.fromARGB(96, 255, 255, 255),
                              ),
                            )),
                            
                        // Container(
                        //   child: Image.file(
                        //     File(pickedFile!.path!),
                        //     width: double.infinity,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
