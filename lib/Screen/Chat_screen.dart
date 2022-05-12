import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudfnctiontesting/Widget/Chat.dart';
import 'package:cloudfnctiontesting/Widget/New%20message%20input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  final String roomID;

  ChatScreen({ required this.roomID});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print(widget.roomID);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Chat"),
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

      body: Column(
        children: [
          Expanded(child: ChatMessage(roomID: widget.roomID,)),
          const SizedBox(height: 15,),
          MessageInput(roomID: widget.roomID,)
        ],
      ),
      
      
      // StreamBuilder(
      //   stream: _firestore.collection('chats/f0FAKZA0kmZDUEw9Ls3Q/messages').snapshots(),
      //   /// Remember this ==================> AsyncSnapshot <==================
      //   builder: (context, AsyncSnapshot snapshot){
      //     final doc = _firestore.collection('chats/f0FAKZA0kmZDUEw9Ls3Q/messages').snapshots();
      //     return snapshot.connectionState == ConnectionState.waiting ?
      //     const Center(child: CircularProgressIndicator(),) :
      //     ListView.builder(
      //       itemCount: snapshot.data!.docs.length,
      //       itemBuilder: (context,index) => ListTile(
      //         title: Text(snapshot.data!.docs[index]['text']),
      //       ),
      //     );
      //   },
      // ),

      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: (){
      //     FirebaseFirestore.instance.collection('chats/f0FAKZA0kmZDUEw9Ls3Q/messages').add({
      //       'text' : 'This message was added just now!!'
      //     });
      //   },
      // ),
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloudfnctiontesting/Widget/Chat.dart';
// import 'package:cloudfnctiontesting/Widget/New%20message%20input.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Flutter Chat"),
//         actions: [
//           DropdownButton(
//             icon: Icon(Icons.more_vert , color: Theme.of(context).primaryIconTheme.color,),
//             items: [
//               DropdownMenuItem(
//                 child: Row(
//                   children: const [
//                     Icon(Icons.logout),
//                     SizedBox(width: 8,),
//                     Text("Log Out")
//                   ],
//                 ),
//                 value: "Logout",
//               ),
//             ],
//             onChanged: (itemValue){
//               if(itemValue == "Logout")
//               {
//                 FirebaseAuth.instance.signOut();
//               }
//             },
//           )
//         ],
//       ),
//
//       body: Column(
//         children: [
//           Expanded(child: ChatMessage()),
//           const SizedBox(height: 15,),
//           MessageInput()
//         ],
//       ),


      // StreamBuilder(
      //   stream: _firestore.collection('chats/f0FAKZA0kmZDUEw9Ls3Q/messages').snapshots(),
      //   /// Remember this ==================> AsyncSnapshot <==================
      //   builder: (context, AsyncSnapshot snapshot){
      //     final doc = _firestore.collection('chats/f0FAKZA0kmZDUEw9Ls3Q/messages').snapshots();
      //     return snapshot.connectionState == ConnectionState.waiting ?
      //     const Center(child: CircularProgressIndicator(),) :
      //     ListView.builder(
      //       itemCount: snapshot.data!.docs.length,
      //       itemBuilder: (context,index) => ListTile(
      //         title: Text(snapshot.data!.docs[index]['text']),
      //       ),
      //     );
      //   },
      // ),

      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: (){
      //     FirebaseFirestore.instance.collection('chats/f0FAKZA0kmZDUEw9Ls3Q/messages').add({
      //       'text' : 'This message was added just now!!'
      //     });
      //   },
//      ),
//     );
//   }
// }
