import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum InteractionDirection { incoming, outgoing }

// Adjusted abstract base class with nullable createdDateTime
abstract class Interaction {
  final String sourceName;
  final DateTime? createdDateTime; // Now nullable
  bool isUnread;
  final List<members>? tags;
  final String? summary;

  Interaction({
    required this.sourceName,
    this.createdDateTime,
    this.isUnread = true,
    this.tags,
    this.summary,
  });
}






class DefaultInteraction extends Interaction {
  final String meetingTitle;
  final String address;
  final InteractionDirection direction;
  final members Member;
  final Color color; // Add this to store the color for the interaction

  DefaultInteraction({
    required String sourceName,
    required DateTime createdDateTime,
    required this.meetingTitle,
    bool isUnread = true,
    required this.address,
   // List<members>? tags,
    final String? summary,
    required this.direction,
    required this.Member,
    required this.color, // Initialize the color
  }) : super(
    sourceName: sourceName,
    createdDateTime: createdDateTime,
    isUnread: isUnread,
   // tags: tags,
    summary: summary,
  );
}



class members{
  final String? image;
  final String? fName;
  final String lName;
  final String ? Company;
  members({this.image , this.fName, required this.lName, this.Company});

  String initials() {
    String initials = "";
    if (fName != null && fName!.isNotEmpty) {
      initials += fName![0].toUpperCase();
    }
    if (lName.isNotEmpty) {
      initials += lName[0].toUpperCase();
    }
    return initials;
  }


}


class TimelineSeparator extends StatelessWidget {
  final String dateText;

  TimelineSeparator({required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          SizedBox(width: 26.5),
          Expanded(
            flex: 1,
            child: Divider(color: Color(0xFFB7B7B7), thickness: 2),
          ),
          SizedBox(width: 12),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                dateText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  backgroundColor: Color(0xFF131621),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Divider(color: Color(0xFFB7B7B7), thickness: 2),
          ),
          SizedBox(width: 26.5),
        ],
      ),
    );
  }
}
