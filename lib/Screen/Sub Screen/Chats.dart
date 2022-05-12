import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudfnctiontesting/Model/Functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Chat_screen.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final _firebase = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void goToChatRoom(String uid1 , String uid2)async
  {
    await ControllerFunction().createChatRoom(uid1,uid2).then((value)
    {
      String roomID = "";
      ControllerFunction().getChatRoomID(uid1,uid2).then((value) {
        roomID=value;
      }
      ).then((value) => Navigator.of(context).push(MaterialPageRoute(builder:(context)=> ChatScreen(roomID: roomID,) )));

    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firebase.collection('users').doc(_auth.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
           else if(snapshot.connectionState == ConnectionState.none)
            {
              return const Center(child: Text("You don't have a stable Internet Connection!!"),);
            }
          else if(snapshot.data!['chatRecord'].length == 1)
            {
              return const Center(child: Text("You don't have any chats!!"),);
            }
          else {
            final data = snapshot.data!['chatRecord'];
            List otherUsers = ControllerFunction().userChatRooms(data,_auth.currentUser!.uid);
            return StreamBuilder(
              stream: _firebase.collection('users').where('userID',whereIn: otherUsers).snapshots(),
              builder: (context, AsyncSnapshot snap){
                if(snap.connectionState == ConnectionState.waiting)
                  {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                else
                  {
                    final newData = snap.data!.docs;
                    return ListView.builder(
                      itemCount: newData.length,
                      itemBuilder: (context,index){
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
                          child: ListTile(
                            title: Text(newData[index]['username']),
                            //TODO : work here!!!!!!!!!
                            subtitle: StreamBuilder(
                              stream: _firebase.collection('chats').doc('${data[index+1]['id']}').collection('messages').orderBy('time', descending: false).snapshots(),
                              builder: (context ,AsyncSnapshot newSnap){
                                final messages = newSnap.data?.docs;
                                if(newSnap.connectionState == ConnectionState.waiting )
                                  {
                                    return const Text("Loading.....");
                                  }
                                else if(newSnap.connectionState == ConnectionState.none)
                                  {
                                    return const Text("Loading.....");
                                  }
                                else if(newSnap.connectionState == ConnectionState.active)
                                {
                                  return Text(messages[messages.length-1]['text'] , overflow: TextOverflow.ellipsis,);
                                }
                                else{
                                  return const Text("Loading.....");
                                }
                              },

                            ),


                            trailing: StreamBuilder(
                              stream: _firebase.collection('chats').doc('${data[index+1]['id']}').collection('messages').orderBy('time', descending: false).snapshots(),
                              builder: (context ,AsyncSnapshot newSnap){
                                final messages = newSnap.data?.docs;
                                if(newSnap.connectionState == ConnectionState.waiting )
                                {
                                  return const Text("Loading.....");
                                }
                                else if(newSnap.connectionState == ConnectionState.none)
                                {
                                  return const Text("Loading.....");
                                }
                                else if(newSnap.connectionState == ConnectionState.active)
                                {
                                  DateTime dateTime = messages[messages.length-1]['time'].toDate();
                                  return Text("${dateTime.hour}:${dateTime.minute}", overflow: TextOverflow.ellipsis,);
                                }
                                else{

                                  return const Text("Loading.....");
                                }
                              },

                            ),

                            leading: CircleAvatar(
                              backgroundColor: Colors.orange,
                              backgroundImage: NetworkImage(newData[index]['url']),
                          ),
                            onTap: (){
                              goToChatRoom(_auth.currentUser!.uid , newData[index]['userID']);
                            },
                        ),
                        );
                      },
                    );
                  }
              },
            );
          }
        });
  }
}


