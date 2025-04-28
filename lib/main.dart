import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temple_classification/pages/camera_page.dart';
import 'package:temple_classification/pages/frontpage.dart';
import 'package:temple_classification/pages/home.dart';
import '../pages/displaypage.dart'; 
import '../pages/camera_page.dart'; 
import './database/DatabaseHelper.dart'; 
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  print("databae have been initialized");
  print('Database path: ${await getDatabasesPath()}');
  
  // Initialize the database and insert data
  final dbHelper = DatabaseHelper();
  final db = await dbHelper.database;


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