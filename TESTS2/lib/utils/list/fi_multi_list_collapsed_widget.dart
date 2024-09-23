import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'dart:ui' as ui ;
import '../fi_display.dart';
import '../fi_image_data.dart';
import 'fi_custom_extended_widget.dart';
//ignore: must_be_immutable
class FiMultiLisCollapsedWidget extends StatefulWidget {
  String? title;
  double? width;
  double? height;
  String? prefixImageName;
  Widget? prefixImage;
  Widget? sufficsImage ;
  Size? imageSize;
  String? sufficsImageName;
  bool isExpandWidgetAttached = false;
  VoidCallback? onTap;
  ValueChanged<bool>? onCollapsedChange;
  bool _changeBorderEnabled = false ;
  Widget? custom;
  bool isCollapsed = true;
  bool? keepOriginalImageColor = false ;
  bool? enableGalleryImageSet ;
  VoidCallback? onRefresh ;
  ValueChanged<FiImageData>? onImageChange ;
  Color? fullExpandBackground ;
  String _originalTitle = "" ;
  ValueChanged<bool>? onCollapseChange ;
  bool isDirectTapAllowed = false ;
  bool enabled = true ;

  FiMultiLisCollapsedWidget({
    super.key,
    this.title,
    this.width,
    this.height,
    this.prefixImageName,
    this.sufficsImageName,
    this.imageSize,
    this.onTap,
    this.prefixImage,
    this.sufficsImage,
    this.custom,
    this.keepOriginalImageColor,
    this.enableGalleryImageSet,
    this.onImageChange,
    this.fullExpandBackground,
    this.onCollapseChange,
    this.isDirectTapAllowed = false
  }){
    title = (title??"").toUpperCase() ;
    _originalTitle = title??"" ;

  }

  update({String? title,Widget? imageWidget }){
    this.title = title??this.title ;
    prefixImage = imageWidget ;
    onRefresh?.call() ;
  }

  set changeBorderEnabled(bool changeBorderEnabled) {
    _changeBorderEnabled = changeBorderEnabled ;
    onRefresh?.call() ;
  }

  @override
  State<StatefulWidget> createState() => _FiMultiLisCollapsedWidgetState();

  void updatePrefixImage(FiImageData image){
    if(image.buffer != null ) {
      prefixImageName = null;
      prefixImage = Image.memory(image.buffer!);
      onRefresh?.call();
      onImageChange?.call(image);
    }
  }

  void updateText(String text) {
    title = text ;
    if(title!.isEmpty) {
      title = _originalTitle ;
    }
    onRefresh?.call() ;
  }
}

class _FiMultiLisCollapsedWidgetState extends State<FiMultiLisCollapsedWidget> {


  @override
  void initState() {
    widget.onCollapsedChange = (state) {
      setState(() {
        bool currentState = widget.isCollapsed ;
        widget.isCollapsed = state;
        widget.onCollapseChange?.call(widget.isCollapsed) ;
        if(currentState) {
          setState(() {
            widget.onTap?.call();
          });
        }

      });
    };
    widget.onRefresh = (){
      setState(() {
        if(widget.custom != null && widget.custom is FiCustomExtendedWidget){
          FiCustomExtendedWidget c = widget.custom! as FiCustomExtendedWidget ;
          c.onRefresh?.call();
        }
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    widget.onCollapsedChange = null ;
    widget.onRefresh = null ;
    super.dispose();
  }

  RoundedRectangleBorder _borders(){
    if(widget._changeBorderEnabled){
      return widget.isCollapsed
          ? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(toY(12.84)),
      )
          : RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(toX(12.84)),
          topRight: Radius.circular(toX(12.84)),
        ),
      ) ;
    }

    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(toY(12.84)),
    ) ;

  }


  @override
  Widget build(BuildContext context) {
    Size imageSize = widget.imageSize ?? const Size(35, 35);
    bool sufficsImageExist = widget.sufficsImageName != null && widget.sufficsImage == null;
    bool prefixImageExist = widget.prefixImageName != null || widget.prefixImage != null;

    if (widget.custom == null) {
      return InkWell(
          onTap: widget.isDirectTapAllowed ? widget.onTap : null,
          child: Container(
            width: toX(widget.width ?? display.width),
            height: toY(widget.height ?? 67),
            decoration: ShapeDecoration(
              color: widget.enabled ?  widget.isCollapsed?  const Color(0xFF222534) :widget.fullExpandBackground??const Color(0xFF222534) : const Color(0xFF585859),
              shape: _borders(),
            ),
            child: ConstraintLayout(
              children: [
                if (prefixImageExist && widget.prefixImageName != null) Padding(padding: EdgeInsets.only(left: toX(22)), child: Image(image: AssetImage("assets/images/${widget.prefixImageName!}"), color: widget.keepOriginalImageColor??false ? null :  Colors.white)).applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom, width: toX(imageSize.width + 22), height: toY(imageSize.height)),
                if (prefixImageExist && widget.prefixImage != null) Padding(padding: EdgeInsets.only(left: toX(22)), child: widget.prefixImage!).applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom, width: toX(imageSize.width + 22), height: toY(imageSize.height)),
                if (sufficsImageExist)
                  Padding(
                      padding: EdgeInsets.only(right: toX(22)),
                      child: Image(
                        image: AssetImage("assets/images/${widget.sufficsImageName!}"),
                      )).applyConstraint(right: parent.right, top: parent.top, bottom: parent.bottom, width: toX(imageSize.width + 22), height: toY(imageSize.height)),
                if (!sufficsImageExist && widget.isExpandWidgetAttached && widget.sufficsImage == null)
                  Padding(
                      padding: EdgeInsets.only(right: toX(22)),
                      child: RotatedBox(
                          quarterTurns: widget.isCollapsed ? 135 : 45,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: const Color(0xffA7A7AB),
                            size: toX(18),
                          ))).applyConstraint(right: parent.right, top: parent.top, bottom: parent.bottom, width: toX(imageSize.width + 22), height: toY(imageSize.height)),
                if(widget.sufficsImage != null)
                  Padding(
                      padding: EdgeInsets.only(right: toX(22)),
                      child: widget.sufficsImage!).applyConstraint(right: parent.right, top: parent.top, bottom: parent.bottom, width: toX(imageSize.width + 22), height: toY(imageSize.height)),


                Padding(
                    padding: EdgeInsets.only(left: toX(71)),
                    child: Text(
                      widget.title ?? "" ,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: toY(15),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.05,
                      ),
                    )).applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom)
              ],
            ),
          ));
    } else {
      return InkWell(
          onTap: widget.onTap,
          child: SizedBox(
            width: toX(widget.width ?? 344),
            height: toY(widget.height ?? 67),
            child: ConstraintLayout(
              children: [
                widget.custom!.applyConstraint(left: parent.left, right: parent.right, top: parent.top, bottom: parent.bottom, width: matchConstraint, height: matchConstraint)],
            ),
          ));
    }
  }
}
