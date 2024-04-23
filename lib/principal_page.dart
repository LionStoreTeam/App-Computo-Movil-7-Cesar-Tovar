import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  bool _isLoading = true;
  String? _webUrl;

  @override
  void initState() {
    super.initState();
    _loadUrlFromJson();
  }

  Future<void> _loadUrlFromJson() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/LionStoreTeam/JSON-for-dynamic-URL/main/dynamic_url.json'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final url = jsonData['url']; // Suponiendo que el campo se llame 'url'
      setState(() {
        _webUrl = url;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BIENVENIDO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          _webUrl != null
              ? WebView(
                  initialUrl: _webUrl!,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {},
                  onPageStarted: (String url) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  onPageFinished: (String url) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
