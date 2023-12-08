import 'package:ugd1/model/news.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:ugd1/client/UrlClient.dart';

class NewsClient {
  static final String url = UrlClient.baseurl;
  static final String endpoint = UrlClient.endpoint + UrlClient.news;

  static Future<List<News>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body)['data'];
        return list.map((e) => News.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to fetch news. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  static Future<News> find(id) async {
    try {
      var response = await get(
        Uri.http(url, '$endpoint/$id'),
      );

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return News.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      throw Exception('Error finding news: $e');
    }
  }

  static Future<void> create(News objek) async {
    try {
      var response = await post(
        Uri.http(url, endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(objek.toJson()),
      );
      print('Response Body: ${response.body}');
      if (response.statusCode == 201) {
        print('Data berhasil disimpan');
      } else {
        print('Failed to save data. Please try again.');
      }
    } catch (e) {
      print('Error: $e');
      print('Failed to connect to the server.');
    }
  }

  static Future<Response> update(News objek) async {
    try {
      var response = await put(
        Uri.http(url, '$endpoint/${objek.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(objek.toJson()),
      );

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      throw Exception('Error updating news: $e');
    }
  }

  static Future<Response> destroy(id) async {
    try {
      var response = await delete(
        Uri.http(url, '$endpoint/$id'),
      );

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      throw Exception('Error deleting news: $e');
    }
  }
}
