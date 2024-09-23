import 'dart:async';import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/main/fi_main_model.dart';
import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../dialogs/fi_dialog.dart';
import '../navigationbar/contacts/fi_contact.dart';
import 'dart:convert' as convert;
import 'package:dotted_line/dotted_line.dart';
import '../registration/fi_debouncer.dart';
import 'fi_keyboard_input_helper.dart';
enum InputType { email, firstName, lastName, generic }

typedef DynamicWidget = Widget Function();

class ButtonWidget extends StatefulWidget {
  DynamicWidget button ;
  VoidCallback? refresh ;
  StateSetter? setState ;
  ButtonWidget({super.key, required this.button,this.setState});
  @override
  State<StatefulWidget> createState() => _ButtonWidgetState();


}
class ValidatingController extends TextEditingController {
  bool isValid = false;
}

class _ButtonWidgetState extends State<ButtonWidget> {

  @override
  void initState() {
    widget.refresh = (){
      setState(() {

      });
    };
    super.initState();
  }

  @override
  void dispose() {
    widget.refresh = null ;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.button.call() ;

}

class FiUiElements {
  static final FiUiElements _instance = FiUiElements._internal();

  FiUiElements._internal();

  static const Image inputNameIcon = Image(image: AssetImage("assets/images/_inputNameIcon.png"));
  static const Image inputEmailIcon = Image(image: AssetImage("assets/images/email_input.png"));
  static const Image lockIcon = Image(image: AssetImage("assets/images/lock_icon.png"));
  static const Image eyeOffIcon = Image(image: AssetImage("assets/images/eye_off_icon.png"));

  factory FiUiElements() {
    return _instance;
  }




Widget inputField({FocusNode? focusNode, TextEditingController? controller, Color? backgroundColor, double? borderRadius, Widget? suffixIcon, Widget? prefixIcon, String? hintText, TextStyle? hintStyle, ValueChanged<String>? onChange, TextInputType? keyboardType, VoidCallback? sufficsIconClick, VoidCallback? preficsIconClick, int? maxLine = 1}) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      onChanged: onChange,
      style: hintStyle,
      textAlign: TextAlign.left,
      maxLines: maxLine,
      minLines: 1,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        isCollapsed: false,
        filled: true,
        fillColor: backgroundColor ?? const Color(0xff292C35),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(toX(borderRadius ?? 12.84)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(toX(borderRadius ?? 12.84)),
        ),
        suffixIcon: suffixIcon != null ? InkWell(onTap: sufficsIconClick, child: suffixIcon) : null,
        prefixIcon: prefixIcon != null ? InkWell(onTap: preficsIconClick, child: prefixIcon) : null,
        hintText: hintText,
        hintStyle: hintStyle,
      ),
    );
  }
  final _debouncer = Debouncer(milliseconds: 400);

  Widget inputFieldE({
    FocusNode? focusNode,
    TextEditingController? controller,
    Color? backgroundColor,
    double? borderRadius,
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? hintText,
    TextStyle? hintStyle,
    ValueChanged<String>? onChange,
    TextInputType? keyboardType,
    VoidCallback? sufficsIconClick,
    VoidCallback? preficsIconClick,
    int? maxLine = 1,
    BuildContext? context, // Context for SnackBar
    InputType inputType = InputType.generic, // Use this to determine the type of input
  }) {
    controller ??= TextEditingController();
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      onChanged: (value) {
        if (onChange != null) {
          onChange.call(value);
          _debouncer.run(() {
            if (inputType == InputType.email) {
              // Email validation regex pattern
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(value) && context != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid email address'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } else if (inputType == InputType.firstName ||
                inputType == InputType.lastName) {
              // Check if the name length is less than 4 characters
              if (value.length < 4) {
                ScaffoldMessenger.of(context!).showSnackBar(
                  SnackBar(content: Text('${inputType == InputType.firstName ? "First" : "Last"} name must be at least 3 characters long'), duration: Duration(seconds: 2),),
                );
              }
            }
          });
        }
      },
      style: hintStyle,
      textAlign: TextAlign.left,
      maxLines: maxLine,
      minLines: 1,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        isCollapsed: false,
        filled: true,
        fillColor: backgroundColor ?? const Color(0xff292C35),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.84),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.84),
        ),
        suffixIcon: suffixIcon != null ? InkWell(onTap: sufficsIconClick, child: suffixIcon) : null,
        prefixIcon: prefixIcon != null ? InkWell(onTap: preficsIconClick, child: prefixIcon) : null,
        hintText: hintText,
        hintStyle: hintStyle,
      ),
    );
  }


  Widget inputFieldNoBorder({bool enabled = true, VoidCallback? onTap, Key? key, bool autofocus = false, FocusNode? focus, TextEditingController? controller, Color? backgroundColor, double? borderRadius, Widget? suffixIcon, Widget? prefixIcon, String? hintText, TextStyle? hintStyle, ValueChanged<String>? onChange, TextInputType? keyboardType, VoidCallback? sufficsIconClick, VoidCallback? preficsIconClick, int? maxLine = 1, bool ignoreMaxLine = false}) {
    return GestureDetector(
        onTap: () {
          if (!enabled) {
            onTap?.call();
          }
        },
        child: TextFormField(
          key: key,
          autofocus: autofocus,
          enabled: enabled,
          focusNode: focus,
          // initialValue: controller?.text??"",
          controller: controller,
          onChanged: onChange,
          style: hintStyle,
          textAlign: TextAlign.left,
          maxLines: ignoreMaxLine ? null : maxLine,
          minLines: 1,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            isCollapsed: false,
            filled: true,
            fillColor: backgroundColor ?? const Color(0xff292C35),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0.0),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0.0),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0.0),
            ),
            suffixIcon: suffixIcon != null
                ? InkWell(
                onTap: () {
                  sufficsIconClick?.call();
                },
                child: suffixIcon)
                : null,
            prefixIcon: prefixIcon != null ? InkWell(onTap: preficsIconClick, child: prefixIcon) : null,
            hintText: hintText,
            hintStyle: hintStyle,
          ),
        ));
  }




  Widget button(String title, VoidCallback? onTap, {double? width, double? height, bool enabled = true, bool progressVisible = false, double radius = 14, Color? enabledColor, Color? disabledColor}) {
    return InkWell(
        onTap: () {
          if (FiBaseState.currentContext != null) {
            FocusScopeNode focus = FocusScope.of(FiBaseState.currentContext!);
            //if(focus.hasPrimaryFocus){
            focus.unfocus();
            //}
          }
          onTap?.call();
        },
        child: Container(
          width: width ?? toX(344),
          height: height ?? toY(65.52),
          decoration: ShapeDecoration(
            color: enabled ? enabledColor ?? const Color(0xFF0677E8) : disabledColor ?? const Color(0xff0777E8).withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(toX(radius)),
            ),
          ),
          child: ConstraintLayout(
            width: width ?? toX(344),
            height: height ?? toY(65.52),
            children: [
              Padding(padding: EdgeInsets.all(toX(10)), child: Visibility(visible: progressVisible, child: const CircularProgressIndicator())).applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom, height: toY(55), width: toY(55)),
              Text(title,
                  style: TextStyle(
                    color: enabled ? const Color(0xFFF3F5F6) : const Color(0xFFF3F5F6).withOpacity(0.4),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  )).applyConstraint(left: parent.left, right: parent.right, top: parent.top, bottom: parent.bottom)
            ],
          ),
        ));
  }

  showBanner(String title, String body, {dismissable = true, VoidCallback? onClose, String? okButtunTitle, VoidCallback? onOk}) {
    ConstraintId id = ConstraintId("_id");
    showDialog(
        context: resources.context!,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => dismissable,
              child: SimpleDialog(
                backgroundColor: const Color(0xff141620),
                title: ConstraintLayout(
                  children: [
                    Text(title,
                        style: const TextStyle(
                          color: Color(0xFFF9F8FF),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.88,
                        )).applyConstraint(id: id, left: parent.left, top: parent.top),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(resources.context!).pop();
                          onClose?.call();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFF9F8FF),
                        )).applyConstraint(right: parent.right, top: id.top, bottom: id.bottom),
                  ],
                ),
                insetPadding: EdgeInsets.only(top: 20, bottom: display.height - (display.height / 3)),
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Container(
                        width: display.width / 3,
                        height: 2,
                        color: const Color(0xFFF9F8FF),
                      )),
                  const Text(""),
                  Center(
                      child: Text(
                        body,
                        style: const TextStyle(
                          color: Color(0xFFF9F8FF),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.normal,
                          letterSpacing: -0.88,
                        ),
                      )),
                  const Text(""),
                  if (okButtunTitle != null)
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: button(okButtunTitle, () {
                          Navigator.of(resources.context!).pop();
                          onOk?.call();
                        }, width: display.width / 2, height: 40))
                ],
              ));
        });
  }

  handlePushNotification(RemoteMessage event) {
    var body = event.data["Body"];
    var type = event.data["Type"];
    if (type == "0") {
      if (event.data.containsKey("Arguments")) {
        var json = convert.jsonDecode(event.data["Arguments"]) as Map<String, dynamic>;
        if (json.containsKey("sms_code")) {
          uiElements.showBanner(localise("focusinbox"), body, okButtunTitle: localise("us_this_code"), onOk: () {
            // registrationModel.useSmsCode(json["sms_code"]); //TODO: return it
          });
        }
      }
    }
  }

  Widget listButton(String title, AssetImage? image, {Widget? logo, VoidCallback? onTap, bool enabled = true, bool inProgress = false, bool showSoonLabel = false,Color iconColor = Colors.white}) {
    ConstraintId offset = ConstraintId("offset$title");
    ConstraintId imageId = ConstraintId("image_$title");
    ConstraintId titleId = ConstraintId("title_$title");
    return InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          width: toX(344),
          height: toY(80),
          decoration: ShapeDecoration(
            color: const Color(0xFF292C35),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: ConstraintLayout(
            width: toX(344),
            height: toY(80),
            children: [
              Container(color:Colors.transparent).applyConstraint(id:offset,left: parent.left,top: parent.top,bottom: parent.bottom,width: toX(21)),
              if (logo == null && image != null) Image(image: image,color: iconColor,).applyConstraint(left: offset.right, top: parent.top, bottom: parent.bottom, id: imageId,width: toX(30),height: toX(30)),
              if (logo != null) logo.applyConstraint(left: offset.right, top: parent.top, bottom: parent.bottom, id: imageId),
              Padding(padding:EdgeInsets.only(left: toX(10),right: toX(10)),child:Text(
                title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: enabled ? Colors.white : const Color(0xffA0A1A5),
                  fontSize: toY(24),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.48,
                ),
              )).applyConstraint(left: parent.left, right: parent.right, top: parent.top, bottom: parent.bottom, id: titleId),
              if (showSoonLabel)
                Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(-0.79),
                  child: Text(
                    localise("soon"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xffA0A1A5),
                      fontSize: toY(24),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.48,
                    ),
                  ),
                ).applyConstraint(right: parent.right, bottom: parent.bottom)
            ],
          ),
        ));
  }

  PopupMenuButton popupMenu(List<PopupMenuItem> items, Widget icon, BoxConstraints size, Offset offset) {
    return PopupMenuButton(
      constraints: size,
      offset: offset,
      color: const Color(0xFF373C48),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 0.50, color: Color(0xffFFFFFF)),
        borderRadius: BorderRadius.circular(toX(10)),
      ),
      itemBuilder: (context) => items,
      icon: icon,
    );
  }

  PopupMenuItem pageMenuItemWithSubtitle(String title, String subtitle, Image sufficsImage, VoidCallback callback) {
    ConstraintId prefixIconId = ConstraintId("prefixIconId_$title");

    ConstraintId titleId = ConstraintId("title_$title");
    return PopupMenuItem(
        onTap: callback,
        child: ConstraintLayout(
          children: [
            sufficsImage.applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom, id: prefixIconId),
            Padding(
                padding: EdgeInsets.only(left: toX(5)),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: toY(14),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                )).applyConstraint(left: prefixIconId.right, top: parent.top, id: titleId),
            Padding(
                padding: EdgeInsets.only(left: toX(5)),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: toY(10),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                )).applyConstraint(left: prefixIconId.right, top: titleId.bottom)
          ],
        ));
  }

  PopupMenuItem pageMenuItem(String title, Widget sufficsImage, VoidCallback callback) {
    ConstraintId prefixIconId = ConstraintId("prefixIconId_$title");

    ConstraintId titleId = ConstraintId("title_$title");
    return PopupMenuItem(
        onTap: callback,
        child: ConstraintLayout(
          children: [
            sufficsImage.applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom, id: prefixIconId),
            Padding(
                padding: EdgeInsets.only(left: toX(5)),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: toY(15),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                )).applyConstraint(left: prefixIconId.right, top: parent.top, bottom: parent.bottom, id: titleId),
          ],
        ));
  }

  Widget avatar(FiContact contact, {double radius = 50, Color color = Colors.white, Color foregroundColor = const Color(0xFF666666), double fontSize = 18, bool changeAllowed = false, ValueChanged<XFile>? onImageChange}) {
    if (contact.avatar != null) {
      return GestureDetector(
          onTap: () async {
            /*    if (changeAllowed) {
              XFile? file = await CxMediaUtils.loadGalleryImage();
              if (file != null) {
                onImageChange?.call(file);
              }
            }*/ ////TODO: RETURN IT
          },
          child: CircleAvatar(
            radius: toX(radius) / 2,
            backgroundColor: color,
            child: ClipOval(
              child: RawImage(
                image: contact.avatar!,
                fit: BoxFit.fill,
                width: toX(radius),
                height: toX(radius),
              ),
            ),
          ));
    } else {
      String initials = "";
      List<String> array = contact.name.split(" ");
      if (array.length > 1) {
        initials = "${array.first.characters.first.toUpperCase()}${array.last.characters.first.toUpperCase()}";
      } else {
        try {
          initials = contact.name.characters.first.toUpperCase();
        } catch (_) {
          initials = "ERROR NAME: ${contact.name}";
        }
      }

      return GestureDetector(
        /*  onTap: () async {
            if (changeAllowed) {
              XFile? file = await CxMediaUtils.loadGalleryImage();
              if (file != null) {
                onImageChange?.call(file);
              }
            }
          },*///TODO: RETURN IT
          child: CircleAvatar(
            backgroundColor: color,
            radius: toX(radius) / 2,
            child: ConstraintLayout(
              children: [
                Text(
                  initials,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: toY(fontSize),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.60,
                  ),
                ).applyConstraint(left: parent.left, right: parent.right, top: parent.top, bottom: parent.bottom),
              ],
            ),
          ));
    }
  }

  Widget contactName(String name, {String? additionalInfo}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: name,
            style: TextStyle(
              color: Colors.white,
              fontSize: toY(14),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          if (additionalInfo != null)
            TextSpan(
              text: ' ',
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(14),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          if (additionalInfo != null)
            TextSpan(
              text: additionalInfo,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(14),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  Widget contactPhone(String phone) {
    return Text(
      phone,
      style: TextStyle(
        color: const Color(0xFFAAAAAA),
        fontSize: toY(14),
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget sharedBy(String name) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: localise("shared_by"),
            style: TextStyle(
              color: const Color(0xFFAAAAAA),
              fontSize: toY(14),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: name,
            style: TextStyle(
              color: const Color(0xFF06E896),
              fontSize: toY(14),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget knowAs(String name, {double maxWidth = -1}) {
    String text = localise("known_as");
    text = text.replaceFirst("‘#’", "‘$name’");

    TextStyle style = TextStyle(
      color: const Color(0xFFAAAAAA),
      fontSize: toY(14),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    );
/*    if (maxWidth > 0) {
      double width = CxTextUtils.stringWidth(text, style);
      if (width >= maxWidth) {
        text = localise("known_as");
        text = text.replaceFirst("‘#’", "‘$name’\n\t");
      }
    }*///TODO: RETURN IT
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '* ',
            style: style,
          ),
          TextSpan(
            text: text,
            style: style,
          ),
        ],
      ),
    );
  }

  Widget contactRow(int index, FiContact contact, {String favoriteKey = "", bool favoriteVisible = false, String addUserKey = "", bool addContactVisible = false, VoidCallback? onFavoriteClick, VoidCallback? onAddUserClick, VoidCallback? onItemClick}) {
    ConstraintId avatarId = ConstraintId("avatarId_$index");
    ConstraintId titleId = ConstraintId("titleId_$index");
    ConstraintId sharedById = ConstraintId("sharedById_$index");
    ConstraintId phonenumberId = ConstraintId("phonenumberId_$index");
    ConstraintId knowAsId = ConstraintId("knowAsId_$index");

    bool sharedByInfoExist = contact.sharedBy != null && contact.sharedBy!.isNotEmpty;
    bool localNameExist = contact.localName != null && contact.localName!.isNotEmpty;

    if (contact.isDivider) {
      ConstraintId dividerId = ConstraintId("dividerId_$index");
      return ConstraintLayout(
        width: display.width,
        height: toY(31),
        children: [
          Container(color: Colors.transparent).applyConstraint(left: parent.left, right: parent.right, bottom: parent.bottom, top: parent.top, width: display.width, height: toY(41)),
          Padding(
              padding: EdgeInsets.only(left: toX(12)),
              child: Text(
                contact.divider,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: toX(14),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              )).applyConstraint(id: dividerId, left: parent.left, top: parent.top),
          const DottedLine(
            dashColor: Color(0xff3E3E3E),
          ).applyConstraint(left: parent.left, top: dividerId.bottom),
        ],
      );
    }
    return InkWell(
        onTap: () {
          // onFavoriteClick?.call();
          onAddUserClick?.call();
          onItemClick?.call();
        },
        child: ConstraintLayout(
          width: display.width,
          height: wrapContent,
          children: [
            uiElements.avatar(contact).applyConstraint(id: avatarId, left: parent.left, top: parent.top),
            Padding(padding: EdgeInsets.only(left: toX(12)), child: uiElements.contactName(contact.name)).applyConstraint(id: titleId, left: avatarId.right, top: avatarId.top),
            Padding(padding: EdgeInsets.only(left: toX(12)), child: uiElements.contactPhone(contact.phoneNumber)).applyConstraint(id: phonenumberId, left: avatarId.right, top: titleId.bottom),
            Visibility(visible: sharedByInfoExist, child: Padding(padding: EdgeInsets.only(left: toX(12)), child: uiElements.sharedBy(contact.sharedBy ?? ""))).applyConstraint(id: sharedById, left: avatarId.right, top: phonenumberId.bottom),
            Visibility(visible: localNameExist, child: Padding(padding: EdgeInsets.only(left: toX(12)), child: uiElements.knowAs(contact.localName ?? "", maxWidth: display.width - toX(100)))).applyConstraint(id: knowAsId, left: avatarId.right, top: sharedById.bottom),
            Container(color: Colors.transparent).applyConstraint(left: parent.left, right: parent.right, bottom: parent.bottom, top: phonenumberId.bottom, width: display.width, height: toY(100 + (localNameExist ? 20 : 0))),
            const Divider(height: 3, thickness: 1, color: Color(0xff3E3E3E)).applyConstraint(left: parent.left, right: parent.right, bottom: parent.bottom, top: knowAsId.bottom, width: matchConstraint, height: 3),
            Visibility(
                visible: favoriteVisible,
                child: GestureDetector(onTap: onFavoriteClick,child:Padding(
                    padding: EdgeInsets.only(right: toX(12)),
                    child: Image(
                      image: AssetImage(contact.isFavorite ? "assets/images/favorite_selected.png" : "assets/images/favorite.png"),
                    )))).applyConstraint(top: phonenumberId.top, right: parent.right, width: toX(32), height: toY(18)),
            Visibility(
                visible: addContactVisible,
                child: Padding(
                    padding: EdgeInsets.only(right: toX(0)),
                    child: const Image(
                      image: AssetImage("assets/images/selected_contact.png"),
                    ))).applyConstraint(left: parent.left, bottom: avatarId.bottom, width: toX(16), height: toX(16))
          ],
        ));
  }

  Widget favoriteWidget(FiContact contact, {bool removeButtonVisible = false, VoidCallback? onRemoveClick}) {
    String name = contact.name;
    List<String> names = name.split(" ");
    if (names.length > 1) {
      name = "${names.first}.${names.last.characters.first.toUpperCase()}";
    }
    return ConstraintLayout(
      width: toX(70),
      height: toX(70),
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xff0677E8),
          radius: toX(54) / 2,
          child: uiElements.avatar(contact),
        ).applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom, right: parent.right),
        Visibility(
            visible: removeButtonVisible,
            child: InkWell(
                onTap: onRemoveClick,
                child: Padding(
                    padding: EdgeInsets.only(top: toY(10), left: toX(54 / 2)),
                    child: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    )))).applyConstraint(
          right: parent.center,
          top: parent.top,
          width: toX(17),
          height: toX(17),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: toY(13),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              // height: 1.20,
            ),
          ),
        ).applyConstraint(left: parent.left, right: parent.right, bottom: parent.bottom)
      ],
    );
  }

  Widget addContactButton(VoidCallback? onTap) {
    return ConstraintLayout(
      width: toX(80),
      height: toX(80),
      children: [
        InkWell(
          onTap: onTap,
          child: const Image(
            image: AssetImage("assets/images/add_user_plus.png"),
          ),
        ).applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom, width: toX(54), height: toX(54)),
      ],
    );
  }

  Widget addSmallButton(double size, {VoidCallback? callback, Color? backgroundColor, Color? iconColor}) => InkWell(
      onTap: callback,
      child: CircleAvatar(
        radius: toX(size) / 2,
        backgroundColor: backgroundColor,
        child: ClipOval(
          child: Center(
              child: Icon(
                Icons.add,
                color: iconColor,
                size: size * 2 / 3,
              )),
        ),
      ));

  Widget createItem(String text, Image leftImage, Image rightImage, {bool upperCase = true, bool rightImageVisible = true, VoidCallback? leftImageClick, VoidCallback? rightImageClick, VoidCallback? onItemClick, Size leftImageSize = const Size(20, 20), Size rightImageSize = const Size(20, 20), double width = 344, double height = 67}) {
    ConstraintId leftImageId = ConstraintId("leftImageId_for_$text");
    ConstraintId rightImageId = ConstraintId("rightImageId_for_$text");
    return InkWell(
        onTap: () {
          onItemClick?.call();
        },
        child: Container(
          width: toX(width),
          height: toY(height),
          decoration: ShapeDecoration(
            color: const Color(0xFF222534),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(toY(12.84)),
            ),
          ),
          child: ConstraintLayout(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: toX(71)),
                  child: Text(
                    upperCase ? text.toUpperCase() : text,
                    style: TextStyle(
                      color: const Color(0xFFCACACA),
                      fontSize: toY(15),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.05,
                    ),
                  )).applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom),
              InkWell(onTap: leftImageClick, child: Padding(padding: EdgeInsets.only(left: toX(22)), child: leftImage)).applyConstraint(zIndex: 100, id: leftImageId, left: parent.left, top: parent.top, bottom: parent.bottom, width: leftImageSize.width + toX(22), height: leftImageSize.height),
              Visibility(visible: rightImageVisible, child: InkWell(onTap: rightImageClick, child: Padding(padding: EdgeInsets.only(right: toX(22)), child: rightImage))).applyConstraint(zIndex: 100, id: rightImageId, right: parent.right, top: parent.top, bottom: parent.bottom, width: rightImageSize.width + toX(22), height: rightImageSize.height),
            ], //horizontal_menu_dots
          ),
        ));
  }

  FiDialogWidget errorWidget(String text) {
    ConstraintId horizontal = ConstraintId("horizontal");
    ConstraintId textId = ConstraintId("textId");
    return FiDialogWidget(
        Container(
          width: toX(327),
          height: toY(143),
          decoration: ShapeDecoration(
            color: const Color(0xFF292D36),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: toX(0.50), color: const Color(0xFF0677E8)),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: ConstraintLayout(
            children: [
              Guideline(
                id: horizontal,
                horizontal: true,
                guidelinePercent: 0.5,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFE4E5E6),
                  fontSize: toY(18),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.11,
                ),
              ).applyConstraint(id: textId, left: parent.left, right: parent.right, bottom: horizontal.top, top: parent.top),
              Icon(
                Icons.warning,
                color: Colors.blue,
                size: toX(19),
              ).applyConstraint(left: parent.left, right: textId.left, top: textId.top, bottom: textId.bottom, height: matchConstraint),
              button(localise("close"), () {
                Navigator.of(resources.context!).pop();
              }, width: toX(134), height: toY(48))
                  .applyConstraint(left: parent.left, right: parent.right, top: horizontal.bottom, width: toX(134), height: toY(48))
            ],
          ),
        ),
        left: display.width - toX(327),
        top: display.height - toY(213),
        width: toX(327),
        height: toY(143));
  }

  Widget expandedListItem(String text, Image leftImage, Image rightImage, {bool upperCase = true, Widget? expandView, bool isExpanded = false, VoidCallback? onItemClick, bool rightImageVisible = true, Color? bottomColor, double width = 344}) {
    Widget body = expandView ?? Container();
    ConstraintId topId = ConstraintId(text);
    return ConstraintLayout(
      children: [
        if (isExpanded) Container(color: const Color(0xFF222534)).applyConstraint(top: topId.center, left: parent.left, right: parent.right, height: toY(67)),
        createItem(text, leftImage, rightImage, upperCase: upperCase, width: width, onItemClick: onItemClick, rightImageVisible: rightImageVisible).applyConstraint(zIndex: 100, id: topId, left: parent.left, right: parent.right, top: parent.top, height: toY(67)),
        if (isExpanded)
          Container(
            decoration: ShapeDecoration(
              color: bottomColor ?? const Color(0xFF767B80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(toX(12.84)),
                  bottomRight: Radius.circular(toX(12.84)),
                ),
              ),
            ),
            child: ConstraintLayout(
              children: [body.applyConstraint(left: parent.left, right: parent.right, top: parent.top, bottom: parent.bottom)],
            ),
          ).applyConstraint(zIndex: 10, top: topId.bottom, left: parent.left, right: parent.right, bottom: parent.bottom, height: matchConstraint)
      ],
    );
  }

  showInputDialog({required String title, required ValueChanged<String> onChange,TextInputType keyboardType = TextInputType.text}) {
    final StringBuffer buffer = StringBuffer() ;
    showDialog(
        barrierDismissible: false,
        context: resources.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.only(bottom: display.height / 2 - toY(216) / 2),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                  width: toX(327),
                  height: toY(216),
                  child: Stack(
                    children: [
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            decoration: ShapeDecoration(
                              color: const Color(0xFF292D36),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 0.50, color: Color(0xFF0677E8)),
                                borderRadius: BorderRadius.circular(toY(20)),
                              ),
                            ),
                          )),
                      Positioned(
                          top: toY(24),
                          left: 0,
                          right: 0,
                          child: Center(
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: toY(18),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                ),
                              ))),
                      Positioned(
                          top: toY(84),
                          left: 20,
                          right: 20,
                          child: Center(
                              child: inputField(backgroundColor: Colors.white,keyboardType: keyboardType,onChange: (value){
                                buffer.clear() ;
                                buffer.write(value);
                              }))),
                      Positioned(
                          top: toY(154),
                          left: toX(24),
                          width: toX(134),
                          height: toY(48),
                          child: uiElements.button(localise("no").toUpperCase(), () {
                            Navigator.of(resources.context!).pop();
                          }, enabled: true, radius: 32, enabledColor: const Color(0x192281E3))),
                      Positioned(
                          top: toY(154),
                          right: toX(24),
                          width: toX(134),
                          height: toY(48),
                          child: uiElements.button(localise("add").toUpperCase(), () {
                            Navigator.of(resources.context!).pop();
                            onChange.call(buffer.toString()) ;

                          }, enabled: true, radius: 32)),
                    ],
                  ));
            }),
          );
        });
  }

  showLogoutDialog() {
    showDialog(
      barrierDismissible: false,
      context: resources.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.only(bottom: display.height / 2 - toY(276) / 2),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: toX(327),
              height: toY(276),
              child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: ShapeDecoration(
                          color: const Color(0xFF292D36),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 0.50, color: Color(0xFF0677E8)),
                            borderRadius: BorderRadius.circular(toY(20)),
                          ),
                        ),
                      )),
                  Positioned(
                      top: toY(24),
                      left: 0,
                      right: 0,
                      child: Center(
                          child: Text(
                            localise("logout"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: toY(18),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.11,
                            ),
                          ))),
                  Positioned(
                      top: toY(61),
                      left: 0,
                      right: 0,
                      child: Center(
                          child: Image(
                            image: const AssetImage("assets/images/logout_big.png"),
                            width: toX(100),
                            height: toX(100),
                            fit: BoxFit.fill,
                          ))),
                  Positioned(
                      top: toY(166),
                      left: 0,
                      right: 0,
                      child: Center(
                          child: Text(
                            localise("are_you_sure"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: toY(14),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.71,
                            ),
                          ))),
                  Positioned(
                      top: toY(214),
                      left: toX(24),
                      width: toX(134),
                      height: toY(48),
                      child: uiElements.button(localise("no"), () {
                        Navigator.of(resources.context!).pop();
                      }, enabled: true, radius: 32, enabledColor: const Color(0x192281E3))),
                  Positioned(
                      top: toY(214),
                      right: toX(24),
                      width: toX(134),
                      height: toY(48),
                      child: uiElements.button(localise("yes"), () {
                        applicationModel.logout();
                      }, enabled: true, radius: 32)),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget inputTextForm(int index, String hintText, TextInputType inputType, ValueChanged onChange, String suffixName, {VoidCallback? onSuffixClick, TextEditingController? controller, FiKeyboardHelper? helper, VoidCallback? onFormTap}) {
    //helper?.inputEnabled = itemIndexInFocus == index;

    return uiElements.inputFieldNoBorder(
        onTap: onFormTap,
        enabled: helper?.inputEnabled ?? true,
        autofocus: helper?.inputEnabled ?? false,
        controller: controller,
        suffixIcon: Image(
          image: AssetImage("assets/images/$suffixName.png"),
          width: toX(21),
          height: toX(21),
        ),
        sufficsIconClick: onSuffixClick,
        keyboardType: inputType,
        onChange: onChange,
        borderRadius: toX(12),
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: toY(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          letterSpacing: 1.05,
        ),
        hintText: hintText,
        backgroundColor: const Color(0xff767B80));
  }

  Timer? _timer;

  showOperationCompleteStatus({bool status = true,VoidCallback? completion,String? title,String? subtitle, String? statusText}) {

    ConstraintId textID = ConstraintId("showOperationCompleteStatus_textID");
    ConstraintId titleId = ConstraintId("showOperationCompleteStatus_titleId");
    ConstraintId subTitleId = ConstraintId("showOperationCompleteStatus_subTitleId");
    showDialog(

      barrierDismissible: true,
      context: resources.context!,
      builder: (BuildContext context) {
        _timer = Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
          completion?.call() ;
        });

        return    WillPopScope(
            onWillPop: () => Future.value(false),child:AlertDialog(

          insetPadding: EdgeInsets.only(bottom: display.height / 2 - toY(276) / 2),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: toX(327),
              height: toY(264),
              decoration: ShapeDecoration(
                color: const Color(0xFF292D36),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0xFF0677E8)),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: ConstraintLayout(
                children: [
                  if(title != null)
                    Padding(padding: EdgeInsets.only(top: toY(26)),child:Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: toY(22),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0.08,
                      ),
                    )).applyConstraint(id:titleId,left: parent.left,right: parent.right,top: parent.top),
                  if(subtitle != null)
                    Padding(padding: EdgeInsets.only(top: toY(25)),child:Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: toY(15),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                        letterSpacing: -0.30,
                      ),
                    )).applyConstraint(id:subTitleId,left: parent.left,right: parent.right,top:  title != null ? titleId.bottom : parent.top),
                  Padding(
                      padding: EdgeInsets.only(top: toY(24)),
                      child: Text(
                        (statusText ?? (status ? localise("operation_complete_successfully") : localise("operation_complete_with_error"))),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: toX(22),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0.08,
                        ),
                      )).applyConstraint(id: textID, left: parent.left, right: parent.right, top: subtitle != null ? subTitleId.bottom : title != null ? titleId.bottom : parent.top),
                  Image(
                    image: AssetImage(status ? "assets/images/done.png" : "assets/images/warning.png"),
                  ).applyConstraint(left: parent.left, right: parent.right, top: textID.bottom, bottom: parent.bottom, width: toX(70), height: toX(70)),
                ],
              ),
            );
          }),
        ));
      },
    ).then((value) => (value) {
      if (_timer != null && _timer!.isActive) {

        _timer?.cancel();
        completion?.call() ;
      }
    });
  }



  Widget backButton(VoidCallback? onTap) {
    return Positioned(
        top: toY(50),
        left: toX(20),
        width: toX(32),
        height: toX(32),
        child: InkWell(
            onTap: () {
              onTap?.call();
            },
            child: const Image(
              image: AssetImage("assets/images/back_page.png"),
            )));
  }

  Widget addItem({required String title, required VoidCallback onAdd, bool enabled = true}) {
    return SizedBox(
        height: toY(120),
        child: ConstraintLayout(
          children: [
            InkWell(
                onTap: onAdd,
                child: Image(
                  image: const AssetImage("assets/images/add_user_plus.png"),
                  color: enabled ? null : const Color(0xff292C35),
                )).applyConstraint(left: parent.left, right: parent.right, bottom: parent.center),
            InkWell(
                onTap: onAdd,
                child: Text(
                  title,
                  style: TextStyle(
                    color: enabled ? Colors.white : Colors.white.withOpacity(0.4),
                    fontSize: toY(15),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.30,
                  ),
                )).applyConstraint(left: parent.left, right: parent.right, top: parent.center, bottom: parent.bottom),
          ],
        ));
  }

  showErrMessage(String title, String content, {VoidCallback? onButtonClick, bool dismissable = true}) {
    showDialog(
        barrierDismissible: dismissable,
        context: resources.context!,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () => Future.value(dismissable),
              child: AlertDialog(
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
                                    title,
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
                              top: toY(66),
                              left: 0,
                              right: 0,
                              child: Center(
                                  child: Image(
                                    image: const AssetImage("assets/images/warning.png"),
                                    width: toX(93),
                                    height: toY(82),
                                  ))),
                          Positioned(
                              top: toY(167),
                              // width: toX(250),
                              // height: toY(88),
                              left: toX(39),
                              right: toX(39),
                              child: Text(
                                content,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFE4E5E6),
                                  fontSize: toY(14),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                              )),
                          Positioned(
                              width: toX(134),
                              height: toY(48),
                              left: toX(327) / 2 - toX(134) / 2,
                              // right: toX(24),
                              bottom: toY(15),
                              child: uiElements.button(localise("ok"), () {
                                Navigator.of(resources.context!).pop();
                                onButtonClick?.call();
                              }, radius: 32))
                        ],
                      ),
                    );
                  })));
        });
  }

  showLoadingMessage(String title, String content, {VoidCallback? onButtonClick, bool dismissable = false, bool cancelable = false}) {
    showDialog(
        barrierDismissible: dismissable,
        context: resources.context!,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () => Future.value(dismissable),
              child: AlertDialog(
                  insetPadding: EdgeInsets.only(bottom: display.height / 2 - toY(276) / 2),
                  titlePadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      width: toX(327),
                      height: cancelable ? toY(355) : toY(230),
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
                                    title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: toY(20),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.20,
                                    ),
                                  ))),
                          Positioned(top: toY(66), left: 0, right: 0, child: Center(child: SizedBox(width: toX(93), height: toY(82), child: const CircularProgressIndicator()))),
                          Positioned(
                              top: cancelable ? toY(167) : toY(170),
                              // width: toX(250),
                              // height: toY(88),
                              left: toX(39),
                              right: toX(39),
                              child: Text(
                                content,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFE4E5E6),
                                  fontSize: toY(14),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 2.00,
                                ),
                              )),
                          if (cancelable)
                            Positioned(
                                width: toX(134),
                                height: toY(48),
                                left: toX(327) / 2 - toX(134) / 2,
                                // right: toX(24),
                                bottom: toY(15),
                                child: uiElements.button(localise("cancel"), () {
                                  Navigator.of(resources.context!).pop();
                                  onButtonClick?.call();
                                }, radius: 32))
                        ],
                      ),
                    );
                  })));
        });
  }

  void dismissLoading() {
    Navigator.of(resources.context!).pop();
  }

  Widget applicationTitle() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'FOCUS',
            style: TextStyle(
              color: Colors.white,
              fontSize: toY(43),
              fontFamily: 'Caros Soft',
              fontWeight: FontWeight.w700,
              letterSpacing: 10.96,
            ),
          ),
          TextSpan(
            text: 'INBOX',
            style: TextStyle(
              color: const Color(0xFF0677E8),
              fontSize: toY(43),
              fontFamily: 'Caros Soft',
              fontWeight: FontWeight.w700,
              letterSpacing: 10.96,
            ),
          ),
        ],
      ),
    );
  }
}

FiUiElements uiElements = FiUiElements();

const kBackState = "backState";

const kBackStateOnDone = "kBackStateOnDone";

const kGroupType = "kGroupType";

const kTargetGroup = "kTargetGroup";

const kTargetContact = "kTargetContact";

const kSelectedContacts = "kSelectedContacts";

const kActionInPlace = "kActionInPlace";

const kTimeline = "kTimeline";

