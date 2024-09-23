import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../utils/fi_display.dart';
import '../../../utils/fi_resources.dart';
import '../../../utils/list/fi_multi_list_actions_data_source.dart';
import '../../../utils/list/fi_multi_list_collapsed_widget.dart';
import '../../../utils/list/fi_multi_list_data_source.dart';
import '../../../utils/list/fi_multi_list_expanded_widget.dart';
import '../../../utils/list/fi_multi_list_item.dart';

import '../../../utils/list/fi_multi_type_list.dart';
import '../../base/fi_base_state.dart';
import '../../base/fi_base_widget.dart';

import '../../utils/fi_ui_elements.dart';
import 'fi_settings_tab_model.dart';

const emailSettingsIndex = 0;

const calendarSettingsIndex = 1;

const socialSettingsIndex = 2;

const notificationSettingsIndex = 3;

const loginOrganizationSettingsIndex = 4;

const inviteCoworkerSettingsIndex = 5;

const personalInformationSettingsIndex = 6;

const versionNameSettingsIndex = 7;

const logoutFromAccountSettingsIndex = 8;

const feedbackSettingsIndex = 9;

class _TimePickerDataModel {
  int maxValue;

  int value;

  _TimePickerDataModel({required this.value, required this.maxValue});
}

class FiSettingsTabWidget extends FiBaseWidget {
  const FiSettingsTabWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FiSettingsTabState();
}

class _FiSettingsTabState extends FiBaseState<FiSettingsTabWidget> {
  late StreamSubscription<bool> keyboardSubscription;
  Map<int, bool> expandedListController = {};
  _TimePickerDataModel? _hoursModel = _TimePickerDataModel(value: DateTime.now().hour, maxValue: 24);

  _TimePickerDataModel? _minuteModel = _TimePickerDataModel(value: DateTime.now().minute, maxValue: 60);

  _TimePickerDataModel? _secondsModel = _TimePickerDataModel(value: DateTime.now().second, maxValue: 60);

  FiMultiListDataSource dataSources = FiMultiListDataSource();

  @override
  void initState() {
    settings.setState(this);
    initDataSource();
    super.initState();
  }

  @override
  void dispose() {
    settings.setState(null);
    super.dispose();
  }

  @override
  Widget get content {
    return Stack(
      children: [
        Positioned(
            top: toY(53),
            height: toY(40),
            left: 0,
            right: 0,
            child: Center(
                child: Text(
              localise("settings").toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(27),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 1.35,
              ),
            ))),
        Positioned(top: toY(130), left: toX(0), right: toX(0), bottom: toY(30), child: FiMultiTypeList(dataSource: dataSources)),
      ],
    );
  }

  initDataSource() {
      initDataSourceForPersonal();
  }

/*
  initDataSourceForBusiness() {
    CxMultiListActionDataSource emailActions = CxMultiListActionDataSource(action: settings.emailAction, items: settings.valuesAsStrings(CxSettingsTabModel.kEmails));

    CxMultiListActionDataSource calendarActions = CxMultiListActionDataSource(action: settings.calendarAction, items: settings.valuesAsStrings(CxSettingsTabModel.kCalendar));

    CxMultiListActionDataSource socialActions = CxMultiListActionDataSource(action: settings.socialAction, items: settings.valuesAsStrings(CxSettingsTabModel.kSocials));

    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        title: localise("my_emails_account"),
        prefixImageName: "settings_email.png",
      ),
      expandedWidget: CxMultiListExpandedActionListWidget(
        actionDataSource: emailActions,
      ),
    ));

    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        title: localise("my_calendar_accounts"),
        prefixImageName: "settings_calendar.png",
      ),
      expandedWidget: CxMultiListExpandedActionListWidget(
        actionDataSource: calendarActions,
      ),
    ));

    dataSources.add(CxMultiListItem(
        collapsedWidget: CxMultiLisCollapsedWidget(
          title: localise("my_social_accounts"),
          prefixImageName: "social_accounts.png",
        ),
        expandedWidget: CxMultiListExpandedActionListWidget(
          actionDataSource: socialActions,
        )));

    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        title: localise("notification_settings"),
        prefixImageName: "settings_notification.png",
      ),
      expandedWidget: CxMultiListCustomExpandedWidget(
        custom: notificationSettings,
        height: toY(250),
      ),
    ));

    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        title: localise("login_to_organization_settings"),
        prefixImageName: "settings_login.png",
        sufficsImageName: "horizontal_menu_dots.png",
        onTap: settings.loginToOrganization,
      ),
    ));

    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        title: localise("invite_coworker"),
        prefixImageName: "settings_invite.png",
        sufficsImageName: "horizontal_menu_dots.png",
        onTap: settings.inviteCoworker,
      ),
    ));

    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        title: localise("personal_information"),
        prefixImageName: "info_big.png",
        sufficsImageName: "horizontal_menu_dots.png",
        onTap: settings.showPersonalInformation,
      ),
    ));

    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        custom: ConstraintLayout(
          children: [
            Text(
              settings.applicationVersionName,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(20),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                height: 1.20,
              ),
            ).applyConstraint(left: parent.left, right: parent.right, top: parent.top, bottom: parent.bottom),
          ],
        ),
      ),
    ));

    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
          title: localise("logout_from_account"),
          prefixImageName: "settings_logout.png",
          sufficsImageName: "horizontal_menu_dots.png",
          onTap: () {
            uiElements.showLogoutDialog();
          }),
    ));

    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        title: localise("feedback"),
        prefixImageName: "settings_feedback.png",
        sufficsImageName: "horizontal_menu_dots.png",
        onTap: settings.showFeedbackScreen,
      ),
    ));
  }
*/

  initDataSourceForPersonal() {
    dataSources.add(FiMultiListItem(
      collapsedWidget: FiMultiLisCollapsedWidget(
        title: localise("personal_information"),
        prefixImageName: "info_big.png",
        sufficsImageName: "horizontal_menu_dots.png",
        onTap: settings.showPersonalInformation,
      ),
    ));


    dataSources.add(FiMultiListItem(
      collapsedWidget: FiMultiLisCollapsedWidget(
        title: localise("notification_settings"),
        prefixImageName: "settings_notification.png",
      ),
      expandedWidget:FiMultiListCustomExpandedWidget(
        custom: notificationSettings,
        height: toY(250),
        onRefreshInit: (callback){
          settings.setNotificationRefreshCallback(callback) ;
        },
      ),
    ));



/*    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        title: localise("invite_to_connectx"),
        prefixImageName: "settings_invite.png",
        sufficsImageName: "horizontal_menu_dots.png",
        onTap: settings.inviteCoworker,
      ),
    ));*/

/*    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        custom: ConstraintLayout(
          children: [
            Text(
              settings.applicationVersionName,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(20),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                height: 1.20,
              ),
            ).applyConstraint(left: parent.left, right: parent.right, top: parent.top, bottom: parent.bottom),
          ],
        ),
      ),
    ));*/

    dataSources.add(FiMultiListItem(
      collapsedWidget: FiMultiLisCollapsedWidget(
          title: localise("logout_from_account"),
          prefixImageName: "settings_logout.png",
          sufficsImageName: "horizontal_menu_dots.png",
          onTap: () {
            uiElements.showLogoutDialog();
          }),
    ));

/*    dataSources.add(CxMultiListItem(
      collapsedWidget: CxMultiLisCollapsedWidget(
        title: localise("feedback"),
        prefixImageName: "settings_feedback.png",
        sufficsImageName: "horizontal_menu_dots.png",
        onTap: settings.showFeedbackScreen,
      ),
    ));*/
  }

  Widget _switch(String key) => Switch(
        value: settings.notificationStateFor(key),
        activeTrackColor: const Color(0xff0677E8),
        activeColor: const Color(0xFFFFFFFF),
        inactiveTrackColor: const Color(0x78788052),
        inactiveThumbColor: const Color(0xFFFFFFFF),
        onChanged: (bool value) {
          settings.setNotificationState(key, value);
        },
      );

  Widget notificationSettings(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 0, left: 0, right: 0, bottom: 0, child: Container(color: const Color(0xff131621))),
        Positioned(
            top: toY(25.41),
            left: toX(90),
            child: GestureDetector(
                onTap: () {
                  showTimeChooserDialog(true);
                },
                child: Container(
                  width: toX(66),
                  height: toY(30),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF292C35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      settings.notificationSettings?.allowedFromToString ?? "-",
                      style: TextStyle(
                        color: const Color(0x99CACACA),
                        fontSize: toY(15),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.05,
                      ),
                    ),
                  ),
                ))),
        Positioned(
            top: toY(30.79),
            left: toX(165),
            child: Text(
              '-',
              style: TextStyle(
                color: const Color(0xFFCACACA),
                fontSize: toY(15),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 1.05,
              ),
            )),
        Positioned(
            top: toY(25.41),
            left: toX(183),
            child: GestureDetector(
                onTap: () {
                  showTimeChooserDialog(false);
                },
                child: Container(
                  width: toX(66),
                  height: toY(30),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF292C35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      settings.notificationSettings?.allowedToToString ?? "-",
                      style: TextStyle(
                        color: const Color(0x99CACACA),
                        fontSize: toY(15),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.05,
                      ),
                    ),
                  ),
                ))),
        Positioned(top: toY(25), left: toX(304), width: toX(51), height: toY(31), child: _switch(FiSettingsTabModel.kNotificationManualTime)),
        Positioned(
            top: toY(80),
            width: display.width,
            child: const Divider(
              thickness: 1,
              height: 1,
              color: Color(0xff424242),
            )),
        Positioned(
            left: toX(90),
            top: toY(109),
            child: Text(
              localise("related_to_me"),
              style: TextStyle(
                color: const Color(0xFFCACACA),
                fontSize: toY(15),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 1.05,
              ),
            )),
        Positioned(top: toY(100), left: toX(304), width: toX(51), height: toY(31), child: _switch(FiSettingsTabModel.kNotificationRelatedToMe)),
        Positioned(
            left: toX(90),
            top: toY(167),
            child: Text(
              localise("any"),
              style: TextStyle(
                color: const Color(0xFFCACACA),
                fontSize: toY(15),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 1.05,
              ),
            )),
        Positioned(top: toY(157), left: toX(304), width: toX(51), height: toY(31), child: _switch(FiSettingsTabModel.kNotificationAny)),
      ],
    );
  }

  showTimeChooserDialog(bool from) {
    if (!settings.isManualTimeSetEnabled) {
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: resources.context!,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                  insetPadding: EdgeInsets.only(bottom: display.height / 2 - toY(346) / 2),
                  titlePadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      width: toX(343),
                      height: toY(346),
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
                              left: toX(16),
                              top: toY(20),
                              child: Text(
                                localise("set_time"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: toY(20),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              )),
                          Positioned(top: toX(82), left: toX(20), right: toX(20), bottom: toY(116), child: _time(from, toX(283), toY(156), setState)),
                          Positioned(
                            width: toX(148),
                            height: toY(56),
                            left: toX(16),
                            bottom: toY(16),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child:Container(
                              width: toX(148),
                              height: toY(56),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: Color(0xFF4E4E4E)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x0A000000),
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  localise("cancel"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFFCDCDCD),
                                    fontSize: toY(16),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                          )),
                          Positioned(
                            width: toX(148),
                            height: toY(56),
                            right: toX(16),
                            bottom: toY(16),
                            child: GestureDetector (
                              onTap: (){
                                _setTime(from);
                              },
                              child:Container(
                              width: toX(148),
                              height: toY(56),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: Color(0xFF2281E3)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0xFF2281E3),
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  localise("save"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFFCDCDCD),
                                    fontSize: toY(16),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    );
                  })));
        });
  }

  _setTime(bool from){

  }

  Widget _time(bool from, double width, double height, StateSetter state) {
    if (from) {
      _hoursModel = _TimePickerDataModel(value: (settings.notificationSettings?.allowedHourFrom ?? 0) != 0 ? settings.notificationSettings!.allowedHourFrom : DateTime.now().hour, maxValue: 24);
      _minuteModel = _TimePickerDataModel(value: (settings.notificationSettings?.allowedMinuteFrom ?? 0) != 0 ? settings.notificationSettings!.allowedMinuteFrom : DateTime.now().minute, maxValue: 60);
      _secondsModel = _TimePickerDataModel(value: (settings.notificationSettings?.allowedSecondsFrom ?? 0) != 0 ? settings.notificationSettings!.allowedSecondsFrom : DateTime.now().second, maxValue: 60);
    } else {
      _hoursModel = _TimePickerDataModel(value: (settings.notificationSettings?.allowedHourTo ?? 0) != 0 ? settings.notificationSettings!.allowedHourTo : DateTime.now().hour, maxValue: 24);
      _minuteModel = _TimePickerDataModel(value: (settings.notificationSettings?.allowedMinuteTo ?? 0) != 0 ? settings.notificationSettings!.allowedMinuteTo : DateTime.now().minute, maxValue: 60);
      _secondsModel = _TimePickerDataModel(value: (settings.notificationSettings?.allowedSecondsTo ?? 0) != 0 ? settings.notificationSettings!.allowedSecondsTo : DateTime.now().second, maxValue: 60);
    }

    ConstraintId gl1 = ConstraintId("gl1");
    ConstraintId gl2 = ConstraintId("gl2");
    ConstraintId gl3 = ConstraintId("gl3");
    ConstraintId gl4 = ConstraintId("gl4");
    ConstraintId gl5 = ConstraintId("gl5");
    return ConstraintLayout(
      width: width,
      height: height,
      children: [
        Guideline(
          id: gl1,
          guidelinePercent: 0.35,
          horizontal: true,
        ),
        Guideline(
          id: gl2,
          guidelinePercent: 0.7,
          horizontal: true,
        ),
        Guideline(
          id: gl3,
          guidelinePercent: 0.25,
          horizontal: false,
        ),
        Guideline(
          id: gl4,
          guidelinePercent: 0.5,
          horizontal: false,
        ),
        Guideline(
          id: gl5,
          guidelinePercent: 0.75,
          horizontal: false,
        ),
        //Container(color: Colors.blue,).applyConstraint(left: parent.left,top: parent.top,bottom: parent.bottom,right: parent.right)

        const Divider(
          height: 3,
          thickness: 1,
          color: Color(0xFF4D4D4D),
        ).applyConstraint(left: parent.left, right: parent.right, top: gl1.bottom),
        const Divider(
          height: 3,
          thickness: 1,
          color: Color(0xFF4D4D4D),
        ).applyConstraint(left: parent.left, right: parent.right, top: gl2.top),

        timeSettings(state, _hoursModel!).applyConstraint(left: parent.left, top: parent.top, bottom: parent.bottom, right: gl3.left, width: matchConstraint),
        timeSettings(state, _minuteModel!).applyConstraint(left: gl3.right, top: parent.top, bottom: parent.bottom, right: gl4.left, width: matchConstraint),
        timeSettings(state, _secondsModel!).applyConstraint(left: gl4.right, top: parent.top, bottom: parent.bottom, right: gl5.left, width: matchConstraint),

        _timeDivider.applyConstraint(left: gl3.right, top: gl1.bottom, bottom: gl2.top),
        _timeDivider.applyConstraint(left: gl4.right, top: gl1.bottom, bottom: gl2.top)
        // timeSettings(state) ,
        // timeSettings(state) ,
      ],
    );
  }

  Widget get _timeDivider => Text(
        ':',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: toY(20),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: 0,
        ),
      );

  int tValue = 0;

  Widget timeSettings(StateSetter state, _TimePickerDataModel model) {
    return NumberPicker(
        minValue: 0,
        maxValue: model.maxValue,
        itemCount: 3,
        value: model.value,
        textStyle: TextStyle(
          color: const Color(0xFF4D4D4D),
          fontSize: toY(20),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: 0,
        ),
        selectedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: toY(20),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
        onChanged: (value) {
          state(() {
            model.value = value;
          });
        });
  }
}
