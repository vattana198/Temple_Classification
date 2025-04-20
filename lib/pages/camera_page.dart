import 'package:flutter/material.dart';
import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final GlobalKey cameraKey = GlobalKey();
  CameraMacOSController? macOSController;
  bool isCameraInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
        backgroundColor: const Color(0xFFA87E62),
      ),
      body: Center(
        child: kIsWeb
            ? const Text(
                "Camera is not supported on the web.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              )
            : CameraMacOSView(
                key: cameraKey,
                fit: BoxFit.fill,
                cameraMode: CameraMacOSMode.photo,
                onCameraInizialized: (controller) {
                  setState(() {
                    macOSController = controller;
                    isCameraInitialized = true;
                  });
                },
              ),
      ),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              onPressed: () async {
                if (isCameraInitialized && macOSController != null) {
                  final image = await macOSController!.takePicture();
                  print("Image saved at: $image");
                } else {
                  print("Camera is not initialized yet.");
                }
              },
              backgroundColor: const Color(0xFFA87E62),
              child: const Icon(Icons.camera),
            ),
    );
  }
}