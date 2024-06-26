// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import '../FirebaseAuth/auth.dart';
import '../Pages/home_page.dart';
import '../FirebaseAuth/dialog_auth.dart';

// UI of TopAppBar
class TopAppBar extends StatefulWidget {
  final double opacity;
  final Function(String?) onHouseSelected; // Callback function

  TopAppBar(this.opacity, {required this.onHouseSelected});

  @override
  _TopAppBarState createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  bool _isProcessing = false;
  List<String> householdOptions = ['College Apartment', 'Home', 'Vacation - AirBnB']; // List of household options

  String? selectedHouse; // Selected house

  // Method to update selectedHouse
  void updateSelectedHouse(String? house) {
    setState(() {
      selectedHouse = house;
    });
    // Call the callback function and pass selectedHouse
    widget.onHouseSelected(selectedHouse);
  }

  void _showNewHouseholdDialog() {
    String newHouseholdName = ''; // Variable to store the new household name

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Household'),
          backgroundColor: Color.fromARGB(255, 208, 250, 161),
          contentPadding: EdgeInsets.only(top: 15),
          content: Container(
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17), bottomRight: Radius.circular(17)),
            ),
            child: SizedBox(
              height: (MediaQuery.of(context).size.height / 3.5) + 10,
              width: MediaQuery.of(context).size.width / 2,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Household Name'),
                      onChanged: (value) {
                        // Update the new household name as the user types
                        newHouseholdName = value;
                      },
                    ),
                    SizedBox(height: 50),
                    TextField(
                      decoration: InputDecoration(labelText: 'Members'),
                      onChanged: (value) {
                        // Handle changes in Members list 
                        // Members are initialized with no chores assigned to them
                      },
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel', style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle creation of new household
                            // Add the new household to the list of options
                            if (newHouseholdName.isNotEmpty) {
                              householdOptions.add(newHouseholdName);
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 208, 250, 161), // Same color as the title
                          ),
                          child: Text('Create', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showMemberProfile(String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$name's Profile"),
          backgroundColor: Color.fromARGB(255, 208, 250, 161),
          contentPadding: EdgeInsets.only(top: 15),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17), bottomRight: Radius.circular(17)),
            ),
            child: SizedBox(
              height: (MediaQuery.of(context).size.height / 3) + 10,
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  SizedBox(height:10),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.height / 3),
                        width: MediaQuery.of(context).size.width / 4,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Text(
                                "Tasks",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height:15),
                              Container(
                            //padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              height: (MediaQuery.of(context).size.height / 4) + 20,
                              width: MediaQuery.of(context).size.height / 5,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ListView(
                                shrinkWrap: true,
                                children: [
                                  ListTile(
                                    title: Text("Event 1"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Description of Task 1"),
                                        Text("Must Done By: [Date]"),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Event 2"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Description of Task 2"),
                                        Text("Must Done By: [Date]"),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Event 3"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Description of Task 3"),
                                        Text("Must Done By: [Date]"),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Event 4"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Description of Task 4"),
                                        Text("Must Done By: [Date]"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ),
                            ),
                          ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Contact Info",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height:15),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Phone: 123-456-7890\nEmail: example@example.com",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Events",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            //padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 6,
                              width: MediaQuery.of(context).size.height / 5,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ListView(
                                shrinkWrap: true,
                                children: [
                                  ListTile(
                                    title: Text("Event 1"),
                                    subtitle: Text("Description of Event 1"),
                                  ),
                                  ListTile(
                                    title: Text("Event 2"),
                                    subtitle: Text("Description of Event 2"),
                                  ),
                                  ListTile(
                                    title: Text("Event 3"),
                                    subtitle: Text("Description of Event 2"),
                                  ),
                                  ListTile(
                                    title: Text("Event 4"),
                                    subtitle: Text("Description of Event 2"),
                                  ),
                                  ListTile(
                                    title: Text("Event 5"),
                                    subtitle: Text("Description of Event 2"),
                                  ),
                                  // Add more ListTiles for tasks as needed
                                ],
                              ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(screenSize.width, 1000),
      child: Container(
        color: Colors.lightGreen,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "NoMoreChores",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (userEmail != null)
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          // adjust HomePage contents to reflect different households different chores
                          if (value == 'New Household') {
                            // Show dialogue for creating a new household
                            _showNewHouseholdDialog();
                          } else {
                            // Adjust HomePage contents to reflect different households different chores
                            setState(() {
                              selectedHouse = value;
                            });
                          }
                        },
                        surfaceTintColor: Colors.lightGreen,
                        itemBuilder: (BuildContext context) {
                          return householdOptions.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Text(value),
                                  if (selectedHouse == value) // Show check mark if selected
                                    Icon(Icons.check),
                                ],
                              ),
                            );
                          }).toList() +
                          [
                            PopupMenuItem<String>(
                              value: 'New Household',
                              child: Row(
                                children: [
                                  Icon(Icons.add), // Add icon
                                  SizedBox(width: 5), // Add spacing
                                  Text('New Household'),
                                ],
                              ),
                            ),
                          ];
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Household',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    if (userEmail != null)
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          // adjust HomePage contents to reflect different households different chores
                          //print('Selected item: $value');
                          showMemberProfile(value);
                        },
                        surfaceTintColor: Colors.lightGreen,
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Member 1',
                              child: Text('Member 1'),
                            ),
                            PopupMenuItem<String>(
                              value: 'Member 2',
                              child: Text('Member 2'),
                            ),
                            PopupMenuItem<String>(
                              value: 'Member 3',
                              child: Text('Member 3'),
                            ),
                            PopupMenuItem<String>(
                              value: 'Add Member',
                              child: Row(
                                children: [
                                  Icon(Icons.add), // Add icon
                                  SizedBox(width: 5), // Add spacing
                                  Text('Add Member'),
                                ],
                              ),
                            ),
                            // Add more PopupMenuItem as needed
                          ];
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Members',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: screenSize.width / 60),

              /// To show the Sign In button only when the user is not signed in already
              
              if (userEmail != null)
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl!)
                      : null,
                    child: imageUrl == null
                      ? Icon(
                        Icons.account_circle,
                        size: 30,
                      )
                      : Container(),
                  ),
                  SizedBox(width: 5),
                  Text(
                    name ?? userEmail!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                    // UI for the Sign out button
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isProcessing
                      ? null
                      : () async {
                        setState(() {
                          _isProcessing = true;
                        });
                        await signOut().then((result) {
                          print(result);

                          //nav to home
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => HomePage(),
                            ),
                          );
                        }).catchError((error) {
                          print('Sign Out Error: $error');
                        });
                        setState(() {
                          _isProcessing = false;
                        });
                    }, 
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
