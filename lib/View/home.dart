import 'package:flutter/material.dart';
import 'package:ugd1/View/gpsPage.dart';
import 'package:ugd1/View/profil.dart';
import 'package:ugd1/View/UGDView.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/database/sql_helper_objek.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//import 'package:ugd1/View/UGDView.dart';
import 'package:ugd1/View/paymentPage.dart'; // Import PaymentPage
import 'package:shared_preferences/shared_preferences.dart';

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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      if (index == 3) {
        // Jika menu "Pembayaran" (index 3) diklik, arahkan ke PaymentPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentPage()),
        );
      } else {
        _selectedIndex = index;
      }
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

  Widget _buildUGDContent() {
    return UGD();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tripper"),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GpsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.pushNamed(
                context,
                AppRoutes.inputPage,
              ).then((_) => refresh());
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? buildHomeContent()
          : _selectedIndex == 1
              ? Profile()
              : _buildUGDContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black, // Mengatur warna ikon terpilih
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
              color: Colors.black,
            ),
            label: 'UGD',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Mengatur warna ikon terpilih
      ),
    );
  }

  Widget buildHomeContent() {
    return ListView.builder(
      itemCount: objekwisata.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            //untuk simpan id objek wisata ke pref, dipke di insert transaksi booking
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('idObjek', objekwisata[index]['id']);
            await prefs.setString('namaObjek', objekwisata[index]['nama']);

            // Ketika container diklik, arahkan ke halaman booking1, booking2, nanti baru payment
            Navigator.pushNamed(context, AppRoutes.booking1);
          },
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Expanded(
                child: Slidable(
                  actionPane: const SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Objekwisata Name (placed at the top)
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              objekwisata[index]['nama'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),

                          // Image (takes 80% width of the card)
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% of the screen width
                            height: 150, // Set the desired height of the image
                            child: Center(
                              child: Image(
                                image: AssetImage(
                                    setImage(objekwisata[index]['kategori'])),
                                fit: BoxFit
                                    .cover, // Ensure the image covers the entire container
                              ),
                            ),
                          ),

                          // Rest of the data (placed under the image)
                          const Divider(
                            color: Colors.grey,
                            height: 20,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 10,
                                left: 10,
                                right:
                                    10), // Set padding for the start of the card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kategori  : " +
                                      objekwisata[index]['kategori'],
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Harga      : RP " +
                                      objekwisata[index]['harga'].toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Rating      : " +
                                      objekwisata[index]['rating'].toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Deskripsi : " +
                                      objekwisata[index]['deskripsi'],
                                  style: TextStyle(fontSize: 16),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
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
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt(
                            'idUpdate', objekwisata[index]['id']);
                        Navigator.pushNamed(context, AppRoutes.inputPage)
                            .then((_) => refresh());
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
              )),
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
