import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

class Notificationservice {
  static final Notificationservice _notificationservice =
      Notificationservice._internal();
  factory Notificationservice() {
    return _notificationservice;
  }
  Notificationservice._internal();

  void initAwesomnotification() async {
    AwesomeNotifications().initialize(
        'resource://drawable/ic_notifilogo',
        [
          NotificationChannel(
            channelKey: 'main_channel',
            channelName: 'Main_Channel',
            channelDescription: 'Main channel notification',
            enableLights: true,
          )
        ],
        debug: true);
  }

  void drawnotification() async {
    String timeZOne = await AwesomeNotifications().getLocalTimeZoneIdentifier();
     AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'main_channel',
        title: 'Registration has been Sent',
        body:
            'Thank you for your Registration, please wait for an email reply of your email validation, unfortunately you won\'t be able to sign in till then, thank you for your patient ',
        notificationLayout: NotificationLayout.BigText,
        bigPicture: 'asset://assets/images/Car_icon_alone.png',
      ),
      
      actionButtons: [
        NotificationActionButton(
            key: 'Accept',
            label: 'Dismiss',
            actionType: ActionType.DismissAction ,
            enabled: true,),    
      ],
      
    
      schedule: NotificationInterval(
        interval: 5,
        timeZone: timeZOne,
        repeats: false,
      ),
    );
  }

  void requestpermission() async {
    await AwesomeNotifications().isNotificationAllowed().then((value) => {
          if (!value)
            {AwesomeNotifications().requestPermissionToSendNotifications()}
        });
  }
}
