import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/custom_app_bar.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  final String title;
  final String? successUrl;
  final String? cancelUrl;
  const WebviewPage._({
    required this.url,
    required this.title,
    this.successUrl,
    this.cancelUrl,
  });

  static Future<Map<String, dynamic>?> open({
    required BuildContext context,
    required String url,
    required String title,
    String? successUrl,
    String? cancelUrl,
  }) async {
    return await Navigator.push<Map<String, dynamic>>(
      context,
      CupertinoPageRoute(
        builder: (_) => WebviewPage._(
          url: url,
          title: title,
          successUrl: successUrl,
          cancelUrl: cancelUrl,
        ),
      ),
    );
  }

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late final WebViewController _controller;

  bool matchesUrl(NavigationRequest request, String? url) {
    if (url == null) {
      return false;
    }
    if (request.url.startsWith(url)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (matchesUrl(request, widget.successUrl)) {
              Navigator.pop(context, Uri.parse(request.url).queryParameters);
              return .prevent;
            } else if (matchesUrl(request, widget.cancelUrl)) {
              Navigator.pop(context, Uri.parse(request.url).queryParameters);
              return .prevent;
            }
            return .navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: widget.title),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
