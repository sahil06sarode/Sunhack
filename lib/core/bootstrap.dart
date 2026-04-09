import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'package:conflictsense/firebase_options.dart';

class AppBootstrap {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (_) {
      try {
        await Firebase.initializeApp();
      } catch (_) {
        // Allow local UI work before Firebase is configured.
      }
    }
  }
}
