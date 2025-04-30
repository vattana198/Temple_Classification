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
import '../pages/history_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // Initialize FFI for desktop platforms
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;
  print("Database has been initialized");
  print('Database path: ${await getDatabasesPath()}');
  
  // Initialize the database
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
      home: HistoryPage(),
    );
  }
}