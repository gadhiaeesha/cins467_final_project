import 'package:flutter/material.dart';

class ChoreContainer extends StatefulWidget {
  final int id;
  final String title;
  final Function onPress;

  const ChoreContainer({
    Key? key,
    required this.id,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  @override
  _ChoreContainerState createState() => _ChoreContainerState();
}

class _ChoreContainerState extends State<ChoreContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //alignment: Alignment.centerLeft,
        height: MediaQuery.of(context).size.height / 16,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovered = false;
                    });
                  },
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      onPressed: () => widget.onPress(),
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
