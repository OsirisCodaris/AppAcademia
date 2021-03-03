import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CustomCacheManager extends BaseCacheManager {
  static const key = "pdfCacheacademia";
  static const int maxNumberOfFiles = 9;
  static const Duration cacheTimeout =
      Duration(seconds: 3600 * 3 * 6); // 18 heures :)
// pass values into super
  CustomCacheManager()
      : super(key,
            maxNrOfCacheObjects: maxNumberOfFiles,
            maxAgeCacheObject: cacheTimeout);
  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }
}
