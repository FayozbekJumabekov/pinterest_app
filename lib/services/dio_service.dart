// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:pinterest_app/models/pinterest_model.dart';
// import '../models/collections_model.dart';
// import 'log_service.dart';
//
// class DioService {
//   /// Set isTester ///
//   static bool isTester = true;
//
//   /// Servers Types ///
//   static String SERVER_DEVELOPMENT = "https://api.unsplash.com";
//   static String SERVER_PRODUCTION = "https://api.unsplash.com";
//
//   /// * Http Apis *///
//   static String API_LIST = "/photos";
//   static String API_SEARCH_PHOTOS = '/search/photos';
//   static String API_COLLECTIONS = "/collections";
//
//
//   /// Getting Header ///
//   static Map<String, String> getHeaders() {
//     Map<String, String> header = {
//       "Accept-Version": "v1",
//       "Authorization": "Client-ID MTgfbWGliunTpETughwj_azSDlGAUS9yTy4NBGogi0c"
//     };
//     return header;
//   }
//
//   /// Selecting Test Server or Production Server  ///
//
//   static String getServer() {
//     if (isTester) return SERVER_DEVELOPMENT;
//     return SERVER_PRODUCTION;
//   }
//
//   ///* Http Requests *///
//
//   /// GET method///
//   static Future<dynamic> GET(String api, Map<String, String> params) async {
//     var options = BaseOptions(
//       baseUrl: getServer(),
//       headers: getHeaders(),
//       connectTimeout: 10000,
//       receiveTimeout: 3000,
//     );
//     var dio = Dio(options);
//     Response response = await dio.get(api,queryParameters: params);
//     Log.i(jsonEncode(response.data));
//     if (response.statusCode == 200) return response.data;
//     return null;
//   }
//
//   /// * Http Params * ///
//
//   /// EMPTY PARAM
//   static Map<String, String> paramsEmpty() {
//     Map<String, String> params = {};
//     return params;
//   }
//
//   /// SEARCH PARAM
//   static Map<String, String> paramsSearch(int page, String category) {
//     Map<String, String> params = {'page': '$page', 'query': category};
//     return params;
//   }
//
//   /// PARSING ///
//
//   static List<Pinterest> parseUnSplashList(String response) {
//     //var json = jsonDecode(response);
//     var data = unSplashFromJson(response);
//     return data;
//   }
//
//   static List<Pinterest> parseUnSplashSearchList(String response) {
//
//     var json = jsonDecode(response);
//     var data = unSplashFromJson(jsonEncode(json['results']));
//     return data;
//   }
//
//   static List<Collections> parseCollectionResponse(String response) {
//     List json = jsonDecode(response);
//     List<Collections> collections = List<Collections>.from(json.map((x) => Collections.fromJson(x)));
//     return collections;
//   }
//
// }
