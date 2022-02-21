import 'package:flutter/material.dart';
import 'package:pinterest_app/models/pinterest_model.dart';
import 'package:pinterest_app/pages/chat_page.dart';
import 'package:pinterest_app/pages/detail_page.dart';
import 'package:pinterest_app/pages/control_page.dart';
import 'package:pinterest_app/pages/intro_page.dart';
import 'package:pinterest_app/pages/profile_page.dart';
import 'package:pinterest_app/pages/search_page.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// key
  /// MTgfbWGliunTpETughwj_azSDlGAUS9yTy4NBGogi0c

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Colors.black,
        bottomAppBarColor: Colors.grey.shade300,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.white60),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.white,
        listTileTheme: ListTileThemeData(
          textColor: Colors.white
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.black54),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
        bottomAppBarColor: Colors.grey.shade600,
        iconTheme: IconThemeData(color: Colors.white),
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      title: 'Pinterest',
      home: IntroPage(),
      routes: {
        ControlPage.id: (context) => ControlPage(),
        DetailPage.id: (context) => DetailPage(post: Pinterest.fromJson({}),),
        SearchPage.id: (context) => SearchPage(),
        ChatPage.id: (context) => ChatPage(),
        IntroPage.id: (context) => IntroPage(),
        ProfilePage.id: (context) => ProfilePage(),
      },
    );
  }
}
