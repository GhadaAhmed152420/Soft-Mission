import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:eschool/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await initializeApp();
}
