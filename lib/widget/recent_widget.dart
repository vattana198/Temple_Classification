import 'package:flutter/material.dart';
import 'package:temple_classification/consts.dart'; 



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