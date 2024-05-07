// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:app_practice/Models/chore.dart';
import 'package:app_practice/Models/member.dart';
import 'package:app_practice/Widgets/chore_container.dart';
import 'package:app_practice/Widgets/member_container.dart';
import 'package:flutter/material.dart';
import 'package:app_practice/FirebaseAuth/dialog_auth.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Widgets/responsive.dart';

import '../Widgets/responsive.dart';
import '../Widgets/top_app_bar.dart';
import '../FirebaseAuth/auth.dart';
import '../FirebaseAuth/dialog_auth.dart';
import '../Widgets/drawers.dart';


// UI of Home Page
class HomePage extends StatefulWidget {
  static const String route = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //define variables of grid list items
  /* final List<Map> myProducts = 
    List.generate(10, (index) => {"id": index, "name": "Product $index"})
    .toList(); */

  final double _scrollPosition = 0;
  double _opacity = 0;
  
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<Chores> chores = [];
  int tempIdCount = 0;
  bool displayEvent = false;

  List<Member> members = [];
  int tempMemIdCount = 0;
  /// ************************************************************************************************
  /// Displays Calendar in week view for Home Page                                                   *
  /// ************************************************************************************************
  Widget _displayCalendar() {
    return Center(
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.week,
        calendarStyle: CalendarStyle(
          rangeHighlightColor: Colors.red,
          weekendTextStyle: TextStyle(color: Colors.red)
        ),
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update _focusedDay as well
            displayEvent = true;
          });
        },
      ),
    );
  }

  /// ************************************************************************************************
  /// Displays Master Chores List                                                                    *
  /// ************************************************************************************************
  Widget _displayChoreList(){
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(20),
      //padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 193, 221, 161),
              border: Border(
                bottom: BorderSide(width: 2),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.0),
                topRight: Radius.circular(7.0),
              ),
            ),
            child: const Text(
              'Master Chores List',
              style: TextStyle(
                color: Colors.black, // Text color
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Display chores
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: chores.map((e) {
                  return ChoreContainer(
                    id: e.id,
                    title: e.title,
                    onPress: () => tempDeleteChores(e.id),
                    //desc: e.desc,
                  );
                }).toList(),
              ), 
            ),
          ),
          Expanded(
          child: Container(),
          ), // Added Expanded to push the button to the bottom
          Padding(
            padding: const EdgeInsets.all(8.0), // Adjust top padding as needed
            child: ElevatedButton(
              onPressed: () {
                // ignore: prefer_const_constructors
                showNewChoreForm();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Set rounded corners
                side: const BorderSide(color: Color(0xFF001133)), // Set outline color
              ), 
              child: const Text(
                'Add Chore',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ************************************************************************************************
  /// Displays Members/Residents List                                                                *
  /// ************************************************************************************************
  Widget _displayResidentsList(){
    return Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 4,
        margin: const EdgeInsets.all(20),
        //padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 193, 221, 161),
                border: Border(
                  bottom: BorderSide(width: 2),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7.0),
                  topRight: Radius.circular(7.0),
                ),
              ),
              child: const Text(
                'Members',
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Display chores
            SizedBox(
              height: MediaQuery.of(context).size.height / 7,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: members.map((e) {
                    return MemberContainer(
                      id: e.id,
                      name: e.name,
                    );
                  }).toList(),
                ), 
              ),
            ),
            Expanded(
            child: Container(),
            ), // Added Expanded to push the button to the bottom
            Padding(
              padding: const EdgeInsets.all(8.0), // Adjust top padding as needed
              child: ElevatedButton(
                onPressed: () {
                  // ignore: prefer_const_constructors
                  showNewMemberForm();
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Set rounded corners
                  side: const BorderSide(color: Color(0xFF001133)), // Set outline color
                ), 
                child: const Text(
                  'Add Member',
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  /// ************************************************************************************************
  /// Displays Events/Additional Chore Details only if specific date in calendar has been selected   *
  /// ************************************************************************************************
  Widget _displayEvent(){
    return Visibility(
      visible: displayEvent,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 4,
        margin: const EdgeInsets.all(20),
        //padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 193, 221, 161),
                border: Border(
                  bottom: BorderSide(width: 2),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7.0),
                  topRight: Radius.circular(7.0),
                ),
              ),
              child: const Text(
                'Event',
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showNewChoreForm() {
    String title = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Chore"),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter Chore'
                ),
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
            ),
          ), 
          // Display NewChoreForm widget
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                //newChoreUpload();
                tempAddChores(title);
                Navigator.of(context).pop(); // Close the dialog
                //showNewChoreResult(context); // Show pop-up
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showNewMemberForm() {
    String name = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Member"),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter Member Name'
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),
          ), 
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                tempAddMember(name);
                Navigator.of(context).pop(); // Close the dialog
                //showNewChoreResult(context); // Show pop-up
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void tempAddChores(String title) {
    Chores c = Chores(
      id: tempIdCount,
      title: title,
      desc: "",
      isDone: false,
      date: _focusedDay.toString(),
    );
    chores.add(c);
    setState(() {
      tempIdCount++;
    });
  }

  void tempDeleteChores(int id) {
    for(int i = 0; i < chores.length; i++){
      if (chores[i].id == id){
        chores.removeAt(i);
        break;
      }
    }
    setState(() {});
  }

  void tempAddMember(String name) {
    Member m = Member(
      id: tempMemIdCount,//int.parse(uid!) -> get from firebase,
      name: name,
    );
    members.add(m);
    setState(() {
      tempMemIdCount++;
    });
  }

  @override
  void initState() {
    super.initState();
    tempAddChores("test1");
  }
    @override
    Widget build(BuildContext context) {
      //define var to control width size of parent widget
      var screenSize = MediaQuery.of(context).size;
      _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,

        // call of responsive widget
        appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
            backgroundColor: Colors.lightGreen,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'ChoreNoMore',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          )
          : PreferredSize(
            preferredSize: Size(screenSize.width, 1000), 
            child: TopAppBar(_opacity),
          ),

          // Call Drawers Widget
          drawer: Drawers(),
          body: Center(
            child: userEmail == null
              ? Container(
                    child: Text(
                      'Welcome Everyone!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ), 
                  )
                // AuthDialog()
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "This Week at a Glance:",
                      style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _displayCalendar(),
                  const SizedBox(height: 50),
                  Expanded(
                    child: Row(
                      children: [
                        _displayChoreList(),
                        Column(
                            children: [
                              _displayEvent(),
                              _displayResidentsList(),
                            ],
                          ),

                      ]
                    ),
                  ),
                ]
              )
          ),
      );
    }
}
