import 'package:flutter/material.dart';
import 'package:ugd1/config/theme.dart';

void main() => runApp(const TabBarApp());

class TabBarApp extends StatelessWidget {
  const TabBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: TabContentView(),
    );
  }
}

class TabContentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          //title: Text('Go Trip'),
          // backgroundColor: Colors.blue,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person),
                text: 'Menxx',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Candra',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Idel',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Jojo',
              ),
            ],
          ),
          toolbarHeight: 1.0,
        ),
        body: TabBarView(
          children: <Widget>[
            TabContentViewItem(
              imageAsset: 'image/Agustinus.jpeg',
              text: 'Agustinus Evanre',
            ),
            TabContentViewItem(
              imageAsset: 'image/Candra.jpeg',
              text: 'Candra Dionisius Sihotang',
            ),
            TabContentViewItem(
              imageAsset: 'image/Idelia.jpeg',
              text: 'Idelia Jonathan',
            ),
            TabContentViewItem(
              imageAsset: 'image/Joanna.jpeg',
              text: 'Joanna',
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class TabContentViewItem extends StatelessWidget {
  final String imageAsset;
  final String text;

  TabContentViewItem({
    required this.imageAsset,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imageAsset,
          width: 300,
          height: 300,
        ),
        SizedBox(height: 16),
        Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
