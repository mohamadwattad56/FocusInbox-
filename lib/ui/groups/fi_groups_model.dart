import 'package:flutter/cupertino.dart';
import '../../backend/models/fi_group_model.dart';
import '../../backend/models/fi_user.dart';
import '../../models/main/base/fi_model.dart';
import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../../utils/fi_log.dart';
import '../zones/cx_custom_groups_model.dart';
import 'fi_group.dart';
import 'newgroup/fi_new_group.dart';

class CxCustomGroupsModel extends FiModel {
  static final CxCustomGroupsModel _instance = CxCustomGroupsModel._internal();

  CxCustomGroupsModel._internal();

  FiGroup? group;

  final TextEditingController _groupSearchController = TextEditingController();

  factory CxCustomGroupsModel() {
    return _instance;
  }

  get groupsController => null;
  bool inProgress = false;

  TextEditingController get groupsSearchController => _groupSearchController;

  ValueChanged<String> get onSearch => (value) {};

  VoidCallback get stopSearch => () {};

  updateData(FiUser user) async {
    if (user.groups.isNotEmpty) {
      for (dynamic groupData in user.groups) {
        if (groupData is Map<String, dynamic>) {
          try {
            CxGroupModel model = CxGroupModel.from(groupData);
            FiGroup group = await FiGroup.fromModel(model);
            if (group.type == FiGroupType.custom ) {
              customGroupsModel.addGroup(group);
            } else {
              groups.add(group);
            }
            //contacts.updateData(group);
          } catch (err, stack) {
            logger.d("$err, $stack");
          }
        }
      }

        var list = customGroupsModel.allGroups;
        for (FiGroup g in list) {
          if (g.parentGroupID != null && g.parentGroupID!.isNotEmpty) {
            for (FiGroup p in list) {
              if (p.groupId == g.parentGroupID) {
                g.parentGroup = p;
            }
          }
        }
      }
    }
  }

  bool get inSearch => false;

  final List<FiGroup> groups = <FiGroup>[];

  VoidCallback get onCreateNewGroupClick => () {
        applicationModel.currentState = FiApplicationStates.newGroup;
      };

  int get groupCount => groups.length;

  FiGroup groupAtIndex(int index) => groups[index];

  void openGroup(FiGroup group) {}

  FiGroup createNewGroupModel() {
    group ??= FiGroup();
    return group!;
  }

  Future<bool> createGroup(FiGroup group) async {
    inProgress = true;
    final bool state = await group.create();
    update(callback: () async {
      if (state) {
        if (group.type == FiGroupType.custom) {
          customGroupsModel.addGroup(group);
        } else {
          groups.add(group);
        }
      }
      update(callback: () {
        inProgress = false;
      });
    });
    return state;
  }

  void reset() {
    group = null;
  }
}

CxCustomGroupsModel groupsModel = CxCustomGroupsModel();
