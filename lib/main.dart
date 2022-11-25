import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/driver/driver_data_screen.dart';
import 'package:flash_chat/driver/driver_main.dart';
import 'package:flash_chat/driver/driver_map_screen.dart';
import 'package:flash_chat/screens/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/map_view.dart';

void main() async {
  //Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Firebase
  await Firebase.initializeApp();
  //
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        MapScreen.id: (context) => MapScreen(),
        DriverMain.id: (context) => DriverMain(),
        DriverMapScreen.id: (context) => DriverMapScreen(),
        DriverDataScreen.id: (context) => DriverDataScreen(),
      },
    );
  }
}
