
import '../../../models/main/base/fi_model.dart';
import 'cx_notification.dart';

class CxNotificationModel extends FiModel {
  static final CxNotificationModel _instance = CxNotificationModel._internal();
  List<CxNotification> _notifications = <CxNotification>[] ;
  CxNotificationModel._internal();

  factory CxNotificationModel() {
    return _instance;
  }

  int get notificationCount => 1;

  CxNotification notificationAtIndex(int index) {
    return CxNotification(author: "Sasha Balasanov",message: 'Lorem ipsum dolor sit amet, consec\ntetur adipiscing elit. Quisque interdum \nblandit ipsum sed scelerisque.');
  }
}

CxNotificationModel notificationModel = CxNotificationModel();