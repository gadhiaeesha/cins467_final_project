// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../FirebaseAuth/auth.dart';
import '../Pages/home_page.dart';
import '../FirebaseAuth/dialog_auth.dart';

// UI for displaying all content in Drawer with small screens
class Drawers extends StatefulWidget {
  const Drawers({
    Key? key,
  }) : super(key: key);

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 193, 221, 161),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              userEmail == null
                ? Container(
                  width: double.maxFinite,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    //for call and show AuthDialog widget when clicked
                    onPressed: () {
                      showDialog(
                        context: context, 
                        builder: (context) => AuthDialog(),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        bottom: 15.0,
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: 
                        imageUrl != null ? NetworkImage(imageUrl!) : null,
                        child: imageUrl == null
                          ? Icon(
                            Icons.account_circle,
                            size: 40,
                          )
                          : Container(),
                    ),
                    SizedBox(width: 40),
                    Text(
                      name ?? userEmail!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              userEmail != null
                ? Container(
                  width: double.maxFinite,
                  // UI for the Drawer Sign out button
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _isProcessing
                      ? null
                      : () async {
                        setState(() {
                          _isProcessing = true;
                        });
                        await signOut().then((result) {
                          if (kDebugMode) {
                            print(result);
                          }

                          //nav to home
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => HomePage(),
                            ),
                          );
                        }).catchError((error) {
                          if (kDebugMode) {
                            print('Sign Out Error: $error');
                          }
                        });
                        setState(() {
                          _isProcessing = false;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 15.0,
                          bottom: 15.0
                        ),
                        child: _isProcessing
                            ? CircularProgressIndicator()
                            : Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                      ),
                  ),
                )
                : Container(),
              userEmail != null ? SizedBox(height: 20) : Container(),
              InkWell(
                onTap: () {},
                child: Text(
                  'Household',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey[400],
                  thickness: 2,
                ),
              ), 
              InkWell(
                onTap: () {},
                child: Text(
                  'Members',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey[400],
                  thickness: 2,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Developer',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey[400],
                  thickness: 2,
                ),
              ), 
            ]
          ),
        ),
      ),
    );
  }
}