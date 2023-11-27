import 'package:ugd1/model/objekWisata.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:ugd1/client/UrlClient.dart';

class ObjekWisataClient {
  //untuk device hp
  static final String url = UrlClient.baseurl;
  static final String endpoint = '/api/objekwisata';
  //ambil semua data barang dari api
  static Future<List<ObjekWisata>> fetchAll() async {
    try {
      var response = await get(
          Uri.http(url, endpoint)); // request ke api dan menyimpan responsenya

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      print('List : ${response.body}');
      //ambil data dari response body
      Iterable list = json.decode(response.body)['data'];
      print('gak sampe sini yaa');
      print('List Data : ${list}');
      print('dahh sampe yaa');
      //list map utk membuat list obejk user berdasar tiap elemen dari list
      final candra = list.map((e) => ObjekWisata.fromJson(e)).toList();
      print('List of ObjekWisata: $candra');
      print('dahh sampe yaa');

      return candra;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //ambil data dari API sesuai id
  static Future<ObjekWisata> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id')); //req ke api

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      //buat objek berdasarkan data dari response body
      return ObjekWisata.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //membuat data baru
  static Future<Response> create(ObjekWisata objek) async {
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
  static Future<Response> update(ObjekWisata objek) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${objek.id}'),
          headers: {'Content-Type': 'application/json'},
          body: objek.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      print('data ${response}');
      print('data updated ${objek}');
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //menghapus data sesuai id
  static Future<Response> destroy(int id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  
}
