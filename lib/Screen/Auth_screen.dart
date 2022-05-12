

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudfnctiontesting/Widget/Auth%20Form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool  _isLoading = false;


  // Creating or sing in for users
  // Email & password sign up

  void _formForLogIn(String email , String pass , BuildContext ctx) async
  {
    UserCredential _userCred;

    try {
      _userCred = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      setState(() {
        _isLoading = true;
      });
    } on FirebaseException catch(error)
    {
      String? message = "Please check your credential";

      if(error.message != null)
      {
        print(error.message);
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(message.toString()) , backgroundColor: Theme.of(ctx).errorColor,));
      setState(() {
        _isLoading = false;
      });
    }
    catch(error)
    {
      print(error);
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(error.toString().split("]").last) , backgroundColor: Theme.of(ctx).errorColor,));
      setState(() {
        _isLoading = false;
      });
    }
  }

  ///User Sign UP function
  void _submitAuthForm(String email, String username , String pass , File image , BuildContext ctx) async
  {
    UserCredential _userCred;
    try {
        setState(() {
          _isLoading = true;
        });
        _userCred = await _auth.createUserWithEmailAndPassword(email: email, password: pass);


        ///Uploading image to firebase
        ///also getting usable image URL
        final ref = FirebaseStorage.instance.ref().child('userImage').child(_userCred.user!.uid + '.jpg');

        await ref.putFile(image).whenComplete(() =>null);

        final url = await ref.getDownloadURL();

        ///Storing Extra user data in Firebase
         await _firestore.collection('users').doc(_userCred.user!.uid).set({
          'username' : username,
          'email' : email,
          'userID' : _userCred.user!.uid,
           'url' : url,
           'chatRecord': FieldValue.arrayUnion([{}]),
        }).then((value) {
          setState(() {
            _isLoading = false;
          });
        });
    }
    on FirebaseException catch(error)
    {
        String? message = "Please check your credential";

        if(error.message != null)
          {
            print(error.message);
            message = error.message;
          }
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(message.toString()) , backgroundColor: Theme.of(ctx).errorColor,));
        setState(() {
          _isLoading = false;
        });
    }
    catch(error)
    {
      print(error);
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(error.toString().split("]").last) , backgroundColor: Theme.of(ctx).errorColor,));
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(submitForm: _submitAuthForm , isLoading : _isLoading, loginForm: _formForLogIn,)
    );
  }
}
