import 'package:flutter/material.dart';

class MemberContainer extends StatefulWidget {
  final int id;
  final String name;

  const MemberContainer({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);

  @override
  _MemberContainerState createState() => _MemberContainerState();
}

class _MemberContainerState extends State<MemberContainer> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //alignment: Alignment.centerLeft,
        height: MediaQuery.of(context).size.height / 16,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  onPressed: (){

                  },
                  icon: const Icon(
                    Icons.folder_open_outlined
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
