import 'package:flutter/material.dart';
import 'package:ugd1/View/profile.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/View/inputPage.dart';
import 'package:ugd1/database/sql_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Map<String, dynamic>> objekwisata = [];

  void refresh() async {
    final data = await SQLHelper.getObjekWisata();
    setState(() {
      objekwisata = data;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Go Trip"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InputPage(
                    title: 'INPUT OBJEK WISATA',
                    id: null,
                    nama: null,
                    deskripsi: null,
                    kategori: null,
                    gambar: null,
                    rating: null,
                    harga: null,
                  ),
                ),
              ).then((_) => refresh());
            },
          ),
          IconButton(onPressed: () async {}, icon: Icon(Icons.clear))
        ],
      ),
      body: _selectedIndex == 0 ? buildHomeContent() : Profile(),
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
    return ListView.builder(
      itemCount: objekwisata.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Slidable(
            actionPane: const SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              height: 250,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 200,
                      child: Center(
                        child: Image(
                          image: AssetImage(
                              setImage(objekwisata[index]['kategori'])),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 20,
                          child: Text(
                            "Nama wisata: " + objekwisata[index]['nama'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 20,
                        ),
                        Container(
                          child: Text(
                            "Kategori: " + objekwisata[index]['kategori'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Harga: RP " +
                                objekwisata[index]['harga'].toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Rating: " +
                                objekwisata[index]['rating'].toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Deskripsi: " + objekwisata[index]['deskripsi'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Update',
                color: Colors.blue,
                icon: Icons.update,
                onTap: () async {
                  final updatedData = objekwisata[index];
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InputPage(
                          title: 'Update Objek Wisata',
                          id: updatedData['id'],
                          nama: updatedData['nama'],
                          deskripsi: updatedData['deskripsi'],
                          kategori: updatedData['kategori'],
                          gambar: updatedData['gambar'],
                          rating: updatedData['rating'],
                          harga: updatedData['harga'],
                        ),
                      ));
                  refresh();
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  await deleteObjekWisata(objekwisata[index]['id']);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteObjekWisata(int id) async {
    await SQLHelper.deleteObjekWisata(id);
    refresh();
  }

  String setImage(String kategori) {
    if (kategori == 'Alam') {
      return ('image/alam.jpg');
    } else if (kategori == 'Budaya') {
      return ('image/budaya.jpeg');
    } else if (kategori == 'Komersial') {
      return ('image/komersial.jpg');
    } else if (kategori == 'Kuliner') {
      return ('image/kuliner.jpg');
    } else if (kategori == 'Maritim') {
      return ('image/maritim.jpg');
    } else if (kategori == 'Religius') {
      return ('image/religius.jpg');
    }
    return '';
  }
}
