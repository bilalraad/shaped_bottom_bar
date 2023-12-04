import 'package:flutter/material.dart';
import 'package:shaped_bottom_bar/shaped_bottom_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyScreen(),
    );
  }
}

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  List<Widget> screens = List.generate(
    4,
    (index) => Container(color: Colors.white),
  );

  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ShapedBottomBar(
        backgroundColor: Colors.yellow,
        unselectedIconColor: Colors.teal,
        listItems: [
          ShapedItemObject(
            icon: const Icon(Icons.alarm),
            title: 'Alarm',
          ),
          ShapedItemObject(
            icon: const Icon(Icons.menu_book),
            title: 'Menu',
          ),
          ShapedItemObject(
            icon: const Icon(Icons.verified_user_rounded),
            title: 'User',
          ),
          ShapedItemObject(
            icon: const Icon(Icons.logout),
            title: 'Logout',
          ),
        ],
        onItemChanged: (position) {
          setState(() => selectedItem = position);
        },
        shape: ShapeType.circle,
        shapeColor: Colors.pink,
        selectedIconColor: Colors.tealAccent,
      ),
      body: const Center(
        child: Text('Shaped Bottom Bar'),
      ),
    );
  }
}
