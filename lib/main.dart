import 'package:flutter/material.dart';
import 'package:temple_classification/pages/camera_page.dart';
import 'package:temple_classification/pages/frontpage.dart';
import 'package:temple_classification/pages/home.dart';
import '../pages/displaypage.dart'; 
import '../pages/camera_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Temple Classification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraPage(),
    );
  }
}