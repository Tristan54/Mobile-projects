import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Custom Implementation of CacheManager
// by extending the BaseCacheManager abstract class
class MyCacheManagerGet extends BaseCacheManager {
  static const key = "customCache";

  static MyCacheManagerGet _instance;

  // singleton implementation
  // for the custom cache manager
  factory MyCacheManagerGet() {
    if (_instance == null) {
      _instance = new MyCacheManagerGet._();
    }
    return _instance;
  }

  // pass the default setting values to the base class
  // link the custom handler to handle HTTP calls
  // via the custom cache manager
  MyCacheManagerGet._()
      : super(key,
            maxAgeCacheObject: Duration(hours: 12),
            maxNrOfCacheObjects: 200,
            fileFetcher: _myHttpGetter);

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _myHttpGetter(String url,
      {Map<String, String> headers}) async {
    HttpFileFetcherResponse response;
    // Do things with headers, the url or whatever.
    try {
      var res = await http.get(url, headers: headers);

      response = HttpFileFetcherResponse(res);
    } on SocketException {
      print('No internet connection');
    }
    return response;
  }
}
