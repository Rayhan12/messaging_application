import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ControllerFunction {
  final _firebase = FirebaseFirestore.instance;

  Future<void> createChatRoom(String uid1, String uid2) async {
    String chatRoomID = uid1 + "||" + uid2;

    bool continueProcess = false;

    ///process
    ///check if chat room exist
    ///if yes skip
    ///if not add data to both user documents
    ///chat room id & time stamp


    await doseChatRoomExist(uid1, uid2).then((value) =>
    continueProcess = value);
    print(continueProcess);
    if (continueProcess == false) {
      try {
        await _firebase.collection('chats').doc(chatRoomID).collection(
            'messages').add({
          'chatRoomID': chatRoomID,
          'sender': 'System',
          'text': "Now you can send each other messages!!",
          'time': Timestamp.now(),
        }).then((empty) {
          _firebase.collection('users').doc(uid1).update({
            'chatRecord': FieldValue.arrayUnion([
              {'id': chatRoomID, 'time': Timestamp.now()}
            ])
          }).then((value) {
            _firebase.collection('users').doc(uid2).update({
              'chatRecord': FieldValue.arrayUnion([
                {'id': chatRoomID, 'time': Timestamp.now()}
              ])
            });
          }).then((empty) {
            return Future<void>.value();
          });
        });
      } on FirebaseException catch (error) {
        print(error.message);
        rethrow;
      }
    } //end of If loop

    else {
      return Future.value();
    }
  }

  Future<bool> doseChatRoomExist(String uid1, String uid2) async {
    final data = await _firebase.collection('users').doc(uid1).get();

    if (data['chatRecord'] != null) {
      final String chatRoom1 = uid1 + "||" + uid2;
      final String chatRoom2 = uid2 + "||" + uid1;

      for (int i = 0; i < data['chatRecord'].length; i++) {
        if (data['chatRecord'][i]['id'] == chatRoom1 ||
            data['chatRecord'][i]['id'] == chatRoom2) {
          return Future.value(true);
        }
      }
      return Future.value(false);
    }
    else {
      return Future.value(false);
    }
  }

  List<String> userChatRooms(List data, String uid) {
    List<String> users = [];

    String uid1, uid2;
    for (int i = 1; i < data.length; i++) {
      var info = data[i]['id'].toString().split("||");
      uid1 = info[0];
      uid2 = info[1];
      if (uid1 == uid) {
        users.add(uid2);
      }
      else {
        users.add(uid1);
      }
    }
    return users;
  }


  Future<String> getChatRoomID(String uid1, String uid2) async
  {
    final data = await _firebase.collection('users').doc(uid1).get();
    final String chatRoom1 = uid1 + "||" + uid2;
    final String chatRoom2 = uid2 + "||" + uid1;

    if (data['chatRecord'].length != 0) {

      for (int i = 0; i < data['chatRecord'].length; i++) {

        if (data['chatRecord'][i]['id'] == chatRoom1)
        {
          return Future<String>.value(chatRoom1);
        }

        if(data['chatRecord'][i]['id'] == chatRoom2)
          {
            return Future<String>.value(chatRoom2);
          }
      }
    }
    return Future<String>.value(chatRoom1);
  }





}
