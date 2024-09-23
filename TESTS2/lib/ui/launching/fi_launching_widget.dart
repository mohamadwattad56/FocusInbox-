
import 'package:flutter/cupertino.dart';

import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import 'package:flutter/src/material/colors.dart';
import '../utils/fi_ui_elements.dart';
import 'fi_launching_model.dart';




class FiLaunchingWidgetNew extends FiBaseWidget {
  const FiLaunchingWidgetNew({super.key});

  @override
  State<StatefulWidget> createState() => _FiLaunchingState();
}

class _FiLaunchingState extends FiBaseState<FiLaunchingWidgetNew>
{
  bool _isAnimateAllowed = true;
  double opacity = 1 ;
  @override
  void initState() {
    super.initState();
    launchingModel.setState(this);
    _isAnimateAllowed = true ;
    _changeOpacity();
  }

  Future<void> _changeOpacity() async{
    if(_isAnimateAllowed) {
      await Future.delayed(const Duration(milliseconds: 500));

      if(_isAnimateAllowed) {
        setState(() {
          opacity -= 0.1;
          if (opacity <= 0.5) {
            opacity = 1;
          }
         // logger.d("Animated opacity us $opacity");
          _changeOpacity();
        });
      }
    }
  }

  @override
  void dispose() {
    _isAnimateAllowed = false ;
    super.dispose();
  }

  @override
  Widget get content {
    return Stack(
      children: [
        Positioned(
          //left: toX(95),
            top: toY(835),
            width: display.width,
            height: toY(65),
            child: Center(child:Text(
              localise("splash_logan"),
              style: TextStyle(
                color: const Color(0xFFB2B1B1),
                fontSize: toY(14),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                ///letterSpacing: 4.84,
                height: 29/10,
              ),
            ),
            )),
        Positioned(
            left: toX(44),
            top: toY(276),
            child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  width: toX(325),
                  height: toX(325),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(toX(325 / 2))),
                      image: const DecorationImage(image: AssetImage("assets/images/blure_background.png"),
                          fit: BoxFit.fill)),
                ))),
        Positioned(
          left:toX(105),
          right: toX(105),
          top: toY(305),
          bottom: toY(205),
          child: const Image(image: AssetImage("assets/images/alex_splash.png"),fit: BoxFit.fill,),),
     /*   Positioned(
          left: toX(105),
          right: toX(105),
          top: toY(305),
          bottom: toY(205),
          child: Container(
            color: Colors.red, // Change this to any color
          ),
        ),*/

        Positioned(
          //left: toX(45),
          top: toY(735),
          width: display.width,
          height: toY(65),
          child: Center(child:uiElements.applicationTitle()),
        ),
        Positioned(
          left: toX(168),
          top: toY(826),
          child: Container(
            width: toX(77),
            height: toY(3),
            decoration: ShapeDecoration(
              color: const Color(0xFFB2B1B1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        Positioned(
            top: toY(103),
            left: 0,
            right: 0,
            child: Center(
                child: Text(
                  localise("personal_assistant"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: toY(48),
                    fontFamily: 'Vujahday',
                    fontWeight: FontWeight.w400,
                    height: 32/48,
                  ),
                )))
      ],
    );
  }




}