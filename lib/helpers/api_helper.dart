import 'package:estefania_montoya_6_2021_2_p1/helpers/constans.dart';
import 'package:estefania_montoya_6_2021_2_p1/models/new.dart';
import 'package:estefania_montoya_6_2021_2_p1/models/response.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  static Future<Response> getNews(String category) async {
    var url = Uri.parse('${Constans.apiUrl}${category}');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<New> news = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);
      for (var i = 0; i < jsonData['data'].length; i++) {
        news.add(New.fromJson(jsonData['data'][i]));
      }
    }
    return Response(isSuccess: true, result: news);
  }
}
