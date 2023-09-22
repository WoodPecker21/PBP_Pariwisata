import 'package:flutter/material.dart';

class GridItem {
  final String
      imageAsset; // You can change this to a URL if loading from the internet.
  GridItem(this.imageAsset);
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    // Grid view of images
    GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Adjust this as per your needs
      ),
      itemBuilder: (context, index) {
        return GridItemWidget(
            index); // Create a separate widget for each grid item
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}

class GridItemWidget extends StatelessWidget {
  final int index;

  GridItemWidget(this.index);

  // Define your list of image assets or URLs here
  final List<String> imageList = [
    'image/1.jpg',
    'image/2.jpg',
    'image/3.jpg',
    'image/4.jpg',
    'image/5.jpg',
    'image/6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child:
          Image.asset(imageList[index]), // You can use Image.network() for URLs
      // Add any other styling or functionality you want for each grid item here
    );
  }
}
