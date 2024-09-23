
import 'package:flutter/material.dart';

import '../../../backend/groups/cx_group_api.dart';
import '../../../backend/models/fi_backend_response.dart';
import '../../../models/main/fi_main_model.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../../utils/fi_display.dart';
import '../../../utils/fi_resources.dart';
import '../../../utils/list/fi_multi_list_action_list_widget.dart';
import '../../../utils/list/fi_multi_list_actions_data_source.dart';
import '../../../utils/list/fi_multi_list_collapsed_widget.dart';
import '../../../utils/list/fi_multi_list_data_source.dart';
import '../../../utils/list/fi_multi_list_expanded_widget.dart';
import '../../../utils/list/fi_multi_list_item.dart';
import '../../../utils/list/fi_multi_type_list.dart';
import '../../base/fi_base_state.dart';
import '../../base/fi_base_widget.dart';
import '../../utils/fi_ui_elements.dart';
import '../../zones/cx_custom_groups_model.dart';
import '../fi_groups_model.dart';
import '../fi_group.dart';

enum FiGroupType {
  group,
  custom;
 // groupInOrganization,
  //organizationGroup ,
  //company;



  static  int toJsonType(FiGroupType type){
    if(type == group) return 0 ;
   // if(type == organizationGroup) return 1 ;
    if(type == custom) return 3 ;
   // if(type == company) return 4 ;
    return 2 ;
  }

}

//ignore: must_be_immutable
class CxNewGroupWidget extends FiBaseWidget {

  FiApplicationStates? _backState;
   FiGroup _group = FiGroup();//////
  FiGroup? organization;
  bool createGroupInPlace = false ;
  FiGroupType _type = FiGroupType.group;
  FiGroup? parentGroup ;
  FiMultiListItem? parentGroupWidget ;
  CxNewGroupWidget({super.key}) ;

  @override
  Future<bool> get onWillPop {
    parentGroup = null ;
    if (_backState != null) {
      applicationModel.currentState = _backState!;
    }
    return Future.value(false);
  }

  @override
  setParams(params) {
    if (params is Map<String, dynamic>) {
      _backState = params[kBackState];
      createGroupInPlace = params[kActionInPlace] ?? false;

     // if (Flavors.isPersonal) {}
        _group = FiGroup(type: FiGroupType.group);

    /*  else {
        _type = params[kGroupType] ?? FiGroupType.group;

        *//*if (_type == FiGroupType.organizationGroup || _type == FiGroupType.company) {
          organization = params[kTargetGroup];
          _group = FiGroup(type: _type == FiGroupType.organizationGroup ? FiGroupType.groupInOrganization : FiGroupType.company);
        }
        else {*//*
          _group = FiGroup(type: _type);

      }*/
    }
  }

  @override
  State<StatefulWidget> createState() => _CxNewGroupState();
}

class _CxNewGroupState extends FiBaseState<CxNewGroupWidget> {

  late FiMultiListDataSource dataSources ;
  ButtonWidget? _buttonWidget ;

  @override
  void initState() {
    initDataSource() ;
    groupsModel.setState(this);
    super.initState();


  }

  @override
  void dispose() {
    groupsModel.setState(null);
    dataSources.clear() ;
    super.dispose();
  }



/*  _addParentGroupWidget(){

    if( (widget._type == FiGroupType.organizationGroup && widget.organization!= null && widget.organization!.hasGroups) || (Flavors.isPersonal && applicationModel.currentContact!.user!.groups.isNotEmpty)) {
      dataSources.insert(0, widget.parentGroupWidget = FiMultiListItem(
        collapsedWidget: FiMultiLisCollapsedWidget(
          title: widget.parentGroup?.name ?? localise("parent_group"),
          prefixImageName: "user.png",
          sufficsImageName: "horizontal_menu_dots.png",

          onTap: () {
            _showParentSelectionChooseDialog();
          },
        ),

      ));
    }
  }*/

  initDataSource() {

    dataSources = FiMultiListDataSource() ;

    //_addParentGroupWidget();


    dataSources.add(FiMultiListItem(
      autoUpdateTitle: true,
      enabled: true,
      collapsedWidget: FiMultiLisCollapsedWidget(
        title: _groupName(),
        prefixImageName: "connectx_small.png",
      ),
      expandedWidget: FiMultiListExpandedInputTextWidget(onChange: (name) {
        widget._group.name = name;
        dataSources.enableNext(1, name.isNotEmpty,allAfter: true) ;
        _buttonWidget?.setState!((){});
      }),
    ));

    dataSources.add(FiMultiListItem(

      collapsedWidget: FiMultiLisCollapsedWidget(
        enableGalleryImageSet: true,
        title: localise("group_logo"),
        prefixImageName: "group_logo.png",
        sufficsImageName: "horizontal_menu_dots.png",
        onImageChange: (imageBuffer) {
          setState(() {
            widget._group.setImage(imageBuffer);
          });
        },
      ),
    ));


    dataSources.add(FiMultiListItem(
      //enabled: _groupNameExist,
      collapsedWidget: FiMultiLisCollapsedWidget(
        title: localise("notes"),
        prefixImage: const Icon(Icons.note_add_outlined,color: Colors.white,),
      ),
      expandedWidget: FiMultiListExpandedInputTextWidget(
        suffixIcon: Image(image: const AssetImage("assets/images/edit_small.png"),color: Colors.white,width: toX(40),height: toX(40),),
          onChange: (name) {

      }),
    ));

     // if (widget._type != FiGroupType.organizationGroup || (applicationModel.currentContact?.user?.organization != null && applicationModel.currentContact != null && applicationModel.currentContact!.user != null && applicationModel.currentContact!.user!.organization != null && applicationModel.currentContact!.user!.organization!.isNotEmpty)) {
        dataSources.add(FiMultiListItem(
          fullExpandBackground: const Color(0xFF292C35),
          collapsedWidget: FiMultiLisCollapsedWidget(
            title: localise("members"),
            prefixImageName: "members.png",
            sufficsImageName: "horizontal_menu_dots.png",



          ),
          expandedWidget: FiMultiListExpandedActionListWidget(
            actionText: localise("add_contacts"),
            actionDataSource: FiMultiListActionDataSource(action: widget._group.addMemberAction(backState: FiApplicationStates.newGroup), items: widget._group.membersAsStrings()),
          ),
        ));



  /*  if(Flavors.isBusiness) {
      dataSources.add(FiMultiListItem(
        //enabled: _groupNameExist,
        collapsedWidget: FiMultiLisCollapsedWidget(
          title: localise("options"),
          prefixImageName: "options.png",
          sufficsImageName: "horizontal_menu_dots.png",
          onTap: () {
            _showPermissionsDialog();
          },
        ),
      ));
    }*/
  }

  String get _title {
  //  if(Flavors.isPersonal){
      return localise("new_group");
   // }
   /* switch (widget._type) {
*//*      case FiGroupType.organizationGroup:
        return "${widget.organization!.name}\n${localise("new_group")}";*//*
      case FiGroupType.group:
        return localise("new_group");
      default:
        return localise("new_custom_group");
    }*/
  }

  Widget get title {
    /*switch (widget._type) {
      case FiGroupType.organizationGroup:
        return Align(
            alignment: Alignment.center,
            child: RichText(
              textAlign:TextAlign.center,
              text: TextSpan(
                text: widget.organization!.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: toY(30),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                children:  <TextSpan>[
                  TextSpan(text: "\n${localise("new_group")}", style: TextStyle(
                    color: Colors.white,
                    fontSize: toY(20),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  )),

                ],
              ),
            ));
      default:*/
        return Align(
            alignment: Alignment.center,
            child: Text(
              _title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(30),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ));
  }


  Widget button() {
    return uiElements.button(localise("create"), enabled: (widget._group.name?.isNotEmpty??false) , () async {
   /*   switch(widget._type){
        case FiGroupType.organizationGroup:
          widget.parentGroup?.childgroups.add(widget._group) ;
          widget.organization!.childgroups.add(widget._group) ;
          if(widget.createGroupInPlace){
            String content = "${localise("creating_group")}\n${widget._group.name??""}" ;
            uiElements.showLoadingMessage(localise("please_wait"), content) ;
            FiBackendResponse response = await groupsApi.create(widget._group.toModel(parentId: widget.organization!.groupId)) ;
            if(response.successful()){
              await widget._group.uploadImages();
            }
            uiElements.dismissLoading() ;
            if(response.successful()) {
              groupsModel.reset();
              await widget.onWillPop;
            }
          }


          break ;
        default:*/
          String content = "${localise("creating_group")}\n${widget._group.name??""}" ;
          uiElements.showLoadingMessage(localise("please_wait"), content) ;
          if(widget.parentGroup != null){
            widget._group.parentGroup = widget.parentGroup ;
            widget._group.parentGroupID  = widget.parentGroup?.groupId??"" ;
          }
          bool status = await groupsModel.createGroup(widget._group);
          if(status){
            await widget._group.uploadImages();
          }
          uiElements.dismissLoading() ;

          if(status) {
            uiElements.showOperationCompleteStatus(title: localise("the_group"),subtitle:widget._group.name??"",statusText: localise("created_successfully"));
            customGroupsModel.addGroup(widget._group) ;
            widget.parentGroup = null ;
            await widget.onWillPop;
          }
        //  break ;

    });
  }

  @override
  Widget get content {
    return Stack(children: [
      uiElements.backButton(() async => await widget.onWillPop),
      Positioned(
          top: toY(85),
          left: toX(0),
          width: display.width,
          //height: toY(45),
          child: Align(
              alignment: Alignment.center,
              child: title)),
      Positioned(
        top: toY(181),
        left: toX(35),
        height: display.height - toY(200),
        width: toX(344),
        child: FiMultiTypeList(dataSource: dataSources, isSingleInputTypeEnabled: false),
      ),
      Positioned(top: toY(729), left: toX(35), width: toX(344), height: toY(67), child: _buttonWidget = ButtonWidget(button: button,setState: setState,))
    ]);
  }

  String _groupName() => widget._group.name != null && widget._group.name!.isNotEmpty ? widget._group.name! : localise("group_name");


  Widget _permissionLabel(String label) => Text(
        label.toUpperCase(),
        style: TextStyle(
          color: const Color(0xFFCACACA),
          fontSize: toY(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          letterSpacing: 1.05,
        ),
      );

  Widget _permissionSwitch(String key, StateSetter dialogSetState) => Switch(
        value: widget._group.permissionStateFor(key),
        activeTrackColor: const Color(0xff0677E8),
        activeColor: const Color(0xFFFFFFFF),
        inactiveTrackColor: const Color(0x78788052),
        inactiveThumbColor: const Color(0xFFFFFFFF),
        onChanged: (bool value) {
          dialogSetState(() {
            widget._group.setPermissionState(key, value);
          });
        },
      );

  Widget alertWidget(BuildContext contact, StateSetter setState) => Container(
        width: toX(344),
        height: toY(400),
        decoration: ShapeDecoration(
          color: const Color(0xFF292D36),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFF0677E8)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                top: toY(26),
                left: toX(20),
                child: Image(
                  image: const AssetImage("assets/images/lock.png"),
                  width: toX(17),
                  height: toY(19),
                )),
            Positioned(
                left: toX(50),
                top: toY(24),
                height: toY(30),
                child: Text(
                  localise("permissions").toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCACACA),
                    fontSize: toY(17),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.70,
                  ),
                )),
            Positioned(left: toX(50), top: toY(75), height: toY(30), child: _permissionLabel(localise("private").toUpperCase())),
            Positioned(top: toY(71), right: toX(29), height: toY(31), left: toX(245), child: _permissionSwitch(FiGroup.kPrivate, setState)),
            Positioned(left: toX(50), top: toY(128), height: toY(30), child: _permissionLabel(localise("editable").toUpperCase())),
            Positioned(top: toY(124), right: toX(29), height: toY(31), left: toX(245), child: _permissionSwitch(FiGroup.kEditable, setState)),
            Positioned(left: toX(50), top: toY(181), height: toY(30), child: _permissionLabel(localise("edit_members").toUpperCase())),
            Positioned(top: toY(177), right: toX(29), height: toY(31), left: toX(245), child: _permissionSwitch(FiGroup.kEditableMembers, setState)),
            Positioned(left: toX(50), top: toY(234), height: toY(30), child: _permissionLabel(localise("assign_as_parent").toUpperCase())),
            Positioned(top: toY(230), right: toX(29), height: toY(31), left: toX(245), child: _permissionSwitch(FiGroup.kAssignAsParent, setState)),
            Positioned(left: toX(29), top: toY(282), height: toY(30), child: _permissionLabel(localise("notes").toUpperCase())),
            Positioned(
                left: toX(29),
                top: toY(315),
                right: toX(29),
                child: uiElements.inputField(
                    onChange: widget._group.onNotesTyped,
                    suffixIcon: const Image(
                      image: AssetImage("assets/images/edit_small.png"),
                    ),
                    hintStyle: TextStyle(
                      color: const Color(0xFFCACACA),
                      fontSize: toY(15),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.70,
                    ),
                    backgroundColor: const Color(0xff292C35)))
          ],
        ),
      );

  _showPermissionsDialog() => showStateFullAlertDialog(344, 400, alertWidget);





  _showParentSelectionChooseDialog() {
    FiMultiListDataSource groupsSource = FiMultiListDataSource();

    Iterator<FiGroup> it = customGroupsModel.allGroups.iterator ;
    if(it.moveNext()){
      do{
        final FiGroup group = it.current ;
        groupsSource.add(FiMultiListItem(
          isUpdatable: true,
          collapsedWidget: FiMultiLisCollapsedWidget(
            title: group.name,
            prefixImage: group.logo,
            onTap: (){
              setState(() {
                  uiElements.dismissLoading() ;
                  widget.parentGroup = group ;
                //  _addParentGroupWidget();
              });
            },
          ),
        ));
      }
      while(it.moveNext()) ;
    }

    showDialog(
        barrierDismissible: false,
        context: resources.context!,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.only(bottom: display.height / 2 - toY(276) / 2),
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: toX(327),
                  height: toY(355),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF292D36),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.50, color: Color(0xFF0677E8)),
                      borderRadius: BorderRadius.circular(toX(20)),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          top: toY(15),
                          left: toX(49),
                          right: toX(49),
                          child: Center(
                              child: Text(
                                localise("select_parent_group"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: toY(20),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.20,
                                ),
                              ))),
                      Positioned(
                          top:toY(55),
                          bottom:toY(10),
                          left: toX(10),
                          right: toX(10),
                          child: FiMultiTypeList(dataSource: groupsSource))

                    ],
                  ),
                );
              }));
        });
  }

}
