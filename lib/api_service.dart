import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class ApiService {
  // For iOS simulator use 'http://localhost:8080'
  // For physical device use your computer's local IP (e.g., 'http://192.168.x.x:8080')
  static const String baseURl = 'http://localhost:8080';

  // CHECK API HEALTH with timeout
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseURl/health'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['model_loaded'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking health: $e');
      return false;
    }
  }

  // SEND IMAGE TO API with improved error handling
// static Future<Map<String, dynamic>> getTempleEmbeddings(File imageFile) async {
//   try {
//     // Get file extension
//     final extension = imageFile.path.split('.').last.toLowerCase();
//     final contentType = extension == 'jpg' ? 'image/jpg' : 'image/$extension';

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$baseURl/predict'),
//     );

//     // Add the image file with proper content type
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'image', // Ensure this matches what server expects
//         imageFile.path,
//         contentType: MediaType.parse(contentType),
//       ),
//     );

//     // Add debug headers
//     request.headers['Accept'] = 'application/json';
//     debugPrint('Content-Type: $contentType');

//     var response = await request.send();
//     var responseData = await response.stream.bytesToString();

//     if (response.statusCode != 200) {
//       throw Exception('API Error ${response.statusCode}: $responseData');
//     }

//     return json.decode(responseData);
//   } catch (e) {
//     debugPrint('API Error details: $e');
//     throw Exception('Failed to process image: $e');
//   }
// }

static Future<Map<String, dynamic>> getTempleEmbeddings(File imageFile) async {
  try {
    // Validate image exists
    if (!await imageFile.exists()) {
      throw Exception('Image file does not exist');
    }

    // Create request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseURl/predict'),
    );

    // Add the image file with explicit content type
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // Must match the API expectation
        imageFile.path,
        contentType: MediaType('image', 'jpeg'), // or 'png'
      ),
    );

    // Add headers
    request.headers['Accept'] = 'application/json';
    
    // Print request details for debugging
    debugPrint('Sending request to: ${request.url}');
    debugPrint('File field name: image');
    debugPrint('File path: ${imageFile.path}');
    debugPrint('Content-Type: image/jpeg');

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    debugPrint('API Response Status: ${response.statusCode}');
    debugPrint('API Response Body: $responseData');

    if (response.statusCode != 200) {
      throw Exception('API Error ${response.statusCode}: $responseData');
    }

    return json.decode(responseData);
  } catch (e) {
    debugPrint('API Error details: $e');
    throw Exception('Failed to process image: $e');
  }
}


}