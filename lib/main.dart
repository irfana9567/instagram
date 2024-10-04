import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/common/constants/constant.dart';
import 'package:instagram/common/theme/App_theme.dart';
import 'package:instagram/features/auth/screen/Signup.dart';
import 'package:instagram/features/splash/screen/splash_screen.dart';
import 'package:instagram/firebase_options.dart';

import 'first_page.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.scrHeight=MediaQuery.of(context).size.height;
    AppSize.scrWidth=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap:  () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: const MaterialApp(
        title: "Instagram",
        debugShowCheckedModeBanner: false,
        // themeMode: ThemeMode.light,
        // theme: CAppTheme.lightTheme,
        // darkTheme: CAppTheme.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}

