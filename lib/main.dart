import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/events/add_events/add_events.dart';
import 'package:flutterprojectfinal/screens/auth/admin/adminPage.dart';
import 'package:flutterprojectfinal/screens/auth/login/login_screen.dart';
import 'package:flutterprojectfinal/screens/auth/signup/signup_screen.dart';
import 'package:flutterprojectfinal/services/provider/userCredentialProvider.dart';
import 'package:flutterprojectfinal/ui/homepage/page_render.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart'; // Import your provider
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavouriteProvider()),
        ChangeNotifierProvider(create: (context) => UserCredentialProvider()),
        // Add other providers here if needed
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // Pass the GlobalKey to MaterialApp

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue,
              titleTextStyle: TextStyle(fontSize: 24, color: Colors.white)),
        ),
        initialRoute: '/admin',
        routes: {
          '/': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => PageRender(),
          '/addevent': (context) => AddEventScreen(),
          '/admin': (context) => AdminPage(),
        },
      ),
    );
  }
}
