// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class CameraShot extends StatefulWidget {
//   final CameraDescription camera;
//   CameraShot({@required this.camera});

//   @override
//   State<CameraShot> createState() => CameraShotState();
// }

// class CameraShotState extends State<CameraShot> {
  
//    CameraController _controller;
//    Future<void> _initializeControllerFuture;
//   @override
//   void initState() {
//     super.initState();
//     // To display the current output from the Camera,
//     // create a CameraController.
//     _controller = CameraController(
//       // Get a specific camera from the list of available cameras.
//       widget.camera,
//       // Define the resolution to use.
//       ResolutionPreset.medium,
//     );

//     // Next, initialize the controller. This returns a Future.
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _controller.dispose();
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       body: FutureBuilder<void>(
//   future: _initializeControllerFuture,
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.done) {
//       // If the Future is complete, display the preview.
//       return CameraPreview(_controller);
//     } else {
//       // Otherwise, display a loading indicator.
//       return const Center(child: CircularProgressIndicator());
//     }
//   },
// ),
//     );
//   }
// }