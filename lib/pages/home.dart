import 'package:flutter/material.dart';
import 'package:temple_classification/pages/frontpage.dart';
import '../pages/home.dart';
import '../pages/frontPage.dart';
import '/consts.dart' ; // Ensure this file contains the FrontPage widget class

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,  
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFA87E62),
        // unselectedItemColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home ,  size: 30,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            
            icon: Icon(Icons.explore , size: 30,),
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
            icon: Icon(Icons.person , size: 30, color: Color(0xFF6B7280)),
            label: 'Profile',
          ),
        ],
        // currentIndex: _selectedIndex,
        // onTap: _onItemTapped,
      ),
    
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/temple2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground content
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child:  Text(
                              "Temple Scanner",
                              style:homestyle1,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5, left: 10),
                            child:  Text(
                              "Discover Cambodian Temples",
                              style:homestyle2,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[100],
                        child: Image.asset(
                          'assets/images/i.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: boxDecoration,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: const Color(0xFFA87E62),
                          child: Image.asset(
                            'assets/images/camera.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                         Text(
                          "Scan Temple",
                          style: homestyle3,
                        ),
                         Text(
                          "Point your camera at a temple to identify it",
                          style: homestyle4,
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              print("testing");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA87E62),
                            ),
                            child:  Text(
                              "Start Scanning",
                              style: homestyle5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children:  [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Recent Scans",
                          style: homestyle6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  recentScan(
                    "assets/images/angkor.png",
                    "Temple of Angkor Wat",
                    "Scanned 2h ago",
                  ),
                  const SizedBox(height: 10),
                  recentScan(
                    "assets/images/bayon.png",
                    "Bayon Temple",
                    "Scanned 5h ago",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


Widget recentScan(String imagePath, String title, String subtitle) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    width: double.infinity,
    height: 80,
    decoration: boxDecoration2,
    child: Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Image.asset(imagePath),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left:10),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
