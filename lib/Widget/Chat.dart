import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudfnctiontesting/Widget/ChatBubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  final String roomID;
  ChatMessage({required this.roomID});

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _uid = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
            stream: _firebase.collection('chats').doc(widget.roomID).collection('messages').orderBy('time', descending: true).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      message: snapshot.data!.docs[index]['text'],
                      isMe: _uid.currentUser!.uid== snapshot.data!.docs[index]['sender'],
                      keyId: snapshot.data!.docs[index].id,
                      uid: snapshot.data!.docs[index]['sender'],
                    );
                  },
                );
              }
            },
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloudfnctiontesting/Widget/ChatBubble.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class ChatMessage extends StatefulWidget {
//   final String roomID;
//   ChatMessage({required this.roomID});
//
//   @override
//   _ChatMessageState createState() => _ChatMessageState();
// }
//
// class _ChatMessageState extends State<ChatMessage> {
//   final _firebase = FirebaseFirestore.instance;
//   final FirebaseAuth _uid = FirebaseAuth.instance;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: _firebase.collection('chat').orderBy('time', descending: true).snapshots(),
//       builder: (context, AsyncSnapshot snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           //print(_uid.currentUser!.uid == snapshot.data!.docs[3]['sender']);
//           return ListView.builder(
//             reverse: true,
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               return ChatBubble(
//                 message: snapshot.data!.docs[index]['text'],
//                 isMe: _uid.currentUser!.uid== snapshot.data!.docs[index]['sender'],
//                 keyId: snapshot.data!.docs[index].id,
//                 uid: snapshot.data!.docs[index]['sender'],
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }

