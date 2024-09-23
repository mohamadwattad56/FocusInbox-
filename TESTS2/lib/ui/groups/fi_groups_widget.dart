
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import '../utils/fi_ui_elements.dart';
import 'fi_groups_model.dart';
import 'fi_group.dart';

class CxGroupsWidget extends FiBaseWidget {
  const CxGroupsWidget({super.key});

  @override
  Future<bool> get onWillPop {
    applicationModel.currentState = FiApplicationStates.myZones;
    return Future.value(false);
  }

  @override
  State<StatefulWidget> createState() => _CxGroupsState();
}

class _CxGroupsState extends FiBaseState<CxGroupsWidget> {
  @override
  void initState() {
    super.initState();
    groupsModel.setState(this);
  }

  @override
  void dispose() {
    groupsModel.setState(null);
    super.dispose();
  }

  @override
  Widget get content {
    return Stack(
      children: [
        uiElements.backButton(() async {
          await widget.onWillPop ;
        }),
        Positioned(
            top: toY(98),
            left: toX(374),
            width: toX(25),
            height: toY(25),
            child: uiElements.popupMenu(
                _pageMenu(),
                const Image(
                  image: AssetImage("assets/images/menu_dots.png"),
                ),
                BoxConstraints.tightFor(width: toX(170)),
                Offset(0, toY(30)))),
        Positioned(
            top: toY(85),
            left: toX(88),
            width: toX(238),
            height: toY(45),
            child: Text(
              localise("custom_groups"),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(30),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            )),
        Positioned(
            left: toX(28),
            top: toY(150),
            width: toX(359),
            height: toY(44),
            child: uiElements.inputField(
                controller: groupsModel.groupsSearchController,
                onChange: groupsModel.onSearch,
                borderRadius: 10,
                backgroundColor: Colors.transparent,
                prefixIcon: const Image(image: AssetImage("assets/images/search.png")),
                suffixIcon: groupsModel.inSearch ? const Icon(Icons.clear) : null,
                sufficsIconClick: () {
                  display.closeKeyboard();
                  groupsModel.stopSearch.call();
                },
                hintText: localise("search"),
                hintStyle: TextStyle(
                  color: const Color(0xFFB6B6B6),
                  fontSize: toY(14),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ))),
        Positioned(
            top: toY(210),
            left: toX(36),
            width: toX(275),
            height: toY(23),
            child: Text(
              "${localise("groups")} (${groupsModel.groupCount})",
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(15),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.30,
              ),
            )),
        Positioned(top: toY(210), left: toX(36), width: display.width - (toX(36) * 2), bottom: toY(20), child: Padding(padding: EdgeInsets.only(top: toY(20)), child: groups())),
      ],
    );
  }

  Widget groups() {
    return ListView.builder(
      itemCount: groupsModel.groupCount + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index < groupsModel.groupCount) {
          FiGroup group = groupsModel.groupAtIndex(index);
          return SizedBox(
              height: toY(120),
              child: Padding(
                  padding: EdgeInsets.only(top: toY(5), bottom: toY(5)),
                  child: uiElements.listButton(group.fullName, null, onTap: () {
                    groupsModel.openGroup(group);
                  })));
        } else {
          return uiElements.addItem(title:  localise("create_new_custom_groups"), onAdd: groupsModel.onCreateNewGroupClick) ;
        }
      },
    );
  }

  List<PopupMenuItem> _pageMenu() {
    List<PopupMenuItem> list = <PopupMenuItem>[];
    list.add(uiElements.pageMenuItem(
        localise("search"),
        Image(
          image: const AssetImage("assets/images/search.png"),
          width: toX(20),
          height: toY(18),
        ),
        () {}));
    list.add(uiElements.pageMenuItem(
        localise("create_group"),
        Image(
          image: const AssetImage("assets/images/create_group.png"),
          width: toX(20),
          height: toY(18),
        ),
        () {}));
    return list;
  }
}
