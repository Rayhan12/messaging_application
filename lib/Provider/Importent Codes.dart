


///Main page Code
///past it above the main Function
/// Setting up Firebase Notification
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     importance: Importance.high,
//     playSound: true);
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }
/// Setting up Firebase Notification

///Main Page code
///Past it inside the Main Function after firebase initiate

/// Setting up Firebase Notification
// FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//
// await flutterLocalNotificationsPlugin
//     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
// ?.createNotificationChannel(channel);
//
// await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
// alert: true,
// badge: true,
// sound: true,
// );
/// Setting up Firebase Notification





/// Home Page Code..Just past it
///Setting up Firebase Notification
// @override
// void initState() {
//   super.initState();
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               color: Colors.blue,
//               playSound: true,
//               //icon: '@mipmap/ic_launcher',
//             ),
//           ));
//     }
//   });
//
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print('A new onMessageOpenedApp event was published!');
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       showDialog(
//           context: context,
//           builder: (_) {
//             return AlertDialog(
//               title: Text(notification.title!),
//               content: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [Text(notification.body!)],
//                 ),
//               ),
//             );
//           });
//     }
//   });
// }
///Setting up Firebase Notification


///code for Androied menefest file
///
// <meta-data
// android:name="com.google.firebase.messaging.default_notification_channel_id"
// android:value="easyapproach"
// />