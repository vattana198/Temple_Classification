import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temple_classification/api_service.dart';
import 'dart:io';
import 'package:temple_classification/classifier.dart';
import 'package:temple_classification/database/DatabaseHelper.dart';
import 'package:temple_classification/pages/displaypage.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  bool isProcessing = false;
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  XFile? picture;
  List<double>? embeddings;
  String? errorMessage;

  String? predictionResult;
  Map<String, double>? distanceResults;

  MapEntry<String, double>? getClosestTemple() {
    if (distanceResults == null || distanceResults!.isEmpty) return null;
    return distanceResults!.entries.reduce((a, b) => a.value < b.value ? a : b);
  }

  @override
  void initState() {
    super.initState();
    _requestCameraPermission().then((_) {
      _setUpCameraController();
    });
  }

  Future<void> _requestCameraPermission() async {
    const permission = Permission.camera;
    if (await permission.isDenied) {
      await permission.request();
      if (await permission.isDenied) {
        return;
      }
    }
  }

  Future<void> _setUpCameraController() async {
    List<CameraDescription> availableCamerasList = await availableCameras();
    if (availableCamerasList.isNotEmpty) {
      setState(() {
        cameras = availableCamerasList;
        cameraController = CameraController(cameras.last, ResolutionPreset.high);
      });

      cameraController?.initialize().then((_) {
        setState(() {});
      }).catchError((e) {
        // Handle the error (e.g., log it or show a message)
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _processImage(pickedFile);
    }
  }

  Future<void> _processImage(XFile imageFile) async {
    setState(() {
      picture = imageFile;
      isProcessing = true;
      embeddings = null;
      errorMessage = null;
      predictionResult = null;
      distanceResults = null;
    });

    try {
      final isHealthy = await ApiService.checkHealth();

      if (!isHealthy) {
        throw Exception('API is not ready. Please ensure the server is running and model is loaded.');
      }

      final result = await ApiService.getTempleEmbeddings(File(imageFile.path));

      if (!result.containsKey('embedding')) {
        throw Exception('Unexpected API response format');
      }

      final testEmbedding = List<double>.from(result['embedding']);
      setState(() => embeddings = testEmbedding);

      final dbHelper = DatabaseHelper();
      final referenceEmbeddings = await dbHelper.getAllTempleEmbeddings();

      if (referenceEmbeddings.isEmpty) {
        throw Exception('No temple embeddings found in database');
      }

      final prediction = ClassifierUtils.predictClass(
        referenceEmbeddings,
        testEmbedding,
        maxDistance: 1.0,
      );

      final Map<String, double> allDistances = {};
      referenceEmbeddings.forEach((name, emb) {
        final distance = ClassifierUtils.euclideanDistance(testEmbedding, emb);
        allDistances[name] = distance;
        debugPrint('Distance to $name: $distance');
      });

      setState(() {
        predictionResult = prediction ?? 'Unknown temple';
        distanceResults = allDistances;
      });
    } catch (e) {
      setState(() => errorMessage = 'Error: ${e.toString()}');
      debugPrint('Image processing error: $e');
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> _navigateToTempleInfo(String templeName) async {
    final dbHelper = DatabaseHelper();
    final templeData = await dbHelper.getTempleByName(templeName);

    if (templeData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPage(
            templeId: templeData['id'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temple Classification"),
        backgroundColor: const Color(0xFFA87E62),
      ),
      body: Stack(
        children: [
          camera(),
          bottomButtons(),
          if (isProcessing) processingOverlay(),
          if (embeddings != null) resultsOverlay(),
          if (errorMessage != null) errorOverlay(),
        ],
      ),
    );
  }

  Widget processingOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Processing temple image...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultsOverlay() {
    String? identifiedTemple;
    MapEntry<String, double>? closestEntry;

    if (distanceResults != null && distanceResults!.isNotEmpty) {
      closestEntry = distanceResults!.entries.reduce((a, b) => a.value < b.value ? a : b);
      identifiedTemple = closestEntry.key;
    }

    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (embeddings != null) ...[
                Text(
                  'Temple Identified as:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
              ],
              if (identifiedTemple != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$identifiedTemple',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _navigateToTempleInfo(identifiedTemple!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA87E62),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('View Info', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget errorOverlay() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          errorMessage!,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Positioned camera() {
    return Positioned.fill(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: 100,
          child: Stack(
            children: [
              if (cameraController != null && cameraController!.value.isInitialized)
                CameraPreview(cameraController!),
              if (picture != null)
                Image.file(File(picture!.path), fit: BoxFit.cover),
            ],
          ),
        ),
      ),
    );
  }

  Positioned bottomButtons() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.075,
      left: MediaQuery.of(context).size.width * 0.075,
      right: MediaQuery.of(context).size.width * 0.075,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.cameraswitch, color: Colors.black, size: 35),
              onPressed: () {
                // TODO: Implement camera switch
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera, color: Colors.black, size: 35),
              onPressed: () async {
                if (cameraController != null && cameraController!.value.isInitialized) {
                  XFile picture = await cameraController!.takePicture();
                  await _processImage(picture);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.image, color: Colors.black, size: 35),
              onPressed: () async {
                await _pickImage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
