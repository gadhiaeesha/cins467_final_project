// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

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
  final List<Map> myProducts = 
    List.generate(10, (index) => {"id": index, "name": "Product $index"})
    .toList();

  final double _scrollPosition = 0;
  double _opacity = 0;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  
  bool isSignedIn = false;

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
            //displayEvent = true;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
              ? AuthDialog()/* Container(
                    child: Text(
                      'Welcome Everyone!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ), 
                  ) */

              //UI in grid view list
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
                ]
              )
              /* GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisExtent: 20
                ),
                itemCount: myProducts.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(myProducts[index]["name"]),
                    ),
                  );
                },
              ), */
          ),
      );
    }

}