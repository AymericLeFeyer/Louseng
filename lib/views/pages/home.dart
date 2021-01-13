import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Louseng"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Here is your dish",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "Click to stir it !",
              style: TextStyle(fontSize: 24),
            ),
            Image.asset("assets/louseng.jpg")
          ],
        ),
      ),
    );
  }
}
