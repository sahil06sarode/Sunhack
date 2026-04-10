import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conflictsense/firebase_options.dart';
import 'package:conflictsense/screens/dashboard_screen.dart';
import 'package:conflictsense/screens/login_screen.dart';
import 'package:conflictsense/screens/onboarding_screen.dart';
import 'package:conflictsense/theme/app_visual_theme.dart';

const String _envFileName = '.env';

Future<void> _loadRuntimeEnv() async {
  try {
    await dotenv.load(fileName: _envFileName);
    final geminiKey = (dotenv.env['GEMINI_API_KEY'] ?? '').trim();
    if (geminiKey.isEmpty || geminiKey == 'YOUR_TEST_API_KEY_HERE') {
      debugPrint(
          '⚠️ Loaded .env, but GEMINI_API_KEY is missing or placeholder.');
    } else {
      debugPrint('✅ Runtime config loaded from .env.');
    }
  } catch (e) {
    debugPrint('❌ Failed to load .env file: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadRuntimeEnv();
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
      theme: AppVisualTheme.lightTheme(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          final user = snapshot.data;

          if (user == null) {
            return const LoginScreen();
          }

          // User is logged in, check if they completed onboarding
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, docSnapshot) {
              if (docSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
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
