// ignore_for_file: unused_element

import 'package:dio/dio.dart';

Map<String, String> _headers = <String, String>{
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.x-eats.com/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getdata({
    required url,
    required Map<String, dynamic> query,
  }) async {
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> PostData({
    required url,
    String lang = 'en',
    String? token,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'token': token,
      'Content-Type': 'application/json',
    };
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
