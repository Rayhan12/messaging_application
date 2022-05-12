import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatefulWidget {
  final String message;

  final bool isMe;
  final String keyId;
  final String uid;

  ChatBubble(
      {required this.message,
      required this.isMe,
      required this.keyId,
      required this.uid});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    int chatSize = widget.message.length;
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: widget.uid=='System'? MainAxisAlignment.center : widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start ,
      key: ValueKey(widget.keyId),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: chatSize >= 50 ? size.width * (0.65) : null,
          decoration: BoxDecoration(
            color:
                widget.isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomRight:widget.uid=='System'? const Radius.circular(20) : widget.isMe ? const Radius.circular(0) : const Radius.circular(20),
              bottomLeft: widget.uid=='System'? const Radius.circular(20) :widget.isMe ? const Radius.circular(20) : const Radius.circular(0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: widget.isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if(widget.uid != 'System')
              FutureBuilder(
                  future: FirebaseFirestore.instance.collection('users').doc(widget.uid).get(),
                  builder: (context,AsyncSnapshot future) {
                    if (future.connectionState == ConnectionState.waiting) {
                      return const Text("Loading....");
                    } else {
                      return Text(
                        future.data!['username'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.start,
                      );
                    }
                  }),
              Text(
                widget.message,
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontSize: 15.5,
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
