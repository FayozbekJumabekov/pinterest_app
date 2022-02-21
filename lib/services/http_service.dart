import 'dart:convert';
import 'package:http/http.dart';
import 'package:pinterest_app/models/pinterest_model.dart';

import 'log_service.dart';

class Network {
  /// Set isTester ///
  static bool isTester = true;

  /// Servers Types ///
  static String SERVER_DEVELOPMENT = "api.unsplash.com";
  static String SERVER_PRODUCTION = "api.unsplash.com";

  /// * Http Apis *///
  static String API_LIST = "/photos";
  static String API_SEARCH_PHOTOS = '/search/photos';

  // static String API_SINGLE_LIST = "/users/"; //{id}
  // static String API_CREATE = "/users";
  // static String API_UPDATE = "/users/"; //{id}
  // static String API_EDIT = "/users/"; //{id}
  // static String API_DELETE = "/users/"; //{id}

  /// Getting Header ///
  static Map<String, String> getHeaders() {
    Map<String, String> header = {
      "Accept-Version": "v1",
      "Authorization": "Client-ID MTgfbWGliunTpETughwj_azSDlGAUS9yTy4NBGogi0c"
    };
    return header;
  }

  /// Selecting Test Server or Production Server  ///

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  ///* Http Requests *///

  /// GET method///
  static Future<String?> GET(String api, Map<String, String> params) async {
    Uri uri = Uri.https(getServer(), api, params);
    Response response = await get(uri, headers: getHeaders());
    Log.i(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /// * Http Params * ///

  /// EMPTY PARAM
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  /// SEARCH PARAM
  static Map<String, String> paramsSearch(int page, String category) {
    Map<String, String> params = {'page': '$page', 'query': category};
    return params;
  }

  /// PARSING ///

  static List<Pinterest> parseUnSplashList(String response) {
    //var json = jsonDecode(response);
    var data = unSplashFromJson(response);
    return data;
  }

  static List<Pinterest> parseUnSplashSearchList(String response) {

    var json = jsonDecode(response);
    var data = unSplashFromJson(jsonEncode(json['results']));
    return data;
  }

}
