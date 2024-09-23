import 'package:flutter/cupertino.dart';

typedef CustomWidget = Widget Function(BuildContext context);

class FiCustomExtendedWidget extends StatefulWidget{
  final CustomWidget childBuilder;

   FiCustomExtendedWidget({super.key,required this.childBuilder});

  VoidCallback?  onRefresh;

  @override
  State<StatefulWidget> createState() => _FiCustomExtendedWidgetState();

  void update() {
    onRefresh?.call() ;
  }

}

class _FiCustomExtendedWidgetState extends State<FiCustomExtendedWidget>{

  @override
  void initState() {
    widget.onRefresh = (){
      setState(() {

      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context)  =>  widget.childBuilder(context) ;

}