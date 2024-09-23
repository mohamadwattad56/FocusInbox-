import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:image_picker/image_picker.dart';
import '../fi_display.dart';
import '../fi_image_data.dart';
import 'fi_multi_list_collapsed_widget.dart';
import 'fi_multi_list_expanded_widget.dart';
import 'dart:ui' as ui show Image;

class FiMultiListItem extends StatefulWidget {
  ValueChanged<bool>? _onCollapseExpandChange;

  FiMultiLisCollapsedWidget collapsedWidget;

  FiMultiListExpandedWidget? expandedWidget;

  bool _collapsed = true;

  bool isUpdatable = false;

  Color? fullExpandBackground;

  bool isTimeline = false;

  bool isVisible = true;

  bool? autoUpdateTitle;

  bool enabled = true;
  bool isOpen = false ;

  FiMultiListItem({super.key,
    required this.collapsedWidget,
    this.expandedWidget,
    this.autoUpdateTitle = false,
    this.isUpdatable = false,
    this.fullExpandBackground,
    this.isTimeline = false,
    this.isOpen = false,
    this.enabled = true}) {
    collapsedWidget.fullExpandBackground = fullExpandBackground;
    collapsedWidget.isExpandWidgetAttached = expandedWidget != null;
    expandedWidget?.fullExpandBackground = fullExpandBackground;

    if (autoUpdateTitle ?? false) {
      if (expandedWidget != null && expandedWidget is FiMultiListExpandedInputTextWidget) {
        FiMultiListExpandedInputTextWidget widget = expandedWidget as FiMultiListExpandedInputTextWidget;
        ValueChanged<String>? changer = widget.onChange;
        widget.onChange = (text) {
          changer?.call(text);
          collapsedWidget.updateText(text);
        };
      }
    }
  }

  ValueChanged<bool>? _onEnableChange;

  @override
  State<StatefulWidget> createState() => _FiMultiListItemState();

  VoidCallback? onCollapsedItemClick;

  void collapse() => _onCollapseExpandChange?.call(true);

  void expand() => _onCollapseExpandChange?.call(false);

  void setEnabled(bool state) {
    if (enabled != state) {
      enabled = state;
      _onEnableChange?.call(state);
      update() ;
    }
  }

  void update() {
    collapsedWidget.onRefresh?.call() ;
    expandedWidget?.onRefresh?.call() ;
  }
}

class _FiMultiListItemState extends State<FiMultiListItem>  {
  bool disposed = false;

  @override
  void initState() {
    super.initState();

    widget._onEnableChange = _onEnableChange;
    disposed = false;
    widget.expandedWidget?.onRefresh = () => setState(() {});
    widget._onCollapseExpandChange = (bool collapsed) {
      if (widget._collapsed != collapsed) {
        if(disposed) return ;
        setState(() {
          widget._collapsed = collapsed;
          widget.collapsedWidget.onCollapsedChange?.call(widget._collapsed);
          widget.expandedWidget?.onCollapsedChange?.call(widget._collapsed);
        });
      }
    };

    widget.collapsedWidget.changeBorderEnabled = widget.expandedWidget != null;
  }

  ValueChanged<bool> get _onEnableChange => (state) {
    setState(() {});
  };

  @override
  void dispose() {
    disposed = true;

   // widget._onCollapseExpandChange = null ;
   // widget.collapsedWidget.onRefresh = null ;
    widget.collapsedWidget.onCollapseChange = null ;
    widget.collapsedWidget.onTap  = null ;
    widget.collapsedWidget.onImageChange  = null ;
    widget.expandedWidget?.onRefresh = null ;
    widget._onEnableChange = null ;
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    ConstraintId collapsedId = ConstraintId("collapsedId_$hashCode");
    double collapsedHeight = toY(widget.collapsedWidget.height ?? 67);
    double expandedHeight = toY(widget.expandedWidget != null ? widget.expandedWidget!.height ?? 60 : 0);
    widget.collapsedWidget.enabled = widget.enabled;

    return ConstraintLayout(
      height: collapsedHeight + (!widget._collapsed ? expandedHeight : 0),
      children: [
       // Container(color: Colors.blue,).applyConstraint(zIndex: 2, left: parent.left, right: parent.right, top: parent.top, height: collapsedHeight),

        InkWell(
                onTap: () async {
                  if (!widget.enabled) {
                    return;
                  }
                  if (widget.collapsedWidget.enableGalleryImageSet ?? false) {
                    FiImageData? picture = await loadGalleryImage();
                    if (picture != null) {
                      widget.collapsedWidget.updatePrefixImage(picture);
                    }
                  }

                  widget.onCollapsedItemClick?.call();
                },
                child: widget.collapsedWidget)
            .applyConstraint(id: collapsedId, left: parent.left, right: parent.right, top: parent.top, height: collapsedHeight),
        if (!widget._collapsed && widget.expandedWidget != null) widget.expandedWidget!.applyConstraint(left: parent.left, right: parent.right, top: collapsedId.bottom, bottom: parent.bottom, height: matchConstraint),
      ],
    );
  }

  Future<FiImageData?> loadGalleryImage() async {
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return FiImageData(image: image).load();
    }
    return null;
  }
}
