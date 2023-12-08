import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/client/TransaksiClient.dart';
import 'package:ugd1/model/transaksi.dart';
import 'package:ugd1/client/ObjekWisataClient.dart';
import 'package:ugd1/model/objekWisata.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';

class BookingView extends ConsumerWidget {
  BookingView({super.key});

  //provider utk ambil list transaksi dari API
  final listProvider = FutureProvider<List<Transaksi>>((ref) async {
    try {
      print('retrieve data transaksi');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int idUser = prefs.getInt('id') ?? 0;
      return await TransaksiClient.fetchByUser(idUser);
    } catch (e) {
      return Future.error(e.toString());
    }
  });

  //aksi saat tombol del ditekan
  void onDelete(id, context, ref) async {
    try {
      await TransaksiClient.destroy(id); //hapus barang berdasar id
      ref.refresh(listProvider); //refresh list data barang
      print('delete success');
    } catch (e) {
      print('error delete transaksi: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var listener = ref.watch(listProvider);
    return Scaffold(
      body: listener.when(
        data: (transaksis) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  "My Booking",
                  style: CustomTextStyles.titleForm,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transaksis.length,
                itemBuilder: (context, index) {
                  return buildKonten(transaksis[index], context, ref);
                },
              ),
            ],
          ),
        ),
        error: (err, s) => Center(child: Text(err.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget buildKonten(Transaksi t, context, ref) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 7, 7),

          //ini buat tampilan data dari fk objek wisata
          child: FutureBuilder<ObjekWisata>(
            future: ObjekWisataClient.find(t.idObjek),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final objekWisata = snapshot.data;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgPlaceholder,
                        height: 100,
                        width: 130,
                        radius: BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 190,
                            margin: EdgeInsets.only(right: 7),
                            child: Row(
                              children: [
                                Text(
                                  objekWisata!.nama!,
                                  style: CustomTextStyles.subHeaderBooking,
                                ),
                                Spacer(),
                                Text(
                                  objekWisata.rating!.toString(),
                                  style: CustomTextStyles.subtitleBooking,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'ID Booking: ${t.id}',
                            style: CustomTextStyles.subtitleBooking.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on, // GPS icon
                                size: 15,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  objekWisata.pulau!,
                                  style: CustomTextStyles.subtitleBooking,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Padding(
                            padding: EdgeInsets.only(left: 1),
                            child: Text(
                              'Rp ${t.bayar!.price!}',
                              style: CustomTextStyles.subtitleBooking,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: 185,
                            margin: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: CustomElevatedButton(
                                    text: "Change Date",
                                    buttonTextStyle:
                                        CustomTextStyles.buttonBooking,
                                    height: 35,
                                    buttonStyle: CustomButtonStyles.fillPrimary,
                                    onPressed: () {
                                      final prefs =
                                          SharedPreferences.getInstance();
                                      prefs.then((value) =>
                                          value.setInt('idEditBooking', t.id!));

                                      Navigator.pushNamed(
                                          context,
                                          AppRoutes
                                              .editBooking); //ganti ke halaman edit booking
                                    },
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                    child: CustomElevatedButton(
                                  text: "Cancel Booking",
                                  buttonTextStyle:
                                      CustomTextStyles.buttonBooking,
                                  height: 35,
                                  buttonStyle:
                                      CustomButtonStyles.outlineGrayTL9,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm Delete"),
                                          content: Text(
                                              "Are you sure you want to delete this booking? No refund will be given."),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Delete"),
                                              onPressed: () {
                                                onDelete(t.id, context, ref);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ));
  }
}
