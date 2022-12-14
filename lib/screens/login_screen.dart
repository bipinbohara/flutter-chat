import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/driver/driver_main.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/user/user_main.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../user/user_map_screen.dart';
import 'map_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _firestore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  final _auth = FirebaseAuth.instance;
  final _userUid =
      _firestore.collection('users').doc('OR3Oy9cv1RVd8Jk2lioXMSWJY8z1');
  bool showSpinner = false;
  String email;
  String password;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";

      print(_email);
      print(_password);

      setState(() {});
      _emailController.text = _email ?? "";
      _passwordController.text = _password ?? "";
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email', labelText: "Email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password', labelText: "Password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: "Log In",
                colour: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    SharedPreferences.getInstance().then(
                      (prefs) {
                        prefs.setString('email', email);
                        prefs.setString('password', password);
                      },
                    );
                    final user = await _auth.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text);
                    print(email);
                    print(password);
                    // Locally save data
                    if (user != null) {
                      // Navigator.pushNamed(context, MapScreen.id);
                      if (_auth.currentUser.uid ==
                          "OR3Oy9cv1RVd8Jk2lioXMSWJY8z1") {
                        Navigator.pushNamed(context, DriverMain.id);
                      }
                      if (_auth.currentUser.uid ==
                              "EQeXR1MUMDQ23gDQBqj7zgdfqe03" ||
                          _auth.currentUser.uid ==
                              "uIuDTEUiEAhqfwOFa2N0xJvxxug2") {
                        Navigator.pushNamed(context, UserMain.id);
                      }
                      //Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
