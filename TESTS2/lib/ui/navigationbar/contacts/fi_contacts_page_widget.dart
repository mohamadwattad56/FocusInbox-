import 'package:flutter/material.dart';
import '../../../models/main/fi_main_model.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../../utils/fi_display.dart';
import '../../../utils/fi_log.dart';
import '../../../utils/fi_resources.dart';
import '../../base/fi_base_state.dart';
import '../../base/fi_base_widget.dart';
import '../../groups/fi_group.dart';
import 'fi_contacts_message_search_widget.dart';
import 'fi_contacts_tab_model.dart';
import 'fi_contacts_tab_widget.dart';
import '../../utils/fi_ui_elements.dart';
import 'fi_contact.dart';

class FiContactsPageWidget extends FiBaseWidget {
  final FiContactPageType type;
  FiApplicationStates? _backState;

  FiGroup? targetGroup;

  FiContactsPageWidget(this.type, {super.key});

  @override
  setParams(params) {
    if (params is FiApplicationStates) {
      _backState = params;
    } else if (params is Map<String, dynamic>) {
      Map<String, dynamic> dictionary = params;
      _backState = dictionary.containsKey(kBackState) ? dictionary[kBackState] : null;
      targetGroup = dictionary.containsKey(kTargetGroup) ? dictionary[kTargetGroup] : null;
    }
  }


  @override
  Future<bool> get onWillPop async {
    if (type == FiContactPageType.addingToGroup) {
      if (_backState == null) {
        applicationModel.currentState = FiApplicationStates.newGroup;
      } else {
        applicationModel.currentState = _backState!;
      }
    }
    return true;
  }

  @override
  State<StatefulWidget> createState() => _FiContactsPageState();
}

class _FiContactsPageState extends FiBaseState<FiContactsPageWidget> {
  final List<FiContact> _selectedContacts = <FiContact>[];
  final Map<FiContact, bool> _favoritesStates = {};
  final _scrollController1 = ScrollController();
  final _scrollController2 = ScrollController();

  @override
  void initState() {
    super.initState();
    contacts.setPageState(widget.type, this);
  }

  @override
  void dispose() {
    super.dispose();
    contacts.setPageState(widget.type, null);
  }

  @override
  Widget get content {
    return Stack(
      children: [
        Positioned(
            top: toY(50),
            left: toX(20),
            width: toX(32),
            height: toX(32),
            child: Visibility(
                visible: widget.type == FiContactPageType.addingToGroup,
                child: uiElements.backButton(() async {
                  await widget.onWillPop;
                }))),
        Positioned(
            top: toY(80),
            width: display.width,
            child: Center(
                child: Text(
                  pageTitle,
                  style: TextStyle(
                    color: pageTitleColor,
                    fontSize: toY(24),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ))),

        Positioned(
            top: toY(137),
            left: toX(35),
            child: Visibility(
                visible: widget.type == FiContactPageType.addingToGroup,
                child: Center(
                    child: Text(
                      localise("click_to_add_remove_contact"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: toY(12),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    )))),
        Positioned(
            left: toX(28),
            top: toY(widget.type == FiContactPageType.addingToGroup ? 164 : 140),
            width: toX(359),
            height: toY(44),
            child: uiElements.inputField(
                controller: contacts.searchController,
                onChange: contacts.onSearch,
                borderRadius: 10,
                backgroundColor: Colors.transparent,
                prefixIcon: const Image(image: AssetImage("assets/images/search.png")),
                suffixIcon: contacts.inSearch ? const Icon(Icons.clear) : null,
                sufficsIconClick: () {
                  display.closeKeyboard();
                  contacts.stopSearch.call();
                },
                hintText: localise("search"),
                hintStyle: TextStyle(
                  color: const Color(0xFFB6B6B6),
                  fontSize: toY(14),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ))),
        if (contactsCount == 0)
          Positioned(
              top: toY(362),
              height: toY(100),
              width: display.width,
              child: Center(
                  child: Text(
                    localise('nothing_here'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF7C7878),
                      fontSize: toY(50),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: 1,
                    ),
                  ))),
        if ( contactsCount > 0)
          Positioned(
            top: toY(widget.type == FiContactPageType.addingToGroup ? 228 : 204),
            left: 0,
            width: display.width,
            height: toY(480),//widget.type == FiContactPageType.addingToGroup ? 600 : 680),
            child: _contactsList(),
          ),

        Positioned(
          bottom: toY(0),
          left: 0,
          width: display.width,
          //height: toY(500),//widget.type == FiContactPageType.addingToGroup ? 600 : 680),
          child: uiElements.addItem(title: "Add Contact", onAdd: (){}),
        ),
      ],
    );
  }


  Widget _contactsList() {
    return Scrollbar(
      controller: _scrollController2,
      thumbVisibility: true,
      scrollbarOrientation: ScrollbarOrientation.left,
      child: ListView.builder(
        controller: _scrollController2,
        padding: EdgeInsets.only(left: toX(35), right: toX(35)),
        itemCount: contactsCount,
        itemBuilder: (BuildContext context, int index) {
          FiContact contact = contacts.contactAtIndex(index, widget.type);
          return uiElements.contactRow(
            index,
            contact,
            favoriteVisible: false,
            addContactVisible: _selectedContacts.contains(contact),
            addUserKey: "user_added",
            onAddUserClick: () {
              setState(() {
                widget.targetGroup?.addMember(contact);
                widget.onWillPop;
              });
            },
            onItemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FiContactsMessageSearchWidget(contact: contact),
                ),
              );
            },
          );
        },
      ),
    );
  }



  bool removeButtonVisible(FiContact contact) {
    if (_favoritesStates.containsValue(contact)) {
      bool removeVisible = _favoritesStates[contact]!;
      return removeVisible;
    }
    _favoritesStates[contact] = false;
    return false;
  }

  int get contactsCount {
    int count = 0;
    count = contacts.privateContactsCount;
    logger.d("Contact count : $count");
    return count;
  }

  String get pageTitle {return localise("contact_list");}

  String get pageSubTitle {
    var yh = localise("you_have_contacts");
    yh = yh.replaceFirst("#", "$contactsCount");
    return yh;
  }

  Color get pageTitleColor {
    return const Color(0xffADADAD);
  }

}
