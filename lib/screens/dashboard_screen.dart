import 'package:flutter/material.dart';
import 'package:conflictsense/screens/query_screen.dart';
import 'package:conflictsense/screens/feed_screen.dart';

class IntelligenceDashboard extends StatefulWidget {
  const IntelligenceDashboard({super.key});

  @override
  State<IntelligenceDashboard> createState() => _IntelligenceDashboardState();
}

class _IntelligenceDashboardState extends State<IntelligenceDashboard> {
  int _currentIndex = 0;

  final List<Widget> _modes = const [
    LiveFeedScreen(),
    QueryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Intelligence & Prediction System",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white70),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white10,
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: _modes[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: "Automatic Mode",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Query Mode",
          ),
        ],
      ),
    );
  }
}
