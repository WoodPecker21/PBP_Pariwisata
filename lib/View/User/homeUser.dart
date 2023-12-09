import 'package:flutter/material.dart';
import 'package:ugd1/View/User/BrowseBy.dart' as brw;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ugd1/View/profil.dart';
import 'package:ugd1/View/ShowBooking.dart';
import 'package:ugd1/client/ObjekWisataClient.dart';
import 'package:ugd1/model/objekWisata.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/client/NewsClient.dart';
import 'package:ugd1/model/news.dart';

class HomePage extends ConsumerWidget {
  final selectedIndexProvider = StateProvider<int>((ref) => 0);
  HomePage({super.key});

  List<String> listPulau = [
    'Jawa',
    'Sumatera',
    'Sulawesi',
    'Kalimantan',
    'Bali',
    'Papua'
  ];

//provider utk ambil list objek wisata dari API
  final listProvider = FutureProvider<List<ObjekWisata>>((ref) async {
    try {
      print('retrieve data');
      return await ObjekWisataClient.fetchAll();
    } catch (e) {
      return Future.error(e.toString());
    }
  });

  final listProviderNews = FutureProvider<List<News>>((ref) async {
    try {
      print('retrieve data');
      return await NewsClient.fetchAll();
    } catch (e) {
      return Future.error(e.toString());
    }
  });
  String inputText = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndexState = ref.watch(selectedIndexProvider.notifier);
    MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: ref.watch(selectedIndexProvider),
        children: [
          homeContent(context, ref),
          BookingView(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
              color: Colors.black,
            ),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex:
            ref.watch(selectedIndexProvider), // Retrieve the state value
        onTap: (index) {
          selectedIndexState.state = index;
        },
        selectedItemColor: ThemeHelper().themeColor().blueA700,
      ),
    );
  }

  Widget kontenAtraksi(ObjekWisata o, context, ref) {
    String kategori = (o.kategori ?? '').toLowerCase();
    String imagePath = 'image/$kategori.jpg';

    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => buildSheet(o, context),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent, // Set the background color to transparent
        padding: EdgeInsets.all(3.2),
        elevation: 0, // Remove the button elevation
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(5),
          width: 125,
          height: 190,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${o.rating} ⭐',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o.nama!,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    o.pulau!,
                    style: TextStyle(
                      fontSize: 8,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeContent(BuildContext context, WidgetRef ref) {
    var listener = ref.watch(listProvider);
    var listenerNews = ref.watch(listProviderNews);

    return Container(
      padding: EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Hi, PBP",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 40,
                        fontFamily: 'Poppins'),
                  ),
                ),
                CircleAvatar(
                  radius: 41.0,
                  backgroundImage: AssetImage('images/kendal.jpeg'),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 1, right: 1),
                child: TextField(
                  scrollPadding: EdgeInsets.all(10),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        // borderSide: BorderSide(width: 0.8),
                      ),
                      hintText: 'Search Places, attractions events',
                      prefixIcon: Icon(Icons.search, size: 30)),
                ),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        "Featured Attractions",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: EdgeInsets.only(top: 15),
                    child: listener.when(
                      loading: () => Center(
                        child:
                            CircularProgressIndicator(), // Circular loading icon
                      ),
                      error: (error, stackTrace) => Center(
                        child: Text(
                            'Error loading data'), // Display an error message
                      ),
                      data: (objekwisatas) {
                        if (objekwisatas.isEmpty) {
                          return Center(
                            child: Text(
                                'No data available'), // Display a message for empty data
                          );
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: objekwisatas.length,
                            itemBuilder: (context, index) {
                              return kontenAtraksi(
                                  objekwisatas[index], context, ref);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        "Browse by Main Islands",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var pulau in listPulau)
                            ElevatedButton(
                              onPressed: () async {
                                //utk menyimpan data pulau yg dipilih
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('pulauSelected', pulau);
                                print('pulau selected $pulau');
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        brw.Browse(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);
                                      return SlideTransition(
                                          position: offsetAnimation,
                                          child: child);
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                  ), // Ganti BrowseDetail() dengan nama kelas untuk halaman detail
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors
                                    .transparent, // Set the background color to transparent
                                padding: EdgeInsets.all(3.2),
                                elevation: 0, // Remove the button elevation
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage('images/papua.jpg'),
                                      fit: BoxFit.cover),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  padding: EdgeInsets.all(5),
                                  width: 125,
                                  height: 133,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pulau,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        "News",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 15),
                    child: listenerNews.when(
                      loading: () => Center(
                        child:
                            CircularProgressIndicator(), // Circular loading icon
                      ),
                      error: (error, stackTrace) => Center(
                        child: Text(
                            'Error loading data'), // Display an error message
                      ),
                      data: (news) {
                        if (news.isEmpty) {
                          return Center(
                            child: Text(
                                'No data available'), // Display a message for empty data
                          );
                        } else {
                          return Container(
                            height: 170,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: news.length,
                              itemBuilder: (context, index) {
                                return kontenNews(news[index], context, ref);
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kontenNews(News n, context, ref) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('idNews', n.id!);
        print('id news ${n.id}');
        Navigator.pushNamed(
          context,
          AppRoutes.newsPage,
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.all(5),
        width: 270,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage('images/lawar.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 150,
                  child: Text(
                    n.judul!,
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          radius: 13.0,
                          backgroundImage: AssetImage('images/kendal.jpeg'),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n.pengarang!,
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget makeDismissable(BuildContext context, {required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: child,
    );
  }

  Widget buildSheet(ObjekWisata o, BuildContext context) => makeDismissable(
        context,
        child: DraggableScrollableSheet(
          minChildSize: 0.5,
          maxChildSize: 1.00,
          initialChildSize: 0.77,
          builder: (BuildContext sheetContext, ScrollController controller) {
            // double screenHeight = MediaQuery.of(sheetContext).size.height;
            // double screenWidth = MediaQuery.of(sheetContext).size.width;
            String kategori = (o.kategori ?? '').toLowerCase();
            String imagePath = 'image/$kategori.jpg';

            return Stack(
              children: [
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    // padding: EdgeInsets.only(bottom: 0),
                  ),
                ),
                Positioned(
                  child: Container(
                    height: 195,
                    // height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imagePath), fit: BoxFit.cover),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 130,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                    // width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25))),
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.nama!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: 19),
                          ),
                          SizedBox(height: 13),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                o.pulau!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    fontFamily: 'Poppins'),
                              ),
                              Text(
                                'RP ${o.harga} /pax',
                                style: TextStyle(
                                    color: Color(0XFF777474),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins'),
                              )
                            ],
                          ),
                          SizedBox(height: 13),
                          Row(
                            children: [
                              Text(
                                '${o.rating} ⭐',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '(2,180 reviews)',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            // height: 155,
                            width: 357,
                            // decoration: BoxDecoration(color: Colors.red),
                            child: Text(
                              o.deskripsi!,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Kategori :',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    // height: 27,
                                    // width: 140,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0XFFD9D9D9)),
                                    child: Text(
                                      '${o.kategori}',
                                      style: TextStyle(
                                          fontSize: 10.5,
                                          fontFamily: 'Poppins'),
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            child: Text(
                              'What is included',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Color(0x33000000), width: 1)),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(7),
                                      child: Icon(
                                        Icons.directions_bus,
                                        size: 27,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(top: 7),
                                          child: Text(
                                            o.transportasi!,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 7),
                                          child: Text(
                                            'Transportation',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 7),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Color(0x33000000), width: 1)),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(7),
                                        child: Icon(
                                          Icons.punch_clock_rounded,
                                          size: 25,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 7, top: 7),
                                            child: Text(
                                              '${o.durasi} days',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(bottom: 3),
                                            child: Text(
                                              'Duration',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 160,
                            padding: EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Color(0x33000000), width: 1)),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(7),
                                  child: Icon(
                                    Icons.villa,
                                    size: 25,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 7, right: 7),
                                      child: Text(
                                        o.akomodasi!,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'Accomodation',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setInt('idObjek', o.id!);
                              await prefs.setString('namaObjek', o.nama!);
                              await prefs.setInt('durasiObjek', o.durasi!);
                              Navigator.pushNamed(context, AppRoutes.booking1);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0044AA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 40),
                            ),
                            child: Text('Book Trip',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}
