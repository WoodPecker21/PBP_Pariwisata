import 'package:flutter/material.dart';
import 'package:ugd1/View/gpsPage.dart';
import 'package:ugd1/View/profil.dart';
import 'package:ugd1/View/UGDView.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ugd1/View/paymentPage.dart'; // Import PaymentPage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/client/ObjekWisataClient.dart';
import 'package:ugd1/model/objekWisata.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  int _selectedIndex = 0;

  final listProvider = FutureProvider<List<ObjekWisata>>((ref) async {
    try {
      print('retrieve data');
      return await ObjekWisataClient.fetchAll();
    } catch (e) {
      return Future.error(e.toString());
    }
  });

  void onItemTapped(int index, WidgetRef ref, BuildContext context) {
    if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.paymentPage);
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(), // Navigate to the Profile page
        ),
      );
    } else {
      _selectedIndex = index;
    }
  }

  void onDelete(id, context, ref) async {
    try {
      await ObjekWisataClient.destroy(id);
      ref.refresh(listProvider);
      showSnackBar(context, "Delete Success", Colors.green);
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
  }

  void showSnackBar(BuildContext context, String msg, Color bg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        action: SnackBarAction(
          label: 'hide',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  Widget _buildUGDContent() {
    return const UGD();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var listener = ref.watch(listProvider);

    return Scaffold(
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
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.pushNamed(
                context,
                AppRoutes.inputPage,
              ).then((value) => ref.refresh(listProvider));
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? listener.when(
              data: (objekwisatas) => ListView.builder(
                itemCount: objekwisatas.length,
                itemBuilder: (context, index) {
                  return buildKonten(objekwisatas[index], context, ref);
                },
              ),
              error: (err, s) => Center(child: Text(err.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            )
          : _selectedIndex == 1
              ? Profile()
              : _buildUGDContent(),
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
        onTap: (index) => onItemTapped(index, ref, context),
        selectedItemColor: Colors.blue,
      ),
    );
  }

  Widget buildKonten(ObjekWisata o, context, ref) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('idObjek', o.id!);
        await prefs.setString('namaObjek', o.nama!);
        await prefs.setInt('durasiObjek', o.durasi!);

        Navigator.pushNamed(context, AppRoutes.booking1);
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      o.nama!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
                  ),
                ),
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
                        "ID   :   ${o.id}    Kategori  : ${o.kategori}",
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
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Update',
              color: Colors.blue,
              icon: Icons.update,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('idUpdate', o.id!);
                Navigator.pushNamed(
                  context,
                  AppRoutes.inputPage,
                ).then((value) => ref.refresh(listProvider));
              },
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                onDelete(o.id, context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }
}
