// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void downloadApk() {
  const apkUrl =
      'https://github.com/xynnpg/ServerAppPontaj/releases/download/v0.0.1-beta.3/app-release.apk';
  html.window.open(apkUrl, '_blank');
}
