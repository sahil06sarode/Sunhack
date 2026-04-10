import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conflictsense/firebase_options.dart';
import 'package:conflictsense/screens/dashboard_screen.dart';
import 'package:conflictsense/screens/login_screen.dart';
import 'package:conflictsense/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ load .env file successfully.");
  } catch (e) {
    debugPrint("❌ Failed to load .env file: $e");
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ConflictSenseApp());
}

class ConflictSenseApp extends StatelessWidget {
  const ConflictSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConflictSense AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0F4C81), // Professional deep blue
        scaffoldBackgroundColor: const Color(0xFFF4F6F8), // Soft light grey background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF0F4C81),
          secondary: const Color(0xFFE38A3A),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          final user = snapshot.data;
          
          if (user == null) {
            return const LoginScreen();
          }

          // User is logged in, check if they completed onboarding
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, docSnapshot) {
              if (docSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              
              if (docSnapshot.hasData && docSnapshot.data!.exists) {
                final data = docSnapshot.data!.data() as Map<String, dynamic>;
                if (data['onboardingComplete'] == true) {
                  return const IntelligenceDashboard();
                }
              }
              
              return const OnboardingScreen();
            },
          );
        },
      ),
    );
  }
}
