import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeView(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Apps'),
      ),
      body: Container(
        color: Colors.blue,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(8, (index) {
            return GestureDetector(
              onTap: () {
                _onGridTapped(index);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
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
                  child: Center(
                    child: Text(
                      'Grid Ke $index',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 185, 44, 44),
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
    );
  }
}

// ----- ini home grid image tapi x enlarged

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeView(),
//     );
//   }
// }

// class HomeView extends StatefulWidget {
//   const HomeView({Key? key}) : super(key: key);

//   @override
//   _HomeViewState createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   int _selectedGridIndex = -1;
//   bool _isGridEnlarged = false;

//   void _onGridTapped(int index) {
//     setState(() {
//       if (_selectedGridIndex == index) {
//         _isGridEnlarged = !_isGridEnlarged;
//       } else {
//         _selectedGridIndex = index;
//         _isGridEnlarged = true;
//       }
//     });
//   }

//   List<String> imagePaths = [
//     'image/1.jpg',
//     'image/2.jpg',
//     'image/3.jpg',
//     'image/4.jpg',
//     'image/5.jpg',
//     // Add more image paths as needed
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Go Trip'),
//       ),
//       body: Container(
//         color: Colors.blue,
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, // 2 columns
//             mainAxisSpacing: 8.0,
//             crossAxisSpacing: 8.0,
//           ),
//           itemCount: imagePaths.length,
//           itemBuilder: (BuildContext context, int index) {
//             return GestureDetector(
//               onTap: () {
//                 _onGridTapped(index);
//               },
//               child: AnimatedContainer(
//                 key: UniqueKey(), // Add this line
//                 duration: Duration(milliseconds: 300),
//                 width: _isGridEnlarged && _selectedGridIndex == index
//                     ? 800.0
//                     : 200.0,
//                 height: _isGridEnlarged && _selectedGridIndex == index
//                     ? 800.0
//                     : 200.0,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(0.7 * 8),
//                   color: Colors.blue,
//                   image: DecorationImage(
//                     image: AssetImage(imagePaths[index]),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
