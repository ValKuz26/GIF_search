import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_plus/share_plus.dart';


class FullScreenGifPage extends StatelessWidget {
  final String gifUrl;

  const FullScreenGifPage({required this.gifUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen Gif'),
      ),
      body: Center(
        child: Image.network(
          gifUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}