import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudfnctiontesting/Model/Functions.dart';
import 'package:cloudfnctiontesting/Screen/Single%20Chat%20Screen.dart';
import 'package:cloudfnctiontesting/Widget/SearchBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Chat_screen.dart';

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String _searchContent = '';
  final _firebase = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void search(String content) {
    setState(() {
      _searchContent = content;
    });
  }

  //_auth.currentUser!.uid, data[index]['userID']
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
    return Column(
      children: [
        SearchBar(
          search: search,
        ),
        Expanded(
            child: StreamBuilder(
          stream: _searchContent.isEmpty ? _firebase.collection('users').snapshots() : _firebase.collection('users').where('username', isEqualTo:  _searchContent).snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapshot.data == null)
              {
                return const Center(child: Text("We don't have any Users!!"),);
              }
            else {
              var data = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return
                      _auth.currentUser!.uid != data[index]['userID'] ?
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data[index]['url']),
                          ),
                          title: Text(data[index]['username']),
                          subtitle: Text(data[index]['email']),
                          onTap: () {
                            goToChatRoom(_auth.currentUser!.uid, data[index]['userID']);
                          },
                        ),
                    ) : Container();
                  });
            }
          },
        ))
      ],
    );
  }
}
