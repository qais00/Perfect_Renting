import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class RegComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_back_ios_new_sharp),
          elevation: Checkbox.width,
          backgroundColor: Color.fromARGB(255, 116, 39, 93),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 116, 39, 93),
          title: Text(
            'Perfect Renting',
            style: TextStyle(
              color: Color.fromARGB(96, 255, 255, 255),
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 32, 148, 129),
        body: Center(
          child: Text(
            ' Thank you for registration\n Our admins recived your request\n Please keep on checking your notification \n within the next 24 hours',
            style: TextStyle(
              color: Color.fromARGB(255, 116, 39, 93),
              fontWeight: FontWeight.bold,fontSize: 15
            ),
          ),
        ));
  }
}
