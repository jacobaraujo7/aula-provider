import 'dart:convert';

import 'package:dio/dio.dart';

class ClientHttp {
  final dio = Dio();

  Future<Map<String, dynamic>> post(String url, {Map? data}) async {
    final response = await dio.post(url, data: data);
    return jsonDecode(response.data);
  }
}
