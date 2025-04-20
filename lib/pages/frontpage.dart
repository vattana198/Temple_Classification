import 'package:flutter/material.dart';

class FrontPage extends StatelessWidget {
  FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(bottom: 200),
          
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/images/temple.png',
              ),
              
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 190,
                  
                  child: Container(
                    
                    child: ElevatedButton(onPressed: (){
                      print("testing");
                    
                    }, 
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFA87E62)),
                    child: const Text("Get Started" , style: TextStyle(color: Colors.white ,  fontFamily: 'Poppins',),) , ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
