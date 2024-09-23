import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import '../../ui/timeline/base/fi_timeline_model.dart';
import '../../ui/utils/fi_ui_elements.dart';
import '../fi_display.dart';
import '../fi_resources.dart';
import 'fi_multi_list_expanded_widget.dart';

//ignore: must_be_immutable

enum FiTimelineSearchType {
  timelineSearch,
  membersSearch
}

class FiTimelineSearchWidget extends FiMultiListExpandedWidget {
  final FiTimelineModel model;
  final FiTimelineSearchType type ;
  FiTimelineSearchWidget({super.key, required this.model, required this.type,super.width, super.height});

  @override
  State<StatefulWidget> createState() => _FiTimelineSearchState();
}

class _FiTimelineSearchState extends State<FiTimelineSearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.type == FiTimelineSearchType.timelineSearch){
      return buildTimelineSearch(context);
    }
    else if(widget.type == FiTimelineSearchType.membersSearch){
      return buildMembersSearch(context);
    }
    else {
      return Container();
    }
  }

  @override
  Widget buildTimelineSearch(BuildContext context) {
    ConstraintId id = ConstraintId("_FiTimelineSearchState_$hashCode");
    return ConstraintLayout(
      width: display.width - 27,
      height: toY(80),
      children: [
        //Container(height: toY(100),color:  Colors.blue).applyConstraint(zIndex:100,left: parent.left,right: parent.right,top:parent.top,bottom: parent.bottom),
        CircleAvatar(
          radius: toX(30),
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: SizedBox(width: toX(70), height: toX(70), child: Image(image: const AssetImage("assets/images/clear_all.png"), color: Colors.white, width: toX(70), height: toX(70))),
          ),
        ).applyConstraint(zIndex:101,id: id, right: parent.right, top: parent.top, bottom: parent.bottom, width: toX(70), height: toX(70)),
        Padding(
            padding: EdgeInsets.only(right: toX(0)),
            child: TextFormField(
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(14),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localise("timeline_search"),
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: toY(14),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: const Image(
                  image: AssetImage("assets/images/timeline_search.png"),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                isCollapsed: false,
                filled: true,
                fillColor: const Color(0xFF131621),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(toX(10)),
                  borderSide: const BorderSide(color: Color(0xffD3D3D3)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(toX(10)),
                  borderSide: const BorderSide(color: Color(0xffD3D3D3)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(toX(10)),
                  borderSide: const BorderSide(color: Color(0xffD3D3D3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(toX(10)),
                  borderSide: const BorderSide(color: Color(0xffD3D3D3)),
                ),
              ),
            )).applyConstraint(zIndex:102,left: parent.left, right: id.left, top: parent.top, bottom: parent.bottom, width: matchConstraint),

        const Divider(
          height: 1,
          color: Color(0x33B2B1B1),
        ).applyConstraint(zIndex:100,bottom: parent.bottom, left: parent.left, right: parent.right, width: matchConstraint)

        // Container(
        //   height: 1,
        //   decoration: ShapeDecoration(
        //     color: const Color(0x33B2B1B1),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(50),
        //     ),
        //   ),
        // ).applyConstraint(zIndex:100,bottom: parent.bottom, left: parent.left, right: parent.right, width: matchConstraint)
      ],
    );
  }

  Widget buildMembersSearch(BuildContext context) {
    return  uiElements.inputField(
        controller: widget.model.searchController,
        onChange: widget.model.onSearch,
        borderRadius: 10,
        backgroundColor: Colors.transparent,
        prefixIcon: const Image(image: AssetImage("assets/images/search.png")),
        suffixIcon: widget.model.inSearch ? const Icon(Icons.clear) : null,
        sufficsIconClick: () {
          display.closeKeyboard();
          widget.model.stopSearch?.call();
        },
        hintText: localise("search"),
        hintStyle: TextStyle(
          color: const Color(0xFFB6B6B6),
          fontSize: toY(14),
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        )) ;
  }
}
