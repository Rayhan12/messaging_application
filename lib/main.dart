import 'package:cloudfnctiontesting/Model/Local_notification_service.dart';
import 'package:cloudfnctiontesting/Screen/Auth_screen.dart';
import 'package:cloudfnctiontesting/Screen/GreenPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screen/Home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> backgroundMessageHandler(RemoteMessage message) async{
  print(message.data);
  print(message.notification!.title);
}



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Firebase Database Testing',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.orange,
            backgroundColor: Colors.deepOrange,
            accentColor: Colors.black,
            accentColorBrightness: Brightness.dark,
            fontFamily: GoogleFonts.poppins().fontFamily,
            buttonTheme: Theme.of(context).buttonTheme.copyWith(
              buttonColor: Colors.orange,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            )
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot)
          {
            if(snapshot.hasData)
              {
                return Home();
              }
            else
              {
                return AuthScreen();
              }
          },
        ),

      routes: {
          GreenPage.routeName : (context) =>const GreenPage(),
      },
    );
  }
}

