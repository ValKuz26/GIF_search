import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gif_search_app/secondpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIF Search',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: GiphySearchPage(),
    );
  }
}

class GiphySearchPage extends StatefulWidget {
  @override
  _GiphySearchPageState createState() => _GiphySearchPageState();
}

class _GiphySearchPageState extends State<GiphySearchPage> {
  String API_KEY = 'x4Eh5lV7SIg3CTIM3s5iA4siG40HiN4d';
  List<dynamic> _gifs = [];
  TextEditingController _searchController = TextEditingController();

  Container _buildGifLayout(imageUrl){

    void onLikePress(){

    }

    onSharePress(String gifUrl) async {
      await Share.shareWithResult(gifUrl);
    }

    void _openFullScreen(String gifUrl) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FullScreenGifPage(gifUrl: gifUrl)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap:() {
      _openFullScreen(imageUrl);
        },
       child: Column(
          children:[
            Image.network(imageUrl, fit: BoxFit.cover),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: onLikePress,
                      icon: const Icon(Icons.favorite_border, color: Colors.pink)
                  ),
                  IconButton(
                      onPressed: () => onSharePress(imageUrl),
                      icon: const Icon(Icons.share, color: Colors.blue)
                  ),
                ]
            ),
          ]
       ),
      ),
    );
  }

  void _searchGifs(String query) async {
    String url = 'https://api.giphy.com/v1/gifs/search?api_key=$API_KEY&q=$query&limit=26&offset=0&rating=g&lang=en';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _gifs = jsonDecode(response.body)['data'];
      });
    } else {
      print('Request failed with status:${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GIF Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Gifs',
              ),
              onSubmitted: (value) {
                _searchGifs(value);
              },
            ),
          ),
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: _gifs.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildGifLayout(_gifs[index]['images']['fixed_height']['url']);
              },
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
            ),
          ),
        ],
      ),
    );
  }
}

