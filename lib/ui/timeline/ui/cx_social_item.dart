import 'package:flutter/cupertino.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

import '../../../backend/models/cx_timeline_item.dart';
import '../../../utils/fi_display.dart';


class FiSocialItemUx extends StatelessWidget {
  final FiTimelineItem item;

  const FiSocialItemUx({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    ConstraintId titleId = ConstraintId("titleId_${hashCode}_CxCalendarItem");
    bool incomming = item.incoming ;
    return Padding(padding:EdgeInsets.only(left: toX(incomming?24:0),right: toX(incomming?0:24),top: toY(20),) , child:ConstraintLayout(
      width: display.width - 20,
      height: toY(120),
      children: [
         RotatedBox(quarterTurns: incomming ? 0 : 135,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(toX(15)),
                  bottomLeft: Radius.circular(toX(15)),
                  bottomRight: Radius.circular(toX(15)),
                ),
                border: const Border(
                  left: BorderSide(width: 0.25, color: Color(0xFF25D366)),
                  top: BorderSide(width: 1.50, color: Color(0xFF25D366)),
                  right: BorderSide(width: 1.50, color: Color(0xFF25D366)),
                  bottom: BorderSide(width: 0.25, color: Color(0xFF25D366)),
                ),
              ),
            )).applyConstraint(left: parent.left, top: parent.top, right: parent.right, bottom: parent.bottom, width: matchConstraint),
        Padding(
          padding: EdgeInsets.only(top: toY(10), left: toX(15)),
          child: Text(
            item.title,
            style: TextStyle(
              color: const Color(0xFFB6B6B6),
              fontSize: toY(10),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 1.60,
            ),
          ),
        ).applyConstraint(id: titleId, left: parent.left, top: parent.top),
        Padding(padding: EdgeInsets.only(top: toY(10), left: toX(15)), child: const Image(image: AssetImage("assets/images/timeline_calendar.png"))).applyConstraint(left: titleId.left, top: parent.top, bottom: parent.bottom, width: toX(59), height: toX(59))
      ],
    ));
  }
}
