// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import '../Widgets/google_sign_in_button.dart';
import '../Pages/home_page.dart';

/// Building the AuthDialog UI

class AuthDialog extends StatefulWidget {
  @override
  _AuthDialogState createState() => _AuthDialogState();
} 

class _AuthDialogState extends State<AuthDialog> {
  late TextEditingController textControllerEmail;
  late FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;

  late TextEditingController textControllerPassword;
  late FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;

  bool _isRegistering = false;
  bool _isLoggingIn = false;

  String? loginStatus;
  Color loginStringColor = Colors.green;

  // method to validate email address
  String? _validateEmail(String value) {
    value = value.trim();
    if (textControllerEmail.text.isNotEmpty){
      if (value.isEmpty) {
      return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
        r"^[a-zA-Z0-9,a-zA-z0-9,!#$%&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
      ))) {
        return 'Enter a valid email address';
      }
    }
    return null;
  }

  // method to validate email address
  String? _validatePassword(String value) {
    value = value.trim();
    if (textControllerEmail.text.isNotEmpty){
      if (value.isEmpty) {
      return 'Password can\'t be empty';
      } else if (value.length < 8) {
        return 'Weak Password: Length of password should be greater than 8';
      }
    }
    return null;
  }

  // initialize
  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textControllerEmail.text = '';
    textControllerPassword.text = '';
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      //backgroundColor: Color.fromARGB(255, 193, 221, 161),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
            width: 400,
            //color: Color.fromARGB(255, 193, 221, 161),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                      color: Color.fromARGB(255, 193, 221, 161),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Sign In/Sign Up',
                      style: TextStyle(
                        color: Theme
                          .of(context)
                          .textTheme
                          .displayLarge!
                          .color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  )
                ),
                SizedBox(height: 30),

                /// TextField for Email
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'Email Address',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: TextField(
                    focusNode: textFocusNodeEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: textControllerEmail,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingEmail = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodeEmail.unfocus();
                      FocusScope.of(context)
                        .requestFocus(textFocusNodeEmail);
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800]!,
                          width: 3,
                        )
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                        color: Colors.blueGrey[300]
                      ),
                      hintText: 'Email',
                      fillColor: Colors.white,
                      errorText: _isEditingEmail
                        ? _validateEmail(textControllerEmail.text)
                        : null,
                        errorStyle: TextStyle(
                          fontSize: 12, 
                          color: Colors.redAccent,
                        )
                    ),
                  )
                ),
                SizedBox(height: 20),

                /// TextField for Password
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: TextField(
                    focusNode: textFocusNodePassword,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: textControllerPassword,
                    obscureText: true,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingPassword = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodePassword.unfocus();
                      FocusScope.of(context)
                        .requestFocus(textFocusNodePassword);
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800]!,
                          width: 3,
                        )
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                        color: Colors.blueGrey[300]
                      ),
                      hintText: 'Password',
                      fillColor: Colors.white,
                      errorText: _isEditingPassword
                        ? _validatePassword(textControllerPassword.text)
                        : null,
                        errorStyle: TextStyle(
                          fontSize: 12, 
                          color: Colors.redAccent,
                        )
                    ),
                  )
                ),

                /// Login and Sign Up Buttons
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: double.maxFinite,

                          /// UI of Log in button to sign in w/ Email & Pass
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)
                              )
                            ),
                            onPressed: () async {
                              setState(() {
                                _isLoggingIn = true;
                                textFocusNodeEmail.unfocus();
                                textFocusNodePassword.unfocus();
                              });
                              if (_validateEmail(textControllerEmail.text) == null &&
                              _validatePassword(textControllerPassword.text) == null) {
                                await signInWithEmailPass(
                                  textControllerEmail.text, 
                                  textControllerPassword.text)
                                  .then((result) {
                                  if (result != null) {
                                    if (kDebugMode) {
                                      print(result);
                                    }
                                    setState(() {
                                      loginStatus = 'You have successfully logged in';
                                      loginStringColor = Colors.green;
                                    });

                                    Future.delayed(Duration(milliseconds: 500), () {
                                      //Navigator.of(context).pop();

                                      // navigating to home page after sign in
                                      Navigator
                                        .of(context)
                                        .pushReplacement(MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) => HomePage(),
                                        )
                                        ); });
                                  }
                                }).catchError((error) {
                                  if (kDebugMode) {
                                    print('Login Error: $error');
                                  }
                                  setState(() {
                                    loginStatus = 'Error occured while logging in';
                                    loginStringColor = Colors.red;
                                  });
                                });
                              } else {
                                setState(() {
                                  loginStatus = 'Please enter email & password';
                                  loginStringColor = Colors.red;
                                });
                              }
                              setState(() {
                                _isLoggingIn = false;
                                textControllerEmail.text = '';
                                textControllerPassword.text = '';
                                _isEditingEmail = false;
                                _isEditingPassword = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 15.0,
                                bottom: 15.0,
                              ),
                              child: _isLoggingIn ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                                : Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  )
                                )
                            )
                          )
                        ),
                      ),
                      SizedBox(width: 20),

                      // UI of Sign Up Button to register with Email and Password
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: double.maxFinite,

                          /// UI of Log in button to sign in w/ Email & Pass
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)
                              )
                            ),
                            onPressed: () async {
                              setState(() {
                                _isRegistering = true;
                              });
                                await registerWithEmailPass(
                                  textControllerEmail.text, 
                                  textControllerPassword.text)
                                  .then((result) {
                                  if (result != null) {
                                    setState(() {
                                      loginStatus = 'You have registered successfully';
                                      loginStringColor = Colors.green;
                                    });
                                    if (kDebugMode) {
                                      print(result);
                                    }
                                  }
                                }).catchError((error) {
                                  if (kDebugMode) {
                                    print('Registration Error: $error');
                                  }
                                  setState(() {
                                    loginStatus = 'Error occured while registering';
                                    loginStringColor = Colors.red;
                                  });
                                });
                              
                              setState(() {
                                _isRegistering = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 15.0,
                                bottom: 15.0,
                              ),
                              child: _isRegistering ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                                : Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  )
                                )
                            )
                          )
                        ),
                      ),
                    ],
                  )
                ),
                loginStatus != null
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20.0,
                      ),
                      child: Text(
                        loginStatus!,
                        style: TextStyle(
                          color: loginStringColor,
                          fontSize: 14,
                        )
                      ),
                    )
                  )
                  : Container(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                  ),
                  child: Container(
                    height: 1,
                    width: double.maxFinite,
                    color: Colors.blueGrey[200],
                  ),
                ),
                SizedBox(height: 30),

                // Call the Widget of Google Sign-In Button
                Center(child: GoogleButton()),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  /* child: Text(
                    'By continuing with Google, you agree to the Terms and Conditions',
                    maxLines: 2,
                    style: TextStyle(
                      color: Theme
                        .of(context)
                        .textTheme
                        .titleSmall!
                        .color,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    )
                  ), */
                ),
              ]
            )
          )
        

    );
  }
}