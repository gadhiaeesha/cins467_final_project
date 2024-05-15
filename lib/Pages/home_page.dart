// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:app_practice/Models/chore.dart';
import 'package:app_practice/Models/member.dart';
import 'package:app_practice/Widgets/chore_container.dart';
import 'package:app_practice/Widgets/member_container.dart';
import 'package:flutter/material.dart';
import 'package:app_practice/FirebaseAuth/dialog_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';

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

  final double _scrollPosition = 0;
  double _opacity = 0;
  
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  List<Chores> chores = [];
  int tempIdCount = 0;
 

  List<Member> members = [];
  int tempMemIdCount = 0;

  List<String> houses = ['House 1'];
  String? selectedHouse;
  

  /// ************************************************************************************************
  /// Functions for Calendar                                                                          *
  /// ************************************************************************************************
  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }
  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOn;
        //displayEvent = true;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }
  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
      //displayEvent = true;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }
  
  /// ************************************************************************************************
  /// Displays Calendar for Home Page                                                                *
  /// ************************************************************************************************
  Widget _displayCalendar(){
    return TableCalendar<Event>(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
      eventLoader: _getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        // Use `CalendarStyle` to customize the UI
        outsideDaysVisible: false,
        selectedDecoration: BoxDecoration(
          color: Color.fromARGB(255, 156, 188, 119), // Change the color to your desired color
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Color.fromARGB(255, 156, 188, 119), // Change the color to your desired color
          shape: BoxShape.circle,
        ),
      ),
      onDaySelected: _onDaySelected,
      onRangeSelected: _onRangeSelected,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
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
        border: Border.all(width: 2),
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
                bottom: BorderSide(width: 1),
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
            height: MediaQuery.of(context).size.height / 2.5,
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
                backgroundColor: Color.fromARGB(255, 193, 221, 161),
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
  /// Displays Events/Deadlines                                                                      *
  /// ************************************************************************************************
  Widget _displayCalEvent(){
      return Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 2,
        margin: const EdgeInsets.all(20),
        //padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 2),
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
                  bottom: BorderSide(width: 1),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7.0),
                  topRight: Radius.circular(7.0),
                ),
              ),
              child: const Text(
                'Upcoming Deadlines/Events',
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
            child: Container(
              child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('${value[index]}'),
                              backgroundColor: Color.fromARGB(255, 208, 250, 161),
                              contentPadding: EdgeInsets.only(top: 15),
                              content: Container(
                                padding: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17), bottomRight: Radius.circular(17)),
                                ),
                                child: SizedBox(
                                  height: (MediaQuery.of(context).size.height / 3) + 10,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: SizedBox(
                                    height: (MediaQuery.of(context).size.height / 3),
                                    width: MediaQuery.of(context).size.width / 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Description",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(height:15),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "*Insert Event/Chore Description*",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ), 
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
            ),
            ),
          ],
        ),
      );
  }

  /// ************************************************************************************************
  /// Add Chore Pop-Up                                                                               *
  /// ************************************************************************************************
  void showNewChoreForm() {
  String title = "";
  String? selectedMember;

  // Sample list of members - adjust to reflect current members in household
  List<String> members = ['Member 1', 'Member 2', 'Member 3', 'None'];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Add New Chore"),
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
                    decoration: InputDecoration(labelText: 'Enter Chore'),
                    onChanged: (value) {
                      // Update the new household name as the user types
                      title = value;
                    },
                  ),
                  SizedBox(height: 50),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Assigned Member', contentPadding: EdgeInsets.symmetric(vertical: 20)),
                    value: selectedMember,
                    onChanged: (newValue) {
                      setState(() {
                        selectedMember = newValue;
                      });
                    },
                    items: members.map((member) {
                      return DropdownMenuItem(
                        value: member,
                        child: Text(member),
                      );
                    }).toList(),
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
                          // Handle creation of new chore
                          // Add the new chore
                          if (title.isNotEmpty && selectedMember != null) {
                            tempAddChores(title);
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
      date: DateTime.now(),
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

  void tempAddHouse(String name) {
    houses.add(name);
  }

  void _checkSelectedHouse() {
    if (userEmail != null && selectedHouse == null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _showHouseSelectionDialog();
      });
   }
  }

  void _showHouseSelectionDialog() {
    String CurHouse = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
        title: const Text("Primary Household Not Selected"),
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
                  Text(
                    'Please Select or Add a Household to Proceed.'
                  ),
                  SizedBox(height: 50),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Household', contentPadding: EdgeInsets.symmetric(vertical: 20)),
                    value: selectedHouse,
                    onChanged: (newValue) {
                      CurHouse = newValue!;
                      setState(() {
                        selectedHouse = newValue;
                      });
                    },
                    items: houses.map((house) {
                      return DropdownMenuItem(
                        value: house,
                        child: Text(house),
                      );
                    }).toList(),
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
                          // Handle creation of new chore
                          // Add the new chore
                          if (selectedHouse != null) {
                            tempAddHouse(CurHouse);
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 208, 250, 161), // Same color as the title
                        ),
                        child: Text('Enter', style: TextStyle(color: Colors.black)),
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

  @override
  void initState() {
    super.initState();
    tempAddChores("Laundry");
    tempAddChores("Dishes");
    tempAddChores("Kitchen");
    tempAddChores("Trash");
    tempAddChores("Sweep/Mop");
    tempAddChores("Bathroom");
     _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _checkSelectedHouse();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
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
            'NoMoreChores',
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
          child: TopAppBar(
            _opacity, 
            onHouseSelected: (house) {
              setState(() {
                selectedHouse = house;
              });
            },
          ),
        ),

        // Call Drawers Widget
        drawer: userEmail != null ? Drawers() : null,
        body: Center(
          child: userEmail == null
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to NoMoreChores!',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Log In to Get Started!',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                AuthDialog(), // Call AuthDialog if userEmail is null
              ],
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "This Week at a Glance",
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _displayCalendar(),
                const SizedBox(height: 50),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _displayChoreList(),
                      _displayCalEvent(),
                    ]
                  ),
                ),
              ]
            )
        ),
    );
  }
}
