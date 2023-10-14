import 'package:flutter/material.dart';
import 'package:ugd1/View/profile.dart';
import 'package:ugd1/config/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedGridIndex = -1;
  bool _isGridEnlarged = false;

  void _onGridTapped(int index) {
    setState(() {
      if (_selectedGridIndex == index) {
        _isGridEnlarged = !_isGridEnlarged;
      } else {
        _selectedGridIndex = index;
        _isGridEnlarged = true;
      }
    });
  }

  // untuk pilih menu bottom navigation
  int _selectedIndex = 0;

  // fungsi yg akan dijalankan tiap tekan menu di task bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Trip'),
      ),
      body: _selectedIndex == 0
          ? buildHomeContent() // Display Home content if selected index is 0
          : Profile(), // Display ProfileView if selected index is 1
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
    );
  }

  Widget buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Your Home content goes here
          Container(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(8, (index) {
                return GestureDetector(
                  onTap: () {
                    _onGridTapped(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isGridEnlarged && _selectedGridIndex == index
                        ? 400.0
                        : 200.0,
                    height: _isGridEnlarged && _selectedGridIndex == index
                        ? 400.0
                        : 200.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.7 * 8),
                        color: Colors.blue),
                    child: Card(
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Grid Ke ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
