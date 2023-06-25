import 'package:dsassign/key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostSearchPage extends StatefulWidget {
  const PostSearchPage({super.key});

  @override
  State<PostSearchPage> createState() => _PostSearchPageState();
}

class _PostSearchPageState extends State<PostSearchPage> {
  final String _accessToken = Instatokenkey;
  String _postUrl = '';
  String _imageUrl = '';
  String _likesCount = '';
  String _commentsCount = '';
  String _caption = '';
  bool _searched = false;
  TextEditingController _postUrlController = TextEditingController();
  String _errorText = '';
  bool _error = false;

  String extractPostID(String url) {
    RegExp regExp = RegExp(r'\/p\/(\w+)\/');
    Match? match = regExp.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? '';
    }
    return '';
  }

  Future<void> _fetchPostData() async {
    _postUrl = _postUrlController.text;
    _postUrl = extractPostID(_postUrl);
    //_postUrl = _postUrl.substring(0, _postUrl.indexOf('?')) +
    //    '?__a=1&__d=dis&access_token=$_accessToken';
    print(_postUrl);
    final apiUrl =
        'https://graph.instagram.com/$_postUrl?fields=permalink&access_token=$_accessToken';
    print(apiUrl);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      var data = jsonDecode(response.body);
      print(data);
      data = data['graphql']['shortcode_media'];
      var picUrl = data['display_url'].toString();
      var caption = data['edge_media_to_cation']['edges'][0]['node']['text'];

      setState(() {
        _imageUrl = picUrl;
        _caption = caption;
        _error = false;
        _searched = true;
      });
    } catch (e) {
      setState(() {
        _errorText = 'Something went wrong. Try again later.';
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _postUrlController,
              decoration: const InputDecoration(
                hintText: 'Enter Instagram Post Url ',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: _fetchPostData,
              child: const Text('Fetch Post Data'),
            ),
            const SizedBox(height: 20),
            _error
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        '$_errorText',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                : _searched
                    ? Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Image.network(_imageUrl),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Caption: $_caption',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
