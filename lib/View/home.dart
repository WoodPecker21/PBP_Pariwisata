import 'package:flutter/material.dart';
import 'package:ugd1/View/gpsPage.dart';
import 'package:ugd1/View/profil.dart';
import 'package:ugd1/View/UGDView.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/client/ObjekWisataClient.dart';
import 'package:ugd1/model/objekWisata.dart';
import 'package:ugd1/View/news.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  final selectedIndexProvider = StateProvider<int>((ref) => 0);
  int _selectedIndexState = 0;
  HomeView({super.key});

  //provider utk ambil list objek wisata dari API
  final listProvider = FutureProvider<List<ObjekWisata>>((ref) async {
    try {
      print('retrieve data');
      return await ObjekWisataClient.fetchAll();
    } catch (e) {
      return Future.error(e.toString());
    }
  });

  //aksi saat tombol del ditekan
  void onDelete(id, context, ref) async {
    try {
      await ObjekWisataClient.destroy(id); //hapus barang berdasar id
      ref.refresh(listProvider); //refresh list data barang
      showSnackBar(
          context, "Delete Success", Colors.green); //tampilkan snackbar
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red); //tampilkan snackbar
    }
  }

  //menampilkan snackbar
  void showSnackBar(BuildContext context, String msg, Color bg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: bg,
          action: SnackBarAction(
            label: 'hide',
            onPressed: scaffold.hideCurrentSnackBar,
          )),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndexState = ref.watch(selectedIndexProvider.notifier);
    var listener = ref.watch(listProvider);

    return Scaffold(
      key: Key('home'),
      appBar: AppBar(
        title: const Text("Tripper"),
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
            key: Key('inputobjek'),
            icon: Icon(Icons.add),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              if (prefs.containsKey('idUpdate')) {
                prefs.remove('idUpdate');
              }

              Navigator.pushNamed(
                context,
                AppRoutes.inputPage,
              ).then((value) => ref.refresh(listProvider));
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: ref.watch(selectedIndexProvider),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                child: Text(
                  "Hi, Admin",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 35,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: listener.when(
                  data: (objekwisatas) => ListView.builder(
                    itemCount: objekwisatas.length,
                    itemBuilder: (context, index) {
                      return buildKonten(objekwisatas[index], context, ref);
                    },
                  ),
                  error: (err, s) => Center(child: Text(err.toString())),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
          NewsPageInput(),
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
            label: 'News',
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

  Widget buildKonten(ObjekWisata o, context, ref) {
    String kategori = (o.kategori ?? '').toLowerCase();
    String imagePath = 'image/$kategori.jpg';

    return GestureDetector(
      onTap: () async {
        //MAKA UPDATE
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('idUpdate', o.id!);
        Navigator.pushNamed(
          context,
          AppRoutes.inputPage,
        ).then((value) => ref.refresh(listProvider));
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              o.nama!, //nama objek wisata
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Delete"),
                                    content: Text(
                                        "Are you sure you want to delete this attraction?"),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () async {
                                          onDelete(o.id, context, ref);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 150,
                          child: Center(
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const Center(
                          child: Divider(
                        color: Colors.grey,
                        height: 20,
                        indent: 10,
                        endIndent: 10,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: 12,
                          right: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID   :   ${o.id}      Kategori  : ${o.kategori}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Harga      : RP ${o.harga}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Rating      : ${o.rating}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Deskripsi : ${o.deskripsi}",
                              style: TextStyle(fontSize: 16),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
