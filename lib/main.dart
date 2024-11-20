import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/mobile/splash_screen.dart';
import 'package:myapp/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      //   apiKey: "AIzaSyCE7brLJc3CKMhAKaIMTG2rKMohRltov_U",
      // databaseURL: "https://fyp-project-1efc7.firebaseio.com",
      //   appId: "1:98852003437:web:ae7207609a216f1cf2e964",
      //   messagingSenderId: "98852003437",
      //   projectId: "fyp-project-1efc7",
      // storageBucket: "gs://fyp-project-1efc7.appspot.com"
      apiKey: "AIzaSyA_3Fd1ttYYZlFFFxMnv1J5ngKu9Axh-Ac",
      authDomain: "fyp-project-a9b28.firebaseapp.com",
      projectId: "fyp-project-a9b28",
      storageBucket: "fyp-project-a9b28.firebasestorage.app",
      messagingSenderId: "963237383868",
      appId: "1:963237383868:web:79048f4bdbeaf1f7358ab9",
      measurementId: "G-QE6KCC5XD1",
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBE Based Class Monitoring System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: kIsWeb ? const MyWebHomePage() : const MyMobileHomePage(),
      // home: const AdminDashBoard(),
    );
  }
}
