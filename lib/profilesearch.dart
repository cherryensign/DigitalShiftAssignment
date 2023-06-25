import 'package:dsassign/key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileSearchPage extends StatefulWidget {
  const ProfileSearchPage({super.key});

  @override
  State<ProfileSearchPage> createState() => _ProfileSearchPageState();
}

class _ProfileSearchPageState extends State<ProfileSearchPage> {
  final String _accessToken = Instatokenkey;
  String _followerCount = '';
  String _followingCount = '';
  String _fullName = '';
  String _profilePicUrl = '';
  String _bio = '';
  String _posts = '';
  bool _searched = false;
  String _errorText = '';
  bool _error = false;

  TextEditingController _profileUrlController = TextEditingController();

  Future<void> _fetchUserData() async {
    final username = _profileUrlController.text;
    final apiUrl =
        'https://www.instagram.com/$username?__a=1&__d=dis&access_token=$_accessToken';
    print(apiUrl);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      var data = jsonDecode(response.body);
      data = data['graphql']['user'];
      var followers = data['edge_followed_by']['count'].toString();
      var following = data['edge_follow']['count'].toString();
      var bio = data['biography'].toString();
      var fullname = data['full_name'].toString();
      var profilepic = data['profile_pic_url_hd'].toString();
      var posts = data['edge_owner_to_timeline_media']['count'].toString();

      setState(() {
        _followerCount = followers;
        _followingCount = following;
        _fullName = fullname;
        _profilePicUrl = profilepic;
        _bio = bio;
        _posts = posts;
        _searched = true;
        _error = false;
      });
    } catch (e) {
      setState(() {
        _errorText = 'Something went wrong. Try again later.';
        _error = true;
      });
    }
  }

  @override
  void dispose() {
    _profileUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _profileUrlController,
              decoration: const InputDecoration(
                hintText: 'Enter Instagram profile username',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: _fetchUserData,
              child: const Text('Fetch User Data'),
            ),
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
                        children: <Widget>[
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(_profilePicUrl),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '$_fullName',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Bio: $_bio',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Posts: $_posts',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Follower Count: $_followerCount',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Following Count: $_followingCount',
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
