
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/main/base/fi_model.dart';
import '../../../utils/fi_log.dart';
import '../../base/fi_base_state.dart';
import 'fi_contacts_tab_widget.dart';
import '../../launching/fi_launching_model.dart';
import 'fi_contacts_page_widget.dart';
import 'fi_contact.dart';

class FiContactsTabModel extends FiModel {
  static final FiContactsTabModel _instance = FiContactsTabModel._internal();
  final List<FiContact> _privateContacts = <FiContact>[];
  final List<FiContact> _searchedContacts = <FiContact>[];
  final List<FiContact> _organizationContacts = <FiContact>[];
  List<FiContactsPageWidget> pages = <FiContactsPageWidget>[];
  final Map<FiContactPageType, FiBaseState> _states = {};

  late TextEditingController _searchController;

  TextEditingController get searchController => _searchController;
  int _currentPageIndex = 0;

  bool _inSearch = false;

  bool get inSearch => _inSearch;

  VoidCallback get stopSearch => () {
        updatePage(callback: () {
          _searchedContacts.clear();
          _inSearch = false;
          _searchController.text = "";
        });
      };


  setPageState(FiContactPageType type, FiBaseState? state) {
    if (state != null) {
      _states[type] = state;
    } else {
      _states.remove(type);
    }
  }

  updatePage({VoidCallback? callback}) => _states[currentType]?.updateState(callback: callback);

  updateAllPages({VoidCallback? callback}) {
    Iterator<FiBaseState> states = _states.values.iterator;
    if (states.moveNext()) {
      do {
        states.current.updateState(callback: callback);
      } while (states.moveNext());
    }
  }

  FiContactsTabModel._internal();

  factory FiContactsTabModel() {
    return _instance;
  }

  FiContactPageType get currentType {
    return FiContactPageType.private;

  }

  int get privateContactsCount => _inSearch ? _searchedContacts.length : _privateContacts.length;

  ValueChanged<String> get onSearch => (text) {
        _inSearch = text.trim().isNotEmpty;
        Iterable<FiContact>? searched;
        logger.d("Searching: $text index $_currentPageIndex");
        switch (_currentPageIndex) {
          case 0:
            {
              searched = _privateContacts.where((element) => element.name.toLowerCase().contains(text.toLowerCase()) || element.phoneNumber.toLowerCase().contains(text.toLowerCase()));
              logger.d("Searching in private contacts count ${searched.length}");
            }
            break;
        /*  case 1:
            {
              searched = _notSharedContacts.where((element) => element.name.toLowerCase().contains(text.toLowerCase()) || element.phoneNumber.toLowerCase().contains(text.toLowerCase()));
            }
            break;
          case 2:
            {
              searched = _sharedContacts.where((element) => element.name.toLowerCase().contains(text.toLowerCase()) || element.phoneNumber.toLowerCase().contains(text.toLowerCase()));
            }
            break;
          case 3:
            {
              searched = _organizationContacts.where((element) => element.name.toLowerCase().contains(text.toLowerCase()) || element.phoneNumber.toLowerCase().contains(text.toLowerCase()));
            }
            break;*/
        }

        if (_inSearch && searched != null && searched.isNotEmpty) {
          updatePage(callback: () {
            logger.d("Updated $_searchedContacts");
            _searchedContacts.clear();
            _searchedContacts.addAll(searched!);

          });
        } else {
          updatePage(callback: () {
            _searchedContacts.clear();
          //  _searchController.text = "";
          });
        }
      };

  set currentPageIndex(int currentPageIndex) {
    updateAllPages(callback: () {
      _searchedContacts.clear();
      _inSearch = false;
      _searchController.text = "";
      _currentPageIndex = currentPageIndex;
    });
  }

  Future<void> load() async {
    var status = await launchingModel.getContactPermission();
    if (status == PermissionStatus.granted) {
      List<Contact> phoneContacts = await ContactsService.getContacts();
      phoneContacts.sort((a, b) {
        if (a.displayName != null && b.displayName != null) {
          return a.displayName!.toLowerCase().compareTo(b.displayName!.toLowerCase());
        }
        return 0;
      });

      Map<String, List<Contact>> contactMap = {};
      String initialLetter = "";

      for (var element in phoneContacts) {
        if (element.phones != null && element.phones!.isNotEmpty) {
          String phoneNumber = element.phones!.first.value ?? "";
          if (contactMap.containsKey(phoneNumber)) {
            contactMap[phoneNumber]!.add(element);
          } else {
            contactMap[phoneNumber] = [element];
          }
        }
      }

      List<FiContact> mergedContacts = [];
      contactMap.forEach((phoneNumber, contacts) {
        if (contacts.isNotEmpty) {
          String mergedName = contacts.map((c) => c.displayName).where((name) => name != null).join(", ");
          Contact mergedContact = contacts.first;
          mergedContact.displayName = mergedName;
          mergedContacts.add(FiContact(type: FiContactPageType.private, phoneContact: mergedContact));
        }
      });

      mergedContacts.sort((a, b) {
        if (a.phoneContact!.displayName != null && b.phoneContact!.displayName != null) {
          return a.phoneContact!.displayName!.toLowerCase().compareTo(b.phoneContact!.displayName!.toLowerCase());
        }
        return 0;
      });

      _privateContacts.clear();
      initialLetter = "";
      for (var contact in mergedContacts) {
        contact.loadData(() {
          String current = contact.name.characters.first.toUpperCase();
          if (current != initialLetter) {
            initialLetter = current;
            _privateContacts.add(FiContact(type: FiContactPageType.divider, divider: initialLetter));
          }
          _privateContacts.add(contact);
        });
      }

      // Clean up dividers that are no longer needed
      for (int i = _privateContacts.length - 1; i >= 0; i--) {
        if (_privateContacts[i].type == FiContactPageType.divider) {
          if (i == _privateContacts.length - 1 || _privateContacts[i + 1].type == FiContactPageType.divider) {
            _privateContacts.removeAt(i);
          }
        }
      }

      pages.add(FiContactsPageWidget(FiContactPageType.private));
      _searchController = TextEditingController();
    }
  }


  int get pageCount => pages.length;

  FiContactsPageWidget pageAtIndex(int index) =>  pages[0] ;//index < pageCount ? pages[index] : pages[0];

  AssetImage get myImage => const AssetImage("assets/images/nb_man_icon.png");

  FiContact contactAtIndex(int index, FiContactPageType type) {
    if (_inSearch) {
      return _searchedContacts[index];
    }

        return _privateContacts[index];

  }
}

FiContactsTabModel contacts = FiContactsTabModel();
