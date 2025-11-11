import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Add url_launcher

class MyWebView extends StatefulWidget {
  final String initialUrl;

  const MyWebView({super.key, required this.initialUrl});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.example.com')) {
              return NavigationDecision.navigate; // Allow navigation within example.com
            } else {
              _launchURL(request.url); // Use url_launcher for external URLs
              return NavigationDecision.prevent; // Prevent navigation in the webview
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.initialUrl),
      );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}