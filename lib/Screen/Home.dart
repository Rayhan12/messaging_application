import 'package:cloudfnctiontesting/Model/Local_notification_service.dart';
import 'package:cloudfnctiontesting/Screen/Sub%20Screen/All%20Users.dart';
import 'package:cloudfnctiontesting/Screen/Sub%20Screen/Chats.dart';
import 'package:cloudfnctiontesting/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  Widget? getScreen(int value){
    if(value ==0)
      {
        return Chats();
      }
    else if(value ==1)
      {
        return AllUsers();
      }
  }
  int position = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LocalNotificationService.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message !=null)
        {
          print(message.data);
          print(message.notification!.title);
          print(message.notification!.body);
        }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Ok it dose not work");
        print(message.data);
        print(message.notification!.title);
        print(message.notification!.body);

        LocalNotificationService.display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      if (message.notification != null) {
        print(message.data);
        print(message.notification!.title);
        print(message.notification!.body);

        final routeName = message.data['route'];
        print(routeName);
        Navigator.of(context).pushNamed(routeName);
      }
    });



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert , color: Theme.of(context).primaryIconTheme.color,),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: const [
                    Icon(Icons.logout),
                    SizedBox(width: 8,),
                    Text("Log Out")
                  ],
                ),
                value: "Logout",
              ),
            ],
            onChanged: (itemValue){
              if(itemValue == "Logout")
              {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),

      body: getScreen(position),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message) , label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.search) , label: "Search"),
        ],
        currentIndex: position,
        elevation: 5,
        onTap: (value){
          position = value;
          setState(() {
          });
        },
      ),
    );
  }
}
