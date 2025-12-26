import 'package:flutter/widgets.dart';

class AssetCache {
  static final Set<String> _cachedAssets = {};

  static Future<void> preloadAsset(
    BuildContext context,
    List<String> assetPath,
  ) async {
    for (final path in assetPath) {
      if (!_cachedAssets.contains(path)) {
        await precacheImage(AssetImage(path), context);
        _cachedAssets.add(path);
      }
    }
  }
}
