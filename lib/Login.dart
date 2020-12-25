import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:garage_sale/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_sale/HomePage.dart';

class Login extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  Login({
    this.auth,
    this.onSignedIn,
  });

  State<StatefulWidget> createState() {
    return new _LoginState();
  }
}

enum FormType { login, register }

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;

  String _email = "";
  String _password = "";

  ///////////////////////👇
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    print(getCurrentUser());
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new HomePage()),
    );
    return getCurrentUser();
  }

  Future<String> signUp(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    print(getCurrentUser());
    // 不知道为啥这个路由不好使
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new HomePage()),
    );
    return getCurrentUser();
  }

  Future<String> getCurrentUser() async {
    return _firebaseAuth.currentUser.uid;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
  /////////////////////////👆

  // methods
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await signIn(_email, _password);
          print("login userId ============== " + userId);
        } else {
          String userId = await signUp(_email, _password);
          print("Register userId ============ " + userId);
        }
        widget.onSignedIn();
        // onSignedIn();
      } catch (e) {
        print("Error ============= " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  // design
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Garage Sale Login"),
        backgroundColor: Colors.blueGrey,
      ),
      body: new Container(
        margin: EdgeInsets.all(15.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButton(),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(height: 10.0),
      // logo(),
      SizedBox(height: 20.0),
      new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) {
            return value.isEmpty ? 'Email is required. ' : null;
          },
          onSaved: (value) {
            return _email = value;
          }),
      SizedBox(height: 10.0),
      new TextFormField(
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) {
            return value.isEmpty ? 'Password is required. ' : null;
          },
          onSaved: (value) {
            return _password = value;
          }),
      SizedBox(height: 20.0),
    ];
  }

  Widget logo() {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('images/lion.jpg'),
      ),
    );
  }

  List<Widget> createButton() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          color: Colors.blueGrey,
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text("Not have an Account? Create Account",
              style: new TextStyle(fontSize: 14.0)),
          textColor: Colors.blueGrey,
          // color: Colors.blueGrey
          onPressed: moveToRegister,
        ),
      ];
    } else {
      // register status
      return [
        new RaisedButton(
          child:
              new Text("Create Account", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          color: Colors.blueGrey,
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text("Already have an Account? Login",
              style: new TextStyle(fontSize: 14.0)),
          textColor: Colors.blueGrey,
          // color: Colors.blueGrey
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
