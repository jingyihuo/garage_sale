import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class GoogleLogin extends StatefulWidget {
  GoogleLoginState createState() => new GoogleLoginState();
}

class GoogleLoginState extends State<GoogleLogin> {
  Widget currentPage;
  GoogleSignIn googleSignIn;
  Widget userPage;

  @override
  void initState() {
    super.initState();
    userPage = Home(
      onSignin: () {
        _signin();
        print("Sign");
      },
      onLogout: _logout,
      showLoading: false,
    );
  }

  Future<User> _signin() async {
    setState(() {
      userPage = Home(onSignin: null, onLogout: _logout, showLoading: true);
    });
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication gauth =
          await googleSignInAccount.authentication;
      // ignore: deprecated_member_use
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: gauth.accessToken,
        idToken: gauth.idToken,
      );
      final UserCredential authRes =
          await _auth.signInWithCredential(credential);
      final User user = authRes.user as User;

      setState(() {
        userPage = User(
          onLogout: _logout,
          user: user,
        );
      });

      return user;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  void _logout() async {
    await googleSignIn.signOut();
    setState(() {
      userPage = Home(
        onSignin: () {
          _signin();
          print("Sign");
        },
        onLogout: _logout,
        showLoading: false,
      );
    });
    print("Logged Out");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userPage,
    );
  }
}

class User extends StatelessWidget {
  User({Key key, @required this.onLogout, @required this.user})
      : super(key: key);

  VoidCallback onLogout;
  String username;
  User user;
  String get displayName => null;
  String get photoUrl => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: this.onLogout)
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(user
                  .photoUrl), ////////////////////////////////////////////////
              Text(
                user.displayName,
                textScaleFactor: 1.5,
              ),
            ],
          ))),
    );
  }
}

class Home extends StatelessWidget {
  Home(
      {Key key,
      @required this.onSignin,
      @required this.onLogout,
      @required this.showLoading})
      : super(key: key);

  final VoidCallback onSignin;
  final VoidCallback onLogout;
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Sign In"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        onPressed: this.onSignin,
                        child: Text("Sign In"),
                        color: Colors.blueGrey,
                      ),
              ],
            ),
          )),
    );
  }
}
