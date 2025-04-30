import 'package:flutter/material.dart';
import '../pages/home.dart';
import '../widget/recent_widget.dart';
import '../consts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent History'),
        backgroundColor: Color(0xFFA87E62),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
    );
  }
}
