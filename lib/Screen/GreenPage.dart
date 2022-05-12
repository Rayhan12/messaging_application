import 'package:flutter/material.dart';

class GreenPage extends StatelessWidget {

  static const routeName = "greenpage";
  const GreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Green Page"),
      ),
      backgroundColor:  Colors.green,
    );
  }
}
