import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temple_classification/api_service.dart';  
import 'dart:io';
import 'package:temple_classification/classifier.dart';
import 'package:temple_classification/database/DatabaseHelper.dart';



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
    List<CameraDescription> availableCamerasList =
        await availableCameras(); // Renamed the variable here
    if (availableCamerasList.isNotEmpty) {
      setState(() {
        cameras =
            availableCamerasList; // Assign the available cameras to the class variable
        cameraController =
            CameraController(cameras.last, ResolutionPreset.high);
      });

      cameraController?.initialize().then((_) {
        setState(() {});
      }).catchError((e) {
        // Handle the error (e.g., log it or show a message)
      });
    }
  }

  // Future<void> _pickImage() async {
  //   final XFile? pickedFile =
  //       await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       picture = pickedFile;
  //       isProcessing = true; // Start freeze
  //     });
  //     await Future.delayed(
  //         const Duration(milliseconds: 300)); // Freeze duration
  //     setState(() => isProcessing = false); // End freeze
  //   } else {
  //     picture = null;
  //   }
  // }
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _processImage(pickedFile);
    }
  }

  // In your _processImage method, update the error handling:
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
    // 1. Check API health
    final isHealthy = await ApiService.checkHealth();

    if (!isHealthy) {
      throw Exception('API is not ready. Please ensure the server is running and model is loaded.');
    }

    // 2. Get embeddings from API
    final result = await ApiService.getTempleEmbeddings(File(imageFile.path));
    
    if (!result.containsKey('embedding')) {
      throw Exception('Unexpected API response format');
    }
    
    final testEmbedding = List<double>.from(result['embedding']);
    setState(() => embeddings = testEmbedding);

    // 3. Get reference embeddings from database
    final dbHelper = DatabaseHelper();
    final referenceEmbeddings = await dbHelper.getAllTempleEmbeddings();
    
    if (referenceEmbeddings.isEmpty) {
      throw Exception('No temple embeddings found in database');
    }

    // 4. Find closest match
    final prediction = ClassifierUtils.predictClass(
      referenceEmbeddings,
      testEmbedding,
      maxDistance: 1.0, // Adjust threshold as needed
    );

    // 5. Calculate all distances
    final Map<String, double> allDistances = {};
    referenceEmbeddings.forEach((name, emb) {
      final distance = ClassifierUtils.euclideanDistance(testEmbedding, emb);
      allDistances[name] = distance;
      debugPrint('Distance to $name: $distance');
    });

    // 6. Store results
    setState(() {
      predictionResult = prediction ?? 'Unknown temple';
      distanceResults = allDistances; // <-- important to update this!
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temple Classification"),
        backgroundColor: const Color(0xFFA87E62),
      ),
      body: Stack(children: [
        camera(),
        bottomButtons(),
        if (isProcessing) processingOverlay(),
        if (embeddings != null) resultsOverlay(),
        if (errorMessage != null) errorOverlay(),
      ]),
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

  if (distanceResults != null && distanceResults!.isNotEmpty) {
    // Find the entry with the minimum distance
    final closestEntry = distanceResults!.entries.reduce((a, b) => a.value < b.value ? a : b);
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
                'Temple Embeddings:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Vector Length: ${embeddings!.length} dimensions',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  embeddings!.map((e) => e.toStringAsFixed(4)).join(', '),
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
              SizedBox(height: 20),
            ],

            // --- Identified Temple Section ---
            if (identifiedTemple != null) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Identified as: $identifiedTemple',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
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



// # Make prediction by comparing the test embedding to the reference database
// def predict_class(reference_database, test_embedding):

//     min_distance = float('inf')
//     predicted_class = None


//     for label, reference_embedding in reference_database.items():

//         distance = euclidean(test_embedding, reference_embedding)

//         if distance < min_distance:
//             min_distance = distance
//             predicted_class = label

//     return predicted_class