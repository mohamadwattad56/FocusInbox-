import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import '../launching/fi_launching_model.dart';
import 'fi_registration_model.dart';

class FiGrantPermissionWidget extends FiBaseWidget {
  const FiGrantPermissionWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FiGrantPermissionStateWidget();
}

class _FiGrantPermissionStateWidget
    extends FiBaseState<FiGrantPermissionWidget> {

  @override
  void initState() {
    super.initState();//check this
    registrationModel.setState(this);
  }

  @override
  @protected
  Widget get content => ConstraintLayout(
    width: wrapContent,
    height: wrapContent,
    children: [

      Container(
        child: permissionWidget(),
      ).applyConstraint(
          left: parent.left,
          bottom: parent.bottom,
          top: parent.top,
          right: parent.right
      )
    ],
  );

  Widget permissionWidget() {
    var offsetX = toX(20);
    var offsetY = toY(20);
    return Container(
      width: toX(414),
      height: display.height,
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(offsetY),
          topRight: Radius.circular(offsetX),
          bottomLeft: Radius.circular(offsetX),
          bottomRight: Radius.circular(offsetY),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: toY(82),
            left: toX(73),
            child: SizedBox(
              width: toX(269),
              height: toY(44),
              child:  Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Text(localise('contact_permission'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontSize: toY(27),
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: toY(162),
            left: toY(135),
            child: SizedBox(
              width: toX(136),
              height: toY(207),
              child: Image.asset("assets/images/_permissionIllustration.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: toY(400),
            // left: 36,
            left: 0,
            right: 0,
            child: Align( //ADDED
              alignment: Alignment.center, //ADDED
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: localise("approve_permissions_a"),
                      style: TextStyle(
                        color: const Color.fromRGBO(0x94, 0x94, 0x94, 1.0),
                        fontSize: toY(20),
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: localise("contacts_in_bold"),
                      style: TextStyle(
                        color: const Color.fromRGBO(0x94, 0x94, 0x94, 1.0),
                        fontSize: toY(20), // Adjust the font size as needed
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: localise("approve_permissions_b"),
                      style: TextStyle(
                        color: const Color.fromRGBO(0x94, 0x94, 0x94, 1.0),
                        fontSize: toY(20),
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),


          Positioned(
            top:toY(510),
            //left: 36,
            left: 0,
            right: 0,
            child: Align(//ADDED
              alignment: Alignment.center,//ADDED
              child: Text(localise("permission_explanation"),
                textAlign: TextAlign.center,
                style:  TextStyle(
                  color: const Color.fromRGBO(0x94, 0x94, 0x94, 1.0),
                  fontSize: toY(18),
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1.3,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: toY(30),
            left: toX(35),
            right: toX(35),
            child: SizedBox(
              width: toX(344),
              height: toY(72),
              child: Stack(
                children: [
                  Positioned(
                    top: toY(40),
                    left: toX(19),
                    child: Container(
                      width: toX(344),
                      height: toY(32),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                        color: Color.fromRGBO(0, 0, 0, 0.15000000596046448),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        // applicationModel.openPermissionsSettings();
                        launchingModel.askPermission();
                      },
                      child: SizedBox(
                        width: toX(344),
                        height: toY(67),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: toX(344),
                                height: toY(67),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                    bottomLeft: Radius.circular(14),
                                    bottomRight: Radius.circular(14),
                                  ),
                                  color: Color.fromRGBO(6, 119, 232, 1),
                                ),
                              ),
                            ),
                            Positioned(
                              top: toY(28),
                              left: toX(71),
                              right: toX(71),
                              child: Center(child:Text(localise("allow"),
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: toY(18),
                                  letterSpacing: 0.050000011920928955,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                              ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ),
        ],

      ),
    );
  }
}
