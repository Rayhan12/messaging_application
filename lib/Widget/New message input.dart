import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageInput extends StatefulWidget {
  final String roomID;
  MessageInput({required this.roomID});
  
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  var _message = '';
  bool _state = true;
  final _controller = TextEditingController();

  final user = FirebaseAuth.instance;
  void sendMessage() async{
    await FirebaseFirestore.instance.collection('chats').doc(widget.roomID).collection('messages').add(
        {
          'chatRoomID':widget.roomID,
          'text': _message.trim(),
          'time': Timestamp.now(),
          'sender' : user.currentUser?.uid
        }
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 11,
            spreadRadius: 1,
            blurStyle: BlurStyle.outer,
            offset: Offset(0, -1)
          )
        ]
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15 , vertical: 5),
              child: TextField(
                controller: _controller,
                decoration:  InputDecoration(
                  hintText: _state ? "Aa" :  "Enter a message....",
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                onTap: () {
                  setState(() {
                    _state = false;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _message = value;
                  });
                },
                autocorrect: true,
              ),
            ),
          ),

          IconButton(
            icon: Icon(
                Icons.send, color: Theme.of(context).primaryColor),
            onPressed:_message.trim().isEmpty ? null : (){
              sendMessage();
              FocusScope.of(context).unfocus();

              setState(() {
                _controller.clear();
                _state = true;
              });
            },
          )
        ],
      ),
    );
  }
}
