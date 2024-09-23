import 'package:flutter/material.dart';

import '../../utils/fi_display.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import 'cx_navigation_bar_model.dart';

class FiNavigationBarWidget extends FiBaseWidget {
  const FiNavigationBarWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CxNavigationBarState();
}

class _CxNavigationBarState extends FiBaseState<FiNavigationBarWidget> {
  static const Color selected = Color(0xff0677E8) ;
  static const Color unselected = Color(0xff9B9B9B) ;

  @override
  void initState() {
    super.initState();
    navigationBar.setState(this) ;
  }

  @override
  void dispose() {
    super.dispose();
    navigationBar.setState(null) ;
  }


  @override
  // TODO: implement content
  Widget get content => Stack(
        children: [
          Positioned(top:0,left:0,width:display.width,height:display.height - toY(65),child:navigationBar.tabAtIndex),
         // Positioned(top: toY(848), width: toX(25), height: toX(25), left: toX(36),  child:  GestureDetector(onTap:(){navigationBar.onTabClick(0);},child:Image(image: const AssetImage("assets/images/nb_contacts_icon.png"),color: _tabColor(0),width: toX(25),height: toX(25),))),
          Positioned(top: toY(848), width: toX(25), height: toX(25), left: toX(106), child:  GestureDetector(onTap:(){navigationBar.onTabClick(0);},child:Image(image: const AssetImage("assets/images/nb_contacts_icon.png"),color: _tabColor(1),width: toX(25),height: toX(25),))),
          Positioned(top: toY(811), width: toX(60), height: toY(71), left: toX(177), child:  GestureDetector(onTap:(){navigationBar.onTabClick(2);},child:Image(image: const AssetImage("assets/images/AlexAI.png"),width: toX(25),height: toX(25),))),
      //    Positioned(top: toY(848), width: toX(25), height: toX(25), left: toX(277), child:  GestureDetector(onTap:(){navigationBar.onTabClick(3);},child:Image(image: const AssetImage("assets/images/nb_bell_icon.png"),color: _tabColor(3),width: toX(25),height: toX(25),))),
        //  Positioned(top: toY(848), width: toX(25), height: toX(25), left: toX(354), child:  GestureDetector(onTap:(){navigationBar.onTabClick(4);},child:Image(image: const AssetImage("assets/images/nb_settings_icon.png"),color: _tabColor(4),width: toX(25),height: toX(25),))),

        ],
      );

  Color _tabColor(int index) => navigationBar.selectedIndex == index ? selected :unselected ;


}
