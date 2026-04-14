/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  final String title;
  const WebviewPage._({required this.url, required this.title});

  static Future<void> open({
    required BuildContext context,
    required String url,
    required String title,
  }) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => WebviewPage._(url: url, title: title),
      ),
    );
  }

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final _controller = WebViewController();

  @override
  void initState() {
    super.initState();
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
*/
