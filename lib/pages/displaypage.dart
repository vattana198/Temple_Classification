import 'package:flutter/material.dart';
import '../consts.dart';
import '../widget/buttonnavigation_bar.dart' as NavigationBar;
import '../database/DatabaseHelper.dart';

class DisplayPage extends StatefulWidget {
  final int templeId;
  const DisplayPage({super.key , required this.templeId});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  String? templeName;
  String? templeInfo;
  double? embeddingValue;
  String? imagePath;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTempleData();
  }

  Future<void> loadTempleData() async {
  final dbHelper = DatabaseHelper();
  final db = await dbHelper.database;

  // Query the specific temple using the passed templeId
  final List<Map<String, dynamic>> temples = await db.query(
    'temples',
    where: 'id = ?',  // Filter by the templeId
    whereArgs: [widget.templeId],
    limit: 1,
  );

  if (temples.isNotEmpty) {
    // Query images for this temple
    final List<Map<String, dynamic>> images = await db.query(
      'temple_images',
      where: 'temple_id = ?',
      whereArgs: [widget.templeId],
      limit: 1,  // Only get one image (you might want to remove this if you want all images)
    );

    setState(() {
      templeName = temples.first['temple_name'];
      templeInfo = temples.first['Temple_info'];
      // If you have multiple images, you might want to show them all
      imagePath = images.isNotEmpty ? images.first['image_path'] : null;
      isLoading = false;
    });
  } else {
    setState(() {
      isLoading = false;
    });
    // Optional: Show an error message that the temple wasn't found
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFA87E62),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore, size: 30),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 32,
              child: ImageIcon(
                AssetImage('assets/images/saved.png'),
                size: 32,
              ),
            ),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30, color: Color(0xFF6B7280)),
            label: 'Profile',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // ✅ Entire body is now scrollable
              child: Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: boxDecoration,
                      child: imagePath != null
                          ? Image.asset(
                              imagePath!,
                              fit: BoxFit.cover,
                            )
                          : const Center(
                              child: Text(
                                "No Image Available",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                    ),
                    Text(
                      templeName ?? "Temple Name",
                      style: display1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        templeInfo ?? "Temple Information",
                        textAlign: TextAlign.center,
                        style: display2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA87E62),
                        ),
                        child: Text(
                          "Back",
                          style: display3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
