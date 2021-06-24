import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyWebView extends StatefulWidget {
  @override
  _PrivacyWebViewState createState() => _PrivacyWebViewState();
}

class _PrivacyWebViewState extends State<PrivacyWebView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
    );
  }
}