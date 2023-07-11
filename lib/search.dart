import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details.dart';
class movieSearcher extends StatefulWidget {
  const movieSearcher({Key? key}) : super(key: key);

  @override
  State<movieSearcher> createState() => _movieSearcherState();
}

class _movieSearcherState extends State<movieSearcher> {
  late String _searchQuery;
  List<dynamic> _searchResults = [];

  Future<void> _searchMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4&query=$_searchQuery'));
    if (response.statusCode == 200) {
      setState(() {
        _searchResults = jsonDecode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }

  @override
  void initState() {
    super.initState();
    _searchQuery = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            
            hintText: 'Search movies',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          onSubmitted: (value) {
            _searchMovies();
          },
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) =>
                    MovieDetailsPage(movie: _searchResults[index]),
                    ),
                );
              // Navigator.pushNamed(
              //   context,
              //   '/details',
              //   arguments: _searchResults[index],
              // );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${_searchResults[index]['poster_path']}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  _searchResults[index]['title'],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  '(${_searchResults[index]['vote_count']} votes)',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16.0,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      '${_searchResults[index]['vote_average']}',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );//GestureDetector
        },
      ),
    );
  }
}