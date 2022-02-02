import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:referral_code_demo/Authentication/SplashScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(
        size: Size(1000, 500),
      ),
      child: ScreenUtilInit(builder: () {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textSelectionTheme: const TextSelectionThemeData(
                selectionHandleColor: Colors.transparent,
              ),
              primaryTextTheme: GoogleFonts.jostTextTheme(),
              primarySwatch: Colors.deepOrange,
              textTheme: GoogleFonts.jostTextTheme()),
          home: const SplashScreen(),
        );
      }),
    );
  }
}

