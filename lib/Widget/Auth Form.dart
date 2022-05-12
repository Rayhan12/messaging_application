import 'dart:io';

import 'package:cloudfnctiontesting/Widget/ImagePicker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm({required this.submitForm, required this.isLoading , required this.loginForm});

  bool isLoading;
  final void Function (String email, String username, String pass,File image , BuildContext context) submitForm;
  final void Function (String email, String pass,BuildContext context) loginForm;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String _userName = "";
  String _userEmail = "";
  String _userPassword = "";
  File ?imageFile;
  bool _isLogin = true;

  final _formKey = GlobalKey<FormState>();

  void _formSave() {
    FocusScope.of(context).unfocus();
    bool _isValidated = _formKey.currentState!.validate();

    if(_isLogin && _isValidated)
      {
        ///Saving the form
        _formKey.currentState!.save();

        ///Using up push
        widget.loginForm(_userEmail.trim(),_userPassword.trim(),context);
      }

    else if (imageFile==null && !_isLogin) {

          Scaffold.of(context).showSnackBar(SnackBar(
            content: const Text("Please uploade an image"),
            backgroundColor: Theme.of(context).errorColor,
          ));
          return;
    }

    if (_isValidated && !_isLogin) {
      ///Saving the form
      _formKey.currentState!.save();

      ///Using up push
      widget.submitForm(_userEmail.trim(), _userName.trim(),_userPassword.trim(), imageFile!, context);
    }
  }

  void getImage(File image) {
    imageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///Getting image from downstream
                  if (!_isLogin)
                    UserImageInput(
                      imageGetter: getImage,
                    ),

                  TextFormField(
                    key: const ValueKey("UserEmail"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(label: Text("Email")),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email address";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _userEmail = value.toString();
                    },
                  ),

                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey("UserName"),
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(label: Text("User Name")),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return "Please enter a username longer then 4 characters";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _userName = value.toString();
                      },
                    ),
                  TextFormField(
                    key: const ValueKey("UserPassword"),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(label: Text("Password")),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return "Please enter a Password longer then 8 characters";
                      } else if (value.isNotEmpty) {
                        var _pass = value.toUpperCase();
                        for (int i = 0; i < value.length; i++) {
                          if (value.characters.characterAt(i) ==
                              _pass.characters.characterAt(i)) {
                            return null;
                          }
                        }
                        return "Password must contain at least 1 uppercase letter";
                      }
                    },
                    onSaved: (value) {
                      _userPassword = value.toString();
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  if (widget.isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (widget.isLoading == false)
                    ElevatedButton(
                      child: Text(_isLogin ? "Login" : "Sing up"),
                      onPressed: _formSave,
                    ),
                  if (widget.isLoading == false)
                    TextButton(
                      child: Text(_isLogin
                          ? "Create new account"
                          : "I already have an Account"),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
