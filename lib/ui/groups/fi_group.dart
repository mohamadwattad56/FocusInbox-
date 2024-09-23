import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:uuid/uuid.dart';

import '../../backend/groups/cx_group_api.dart';
import '../../backend/models/fi_backend_response.dart';
import '../../backend/models/fi_group_model.dart';
import '../../backend/models/fi_group_user_model.dart';
import '../../backend/upload/fi_images_manager.dart';
import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../../utils/fi_display.dart';
import '../../utils/fi_image_data.dart';
import '../../utils/list/fi_multi_list_action.dart';
import '../navigationbar/contacts/fi_contact.dart';
import '../utils/fi_ui_elements.dart';
import 'newgroup/fi_new_group.dart';

class FiGroup {
  static String kPrivate = "private";

  static String kEditable = "editable";

  static String kEditableMembers = "editable_members";

  static String kAssignAsParent = "assign_as_parent";

  String? ownerID ;
  String? parentGroupID ;
  String? name;
  FiImageData? image ;
  String? imagePath;

  String notes = "";

  String get fullName {
    if(parentGroup != null){
      return "${parentGroup!.fullName}/${name??""}" ;
    }
    return name??"" ;
  }

  String? groupId;

  FiGroupType type = FiGroupType.group;
 // String? companyType ;
  FiGroup? parentGroup ;

  final List<FiGroupUserModel> memberModels = <FiGroupUserModel>[];
  final List<FiContact> members = <FiContact>[];
  final List<FiGroup> childgroups = <FiGroup>[];

  FiGroup({this.name, this.type = FiGroupType.group}) {
    _permissionStates[kPrivate] = false;
    _permissionStates[kEditable] = false;
    _permissionStates[kEditableMembers] = false;
    _permissionStates[kAssignAsParent] = false;
  }

  ValueChanged<String> get onNotesTyped => (notes) {};

  final Map<String, bool> _permissionStates = {};

  Uint8List? imageBuffer;

  bool get valid => type == FiGroupType.group || type == FiGroupType.custom ? name?.isNotEmpty??false : (name?.isNotEmpty??false) && childgroups.isNotEmpty;

  bool get hasGroups => childgroups.isNotEmpty;


  List logoBackgroundColors = [Colors.red,Colors.blueGrey,Colors.green,const Color(0xff629AAB), const Color(0xffA5C878), Colors.yellow,const Color(0xffFFE4B5),const Color(0xff94FFAB),const Color(0xff5BA3FF),const Color(0xffADADAD)];
  Random random =  Random();
  Color? logoColor ;

  Widget get logo {
    logoColor??=logoBackgroundColors[random.nextInt(logoBackgroundColors.length)] ;
    return Container(
      width: toX(25),
      height: toX(25),
      decoration: ShapeDecoration(
        color: logoColor!,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: imageBuffer != null ? Image.memory(imageBuffer!,fit: BoxFit.fill,scale: 1.2,) :  SizedBox(
        width: toX(25),
        height: toX(25),
        child: ConstraintLayout(
          children: [
            Text(
              name!.toUpperCase().characters.first,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(18),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ).applyConstraint(left: parent.left,right: parent.right,top: parent.top,bottom: parent.bottom)
          ],
        ),
      ),
    ) ;

  }

  FiImageDownloadCallback get downloadImageCallback => (buffer,error){
    if(error == null && buffer != null){
      imageBuffer =  buffer ;
    }
  };


  Widget  logoWithSize({double size = 105,double fontSize = 36,double scale = 1.2}) {
    logoColor??=logoBackgroundColors[random.nextInt(logoBackgroundColors.length)] ;
    return Container(
      width: toX(size),
      height: toX(size),
      decoration: ShapeDecoration(
        color: logoColor!,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: imageBuffer != null ? Image.memory(imageBuffer!,fit: BoxFit.fill,scale:scale,width: size,) :  SizedBox(
        width: toX(size),
        height: toX(size),
        child: ConstraintLayout(
          children: [
            Text(
              name!.toUpperCase().characters.first,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(fontSize),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ).applyConstraint(left: parent.left,right: parent.right,top: parent.top,bottom: parent.bottom)
          ],
        ),
      ),
    ) ;

  }

  Widget get thumbnail {
    logoColor??=logoBackgroundColors[random.nextInt(logoBackgroundColors.length)] ;
    return Container(
      width: toX(35),
      height: toX(35),
      decoration: ShapeDecoration(
        color: logoColor!,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: imageBuffer != null ? Image.memory(imageBuffer!,fit: BoxFit.fill,scale: 1.2,) :  SizedBox(
        width: toX(35),
        height: toX(35),
        child: ConstraintLayout(
          children: [
            Text(
              name!.toUpperCase().characters.first,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(18),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ).applyConstraint(left: parent.left,right: parent.right,top: parent.top,bottom: parent.bottom)
          ],
        ),
      ),
    ) ;

  }

  FiMultiListAction  addMemberAction({FiApplicationStates backState = FiApplicationStates.newGroup}) {
    FiMultiListAction  action =   FiMultiListAction();
    action.action = (){
      applicationModel.setCurrentStateWithParams(FiApplicationStates.addUsersToGroup, {kBackState:backState,kTargetGroup:this}) ;
    } ;
    return action ;
  }



  bool permissionStateFor(String key) {
    return _permissionStates[key] ?? false;
  }

  setPermissionState(String key, bool state) {
    if (_permissionStates.containsKey(key)) {
      _permissionStates[key] = state;
    }
  }

  void addContact(FiContact? convertedContact) {
    if (convertedContact != null && convertedContact.model != null) {
      if (!memberModels.contains(convertedContact.model!)) {
        convertedContact.model!.id = convertedContact.id =  const Uuid().v4();
        memberModels.add(convertedContact.model!);
      }
    }
  }

  CxGroupModel toModel({String? parentId}) {
    CxGroupModel model = CxGroupModel();
    model.name    = name;
    model.groupid = const Uuid().v4();
    model.creator = applicationModel.currentContact!.user!.uuid;
    model.parentgroup = parentId;
    model.private = _permissionStates[kPrivate] ?? false;
    model.editable = _permissionStates[kEditable] ?? false;
    model.editmembers = _permissionStates[kEditableMembers] ?? false;
    model.assignasparent = _permissionStates[kAssignAsParent] ?? false;
    model.members = <dynamic>[];
    Iterator<FiGroupUserModel> it = memberModels.iterator;
    if (it.moveNext()) {
      do {
        model.members!.add(it.current.toJson);
      } while (it.moveNext());
    }
    Iterator<FiGroup> itGroup = childgroups.iterator;
    if (itGroup.moveNext()) {
      do {
        model.childgroups!.add(itGroup.current.toModel(parentId: model.groupid));
      } while (itGroup.moveNext());
    }
    model.notes = notes;
    return model;
  }

  Future<bool> create() async {
    CxGroupModel model = CxGroupModel();
    model.type = FiGroupType.toJsonType(type);
    model.groupid = const Uuid().v4();
    groupId =  model.groupid ;
    model.name = name;
    model.parentgroup = parentGroup?.groupId??"";
    model.creator = applicationModel.currentContact!.user!.uuid;
    model.private = _permissionStates[kPrivate] ?? false;
    model.editable = _permissionStates[kEditable] ?? false;
    model.editmembers = _permissionStates[kEditableMembers] ?? false;
    model.assignasparent = _permissionStates[kAssignAsParent] ?? false;
    model.members = <dynamic>[];
    Iterator<FiGroupUserModel> it = memberModels.iterator;
    if (it.moveNext()) {
      do {
        model.members!.add(it.current.toJson);
      } while (it.moveNext());
    }
    model.childgroups = <dynamic>[];
    Iterator<FiGroup> itGroup = childgroups.iterator;
    if (itGroup.moveNext()) {
      do {
        model.childgroups!.add(itGroup.current.toModel(parentId: model.groupid));
      } while (itGroup.moveNext());
    }
    model.notes = notes;
    FiBackendResponse response = await groupsApi.create(model);
    if(response.successful()){
      if(image != null) {
        await imagesApi.uploadImage(model.groupid!, image!);
      }
      Iterator<FiGroup> itGroup = childgroups.iterator;
      if (itGroup.moveNext()) {
        do {
          if(itGroup.current.image != null){
            await imagesApi.uploadImage(itGroup.current.groupId!, itGroup.current.image!);
          }
        } while (itGroup.moveNext());
      }
    }

    return response.successful();
  }

  static Future<FiGroup> fromModel(CxGroupModel model) async {
    FiGroup group = FiGroup(name: model.name);
    group.ownerID = model.creator ;
    group.parentGroupID = model.parentgroup ;
    group._permissionStates[kPrivate] = model.private??true;
    group._permissionStates[kEditable] = model.editable??false;
    group._permissionStates[kEditableMembers] = model.editmembers??false;
    group._permissionStates[kAssignAsParent] = model.assignasparent??false;
    group.groupId = model.groupid;

    switch(model.type) {
      case 0:
        group.type = FiGroupType.group;
        break ;
   /*   case 1:
        group.type = FiGroupType.groupInOrganization;
        break ;
      case 2:
        group.type = FiGroupType.organizationGroup;
        break ;*/
      case 3:
        group.type = FiGroupType.custom;
        break ;
    /*  case 4:
        group.type = FiGroupType.company;
        break ;*/
    }

    if (model.members != null && model.members!.isNotEmpty) {
      Iterator<dynamic> it = model.members!.iterator;
      if (it.moveNext()) {
        do {
          if (it.current is Map<String, dynamic>) {
            FiGroupUserModel userModel = FiGroupUserModel.fromJson(it.current);
            group.memberModels.add(userModel);
          }
        } while (it.moveNext());
      }
    }

    if (model.childgroups != null && model.childgroups!.isNotEmpty) {
      Iterator<dynamic> it = model.childgroups!.iterator;
      if (it.moveNext()) {
        do {
          if (it.current is Map<String, dynamic>) {
            CxGroupModel groupModel = CxGroupModel.from(it.current);
            group.childgroups.add(await FiGroup.fromModel(groupModel));
          }
        } while (it.moveNext());
      }
    }
    if(model.logo??false) {
      await imagesApi.downloadImage(group.groupId!,group.downloadImageCallback);
    }


    return group;
  }

  membersAsStrings() {
    List<String> membersName = <String>[] ;
    Iterator<dynamic> it = memberModels.iterator ;
    if(it.moveNext()){
      do{
        FiGroupUserModel model = it.current ;
        membersName.add("${model.firstName} ${model.lastName}") ;
      }
      while(it.moveNext());
    }
    return membersName ;
  }

  List<String> parentGroupNames() {
    List<String> groupsName = <String>[] ;
    if(parentGroup != null){
      groupsName.add(parentGroup!.name??"") ;
    }
    return groupsName ;
  }

  void setImage(FiImageData imageData) {
    image = imageData ;
    imageBuffer = image?.buffer ;
  }

  uploadImages() async {
    if(image != null) {
      await imagesApi.uploadImage(groupId!, image!);
    }

    Iterator<FiContact> it = members.iterator ;
    if(it.moveNext()){
      do{
        FiContact contact = it.current ;
        await contact.uploadImage();
      }
      while(it.moveNext());
    }

  }

  void addMember(FiContact contact) {

    //if (F.isPersonal)
    {
      FiGroupUserModel model = _contactToModel(contact) ;
      for(FiGroupUserModel m in memberModels) {
        if(m.id == model.id) {
          return  ;
        }
      }
      members.add(contact) ;
      memberModels.add(model);
    }
  }

  FiGroupUserModel _contactToModel (FiContact contact) {
    FiGroupUserModel model = contact.fromPhoneContact;

    model.parentId = applicationModel.currentContact!.user!.uuid! ;
    if(contact.id ==null || contact.id!.isEmpty){
      model.id = contact.id = const Uuid().v4();
    }
    if(groupId?.isEmpty??true ){
      groupId = const Uuid().v4();
      model.groups.add(groupId!);
    }
    return model ;
  }
}
