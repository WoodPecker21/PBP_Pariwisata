import 'package:ugd1/model/transaksi.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:ugd1/client/UrlClient.dart';

class TransaksiClient {
  static final String url = UrlClient.baseurl;
  static final String endpoint = UrlClient.endpoint + UrlClient.objekwisata;
  //ambil semua data barang dari api
  static Future<List<Transaksi>> fetchAll() async {
    try {
      var response = await get(
          Uri.http(url, endpoint)); // request ke api dan menyimpan responsenya

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      //ambil data dari response body
      Iterable list = json.decode(response.body)['data'];

      //list map utk membuat list obejk user berdasar tiap elemen dari list
      return list.map((e) => Transaksi.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //ambil data dari API sesuai id
  static Future<Transaksi> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id')); //req ke api

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      //buat objek berdasarkan data dari response body
      return Transaksi.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //membuat data baru
  static Future<Response> create(Transaksi objek) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {'Content-Type': 'application/json'},
          body: objek.toRawJson());
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //mengubaah data sesuai id
  static Future<Response> update(Transaksi objek) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${objek.id}'),
          headers: {'Content-Type': 'application/json'},
          body: objek.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //menghapus data sesuai id
  static Future<Response> destroy(id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}