import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import '../../ui/navigationbar/contacts/fi_contact.dart';
import '../../ui/utils/fi_ui_elements.dart';
import '../fi_display.dart';
import 'fi_multi_list_expanded_widget.dart';

//ignore: must_be_immutable

typedef OnGroupListItemClickCallback = void Function(dynamic item);

//ignore: must_be_immutable
class FiMultiListExpandedMemberList extends FiMultiListExpandedWidget {
  List<FiContact> members;
  OnGroupListItemClickCallback callback;

  FiMultiListExpandedMemberList({super.key, required this.members, required this.callback}){
    int rowsCount = (members.length /4).round() ;
    rowsCount = min(rowsCount, 3) ;
    height = rowsCount*toY(80) +  toY(80) ;
  }

  @override
  State<StatefulWidget> createState() => _FiMultiListExpandedGroupsList();
}

class _FiMultiListExpandedGroupsList extends State<FiMultiListExpandedMemberList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.members.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        FiContact member = widget.members[index];
        ConstraintId logoId = ConstraintId("logo_${index}_${member.name}");
        return InkWell(
            onTap: () {
              widget.callback.call(member);
            },
            child: ConstraintLayout(
              width: toX(35),
              height: toX(45),
              children: [
                uiElements.avatar(member).applyConstraint(id: logoId, left: parent.left, right: parent.right, top: parent.top, width: toX(35), height: toX(35)),
                Padding(padding: EdgeInsets.only(top:toY(5)),child:Text(
                  member.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: toY(10),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                )).applyConstraint(left: parent.left, right: parent.right, top: logoId.bottom)
              ],
            ));
      },
    );
  }
}
