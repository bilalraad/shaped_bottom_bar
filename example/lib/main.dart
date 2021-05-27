import 'package:flutter/material.dart';
import 'package:shaped_bottom_bar/models/shaped_item_object.dart';
import 'package:shaped_bottom_bar/utils/shapes.dart';
import 'package:shaped_bottom_bar/shaped_bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {

  List<Widget> screens = [
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.black),
    Container(color: Colors.purple)
  ];
  
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ShapedBottomBar(
          backgroundColor: Colors.blueGrey,
          listItems: [
            ShapedItemObject(iconData: Icons.settings, title: "Settings"),
            ShapedItemObject(
                iconData: Icons.account_balance_outlined, title: "Account"),
            ShapedItemObject(
                iconData: Icons.verified_user_rounded, title: "User"),
            ShapedItemObject(iconData: Icons.login, title: "Logout"),
          ],
          onItemChanged: (position) {
            setState(() {
              this.selectedItem = position;
            });
          },
          shapeColor: Colors.blue,
          selectedIconColor: Colors.white,
          shape: ShapeType.TRIANGLE),
      body: screens[selectedItem],
    );
  }
}
