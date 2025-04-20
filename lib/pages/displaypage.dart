import 'package:flutter/material.dart';
import '../consts.dart'; 
import '../widget/buttonnavigation_bar.dart' as NavigationBar;// Ensure this file contains the FrontPage widget class

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
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
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: boxDecoration,
              child: Image.asset(
                'assets/images/temple3.png',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "Tunle Oum Gate",
              style: display1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Text(
                    "The Tunle Oum Gate, located in Siem Reap, Cambodia, is one of the five majestic gates that lead into the ancient city of Angkor Thom, part of the Angkor Archaeological Park. Built during the reign of King Jayavarman VII in the late 12th century, this gate reflects the grandeur of Khmer architecture and spiritual symbolism. It features a causeway lined with statues of gods and demons holding a naga (serpent), representing the Churning of the Ocean of Milk from Hindu mythology.",
                    textAlign: TextAlign.center,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: display2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  print("testing");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA87E62),
                ),
                child:  Text(
                  "Back",
                  style: display3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
