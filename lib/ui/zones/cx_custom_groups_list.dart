
import 'package:flutter/material.dart';

import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import '../groups/fi_group.dart';
import '../groups/newgroup/fi_new_group.dart';
import '../utils/fi_ui_elements.dart';
import 'cx_custom_groups_model.dart';


class CxCustomGroupsListWidget extends FiBaseWidget {
  CxCustomGroupsListWidget({super.key});
  FiApplicationStates backState =  FiApplicationStates.myZones;
  @override
  Future<bool> get onWillPop {
    applicationModel.currentState = backState;
    return Future.value(false);
  }

  @override
  setParams(params) {
    if(params is Map<String,dynamic>){
      backState = params[kBackState]??  FiApplicationStates.myZones;
    }
  }

  @override
  State<StatefulWidget> createState() => _CxCustomGroupsListState();
}

class _CxCustomGroupsListState extends FiBaseState<CxCustomGroupsListWidget> {
  @override
  void initState() {
    customGroupsModel.setState(this);
    super.initState();
  }

  @override
  void dispose() {
    customGroupsModel.setState(null);
    super.dispose();
  }

  @override
  // TODO: implement content
  Widget get content => Stack(
    children: [
      uiElements.backButton(() async => await widget.onWillPop),
      Positioned(
          top: toY(85),
          left: 0,
          right: 0,
          child: Center(
              child: Text(
                localise("groups"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: toY(30),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.60,
                ),
              ))),
      if (customGroupsModel.isNotEmpty) Positioned(top: toY(88), left: toX(373), width: toX(41), height: toX(41), child: uiElements.popupMenu(_items(), Image(image: const AssetImage("assets/images/menu_dots.png"), width: toX(32), height: toX(32)), BoxConstraints.tightFor(width: toX(200)), Offset(0, toY(40)))),
      if (customGroupsModel.isNotEmpty)
        Positioned(
            left: toX(28),
            top: toY(150),
            width: toX(359),
            height: toY(44),
            child: uiElements.inputField(
                controller: customGroupsModel.groupSearchController,
                onChange: customGroupsModel.onSearch,
                borderRadius: 10,
                backgroundColor: Colors.transparent,
                prefixIcon: const Image(image: AssetImage("assets/images/search.png")),
                suffixIcon: customGroupsModel.inSearch ? const Icon(Icons.clear) : null,
                sufficsIconClick: () {
                  display.closeKeyboard();
                  customGroupsModel.stopSearch.call();
                },
                hintText: localise("search"),
                hintStyle: TextStyle(
                  color: const Color(0xFFB6B6B6),
                  fontSize: toY(14),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ))),
      if (customGroupsModel.isNotEmpty)
        Positioned(
            top: toY(214),
            left: toX(35),
            child: Text(
              "${localise("groups")} (${customGroupsModel.groupCount})",
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(15),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.30,
              ),
            )),
      if (customGroupsModel.isNotEmpty)
        Positioned(
            top: toY(260),
            bottom: toY(20),
            left: toX(35),
            right: toX(35),
            child: ListView.builder(
                itemCount: customGroupsModel.groupCount + 1,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(padding: EdgeInsets.only(top: toY(index -1 < customGroupsModel.groupCount  ? 20 : 40)), child: listItem(index)) ;
                })),
      if (customGroupsModel.isEmpty)
        Positioned(
            top: (display.height - toY(246)) / 2,
            left: display.width / 2 - toX(327) / 2,
            width: toX(327),
            height: toY(246),
            child: Container(
              width: toX(327),
              height: toY(246),
              decoration: ShapeDecoration(
                color: const Color(0xFF292D36),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0xFF0677E8)),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: noGroupsPopup(),
            ))
    ],
  );


  Widget listItem(int index){
    int count = customGroupsModel.groupCount ;
    if(index < count) {
      final FiGroup group = customGroupsModel.groupAtIndex(index ) ;
      return uiElements.listButton(group.fullName!, null, onTap: (){
        customGroupsModel.showTimeLineForGroup(group);
      });
    }
    else  if(index == count){
      return uiElements.addItem(title: localise("create_new_group"), onAdd: (){
        applicationModel.setCurrentStateWithParams(FiApplicationStates.newGroup, {kBackState:FiApplicationStates.customGroupsList,kGroupType:FiGroupType.group,kActionInPlace:true}) ;
      }) ;
    }
    return Container();
  }

  List<PopupMenuItem> _items() {
    List<PopupMenuItem> list = <PopupMenuItem>[];
    list.add(uiElements.pageMenuItem(
        localise("create_group"),
        Image(
          image: const AssetImage("assets/images/organization_group.png"),
          width: toX(20),
          height: toY(18),
        ),
            (){
          applicationModel.setCurrentStateWithParams(FiApplicationStates.newGroup, {kBackState:FiApplicationStates.customGroupsList,kGroupType:FiGroupType.custom,kActionInPlace:true}) ;
        }));



    return list;
  }

  Widget get noGroupsText {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: localise("no"),
            style: TextStyle(
              color: Colors.white,
              fontSize: toY(20),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 0.06,
            ),
          ),
          TextSpan(
            text: " ${localise("groups_yet")}",
            style: TextStyle(
              color: Colors.white,
              fontSize: toY(20),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 0.06,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    ) ;
  }

  Widget noGroupsPopup() {
    return Stack(
      children: [
        Positioned(
            top: toY(22),
            left: 0,
            right: 0,
            child: Center(
                child: noGroupsText)),
        Positioned(
            top: toY(65),
            left: toX(118),
            right: toX(118),
            child: SizedBox(
                width: toX(50),
                height: toY(50),
                child: const Image(
              image: AssetImage("assets/images/groups_symbol.png"),
              fit: BoxFit.contain,
            ))),
        Positioned(
            top: toY(140),
            left: 0,
            right: 0,
            child: Center(
                child: Text(
                  localise("please_create_one"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFE4E5E6),
                    fontSize: toY(15),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0.09,
                  ),
                ))),

        Positioned(
            left: toX(24),
            bottom: toY(21),
            width: toX(134),
            height: toY(48),
            child: uiElements.button(localise("cancel").toUpperCase(), () async {
              await widget.onWillPop ;
            }, enabledColor: const Color(0x192281E3), radius: 32)),
        Positioned(
            right: toX(24),
            bottom: toY(21),
            width: toX(134),
            height: toY(48),
            child: uiElements.button(localise("create").toUpperCase(), () {
              applicationModel.setCurrentStateWithParams(FiApplicationStates.newGroup, {kBackState:FiApplicationStates.customGroupsList,kGroupType:FiGroupType.custom,kActionInPlace:true}) ;
            }, radius: 32)),
      ],
    );
  }
}
