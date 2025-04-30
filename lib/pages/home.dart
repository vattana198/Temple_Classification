import 'package:flutter/material.dart';
import 'package:temple_classification/pages/frontpage.dart';
import '../pages/home.dart';
import '../pages/frontPage.dart';
import '/consts.dart' ; 
import '../pages/camera_page.dart';
import '../widget/recent_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; 
   void _onItemTapped(int index){
      setState(() {
        _selectedIndex = index;
      });
      if (index == 0){
        Navigator.push(
          context ,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else if (index ==1){
        // explore page
      } else if (index == 2){
        // saved page
        // Navigator.push(
        //   context ,
        //   MaterialPageRoute(
        //     builder: (context) => HistoryPage(),
        //   ),
        // );
      }else if (index == 3){

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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
       
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
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) =>  CameraPage(),
                                ),
                              );
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


