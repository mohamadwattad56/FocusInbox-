import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../fi_display.dart';
import '../fi_resources.dart';
//ignore: must_be_immutable
abstract class FiMultiListExpandedWidget extends StatefulWidget {
  double? width;

  double? height;

  ValueChanged<bool>? onCollapsedChange;
  ValueChanged<bool>? onKeyboardVisibilityChanged;
  VoidCallback? onRefresh ;
  VoidCallback? onTextBoxClick;
  bool inFocus = false ;
  Color? fullExpandBackground ;

  FiMultiListExpandedWidget({super.key, this.width, this.height,this.fullExpandBackground});

  @override
  State<StatefulWidget> createState();
}
//ignore: must_be_immutable
class FiMultiListExpandedInputTextWidget extends FiMultiListExpandedWidget {
  bool? autofocus;

  bool? enabled;

  FocusNode? focus;

  ValueChanged<String>? onChange;

  TextEditingController? controller;

  TextStyle? hintStyle;

  TextStyle? textStyle;

  bool? ignoreMaxLine;

  int? maxLine;

  TextInputType? keyBoardType;

  Color? backgroundColor;

  Widget? suffixIcon;

  Widget? prefixIcon;

  VoidCallback? preficsIconClick;

  String? hintText;

  VoidCallback? sufficsIconClick;

  FiMultiListExpandedInputTextWidget({super.key, super.width, super.height, this.autofocus, this.enabled, this.focus, this.controller, this.onChange, this.hintStyle, this.ignoreMaxLine, this.maxLine, this.keyBoardType, this.backgroundColor, this.suffixIcon, this.sufficsIconClick, this.prefixIcon, this.hintText});

  @override
  State<StatefulWidget> createState() => _FiMultiListExpandedInputTextWidgetState();
}
//ignore: must_be_immutable
class _FiMultiListExpandedInputTextWidgetState extends State<FiMultiListExpandedInputTextWidget> {
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      //setState(() {
        if(widget.inFocus && !visible){
          widget.inFocus = false ;
        }
        widget.onKeyboardVisibilityChanged?.call(visible);
      //});
    });
    widget.controller ??=TextEditingController() ;
    super.initState();
  }




  @override
  void dispose() {
   // keyboardSubscription.cancel();
    super.dispose();
  }

  final TextStyle style = TextStyle(
    color: Colors.white,
    fontSize: toY(15),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    letterSpacing: 1.05,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: toX(widget.width ?? display.width),
      height: toY(widget.height ?? 67),
      decoration: ShapeDecoration(
        color: widget.fullExpandBackground  ?? widget.backgroundColor ?? const Color(0xFF767B80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(toX(12.84)),
            bottomRight: Radius.circular(toX(12.84)),
          ),
        ),
      ),
      child: ConstraintLayout(
        children: [
          GestureDetector(
              onTap: !widget.inFocus ?  () {
                if(!widget.inFocus) {
                  widget.onTextBoxClick?.call();
                  setState(() {
                    widget.inFocus = true ;
                  });

                }
              } : null,
              child: TextFormField(
                  autofocus: widget.autofocus ?? widget.inFocus,
                  enabled: widget.enabled ??widget.inFocus,
                  focusNode: widget.focus,
                  // initialValue: controller?.text??"",
                 controller: widget.controller,
                  onChanged: (String value){
                    widget.controller?.text = value ;
                    widget.onChange?.call( widget.controller?.text??value) ;
                  },
                  style: widget.textStyle ?? style,
                  textAlign: TextAlign.left,
                  maxLines: widget.ignoreMaxLine ?? false ? null : widget.maxLine ?? 1,
                  minLines: 1,
                  keyboardType: widget.keyBoardType ?? TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    isCollapsed: false,
                    filled: true,
                    fillColor: Colors.transparent,
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
                    suffixIcon: widget.suffixIcon != null
                        ? InkWell(
                            onTap: () {
                              widget.sufficsIconClick?.call();
                            },
                            child: widget.suffixIcon)
                        : null,
                    prefixIcon: widget.prefixIcon != null ? InkWell(onTap: widget.preficsIconClick, child: widget.prefixIcon) : null,
                    hintText: widget.hintText ?? localise("type_here"),
                    hintStyle: widget.hintStyle ?? style,
                  ))).applyConstraint(left: parent.left, right: parent.right, top: parent.top, bottom: parent.bottom, height: matchConstraint),
        ],
      ),
    );
  }
}

typedef CustomWidgetBuilder = Widget Function(BuildContext context);
//ignore: must_be_immutable
class FiMultiListCustomExpandedWidget extends FiMultiListExpandedWidget {
  CustomWidgetBuilder custom;
  VoidCallback? refresh ;
  ValueChanged<VoidCallback>? onRefreshInit ;
  FiMultiListCustomExpandedWidget({super.key, required this.custom, required super.height,this.onRefreshInit});

  @override
  State<StatefulWidget> createState() => _FiMultiListCustomExpandedState();
}

class _FiMultiListCustomExpandedState extends State<FiMultiListCustomExpandedWidget> {
  @override
  void initState() {
    widget.refresh = (){
      setState(() {

      });
    } ;
    widget.onRefreshInit?.call(widget.refresh!);
    super.initState();
  }

  @override
  void dispose() {
    widget.refresh = null ;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ConstraintLayout(
      width: display.width,
      height: widget.height!,
      children: [widget.custom(context).applyConstraint(left: parent.left, right: parent.right, top: parent.top, bottom: parent.bottom)],
    );
  }
}
