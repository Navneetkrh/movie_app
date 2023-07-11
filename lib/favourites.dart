import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'details.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List favoriteMovies = [];

  @override
  void initState() {
    super.initState();
  }
  Future<dynamic> fetchMovieDetails(int movieID) async {
  final apiKey = '3b8bb1c2e8a9e9a4b0521d7c79db39d4';
  final url = 'https://api.themoviedb.org/3/movie/$movieID?api_key=$apiKey';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch movie details');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.refresh,
              size: 22.0,
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('listedMovies').listenable(),
        builder: (context, box, child) {
          var box = Hive.box('listedMovies');
          favoriteMovies = box.values.toList();
          if (favoriteMovies.isNotEmpty) {
            return GridView.builder(
              itemCount: favoriteMovies.length,
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (120.0 / 185.0),
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // fetch movie details
                    fetchMovieDetails(favoriteMovies[index][0]).then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsPage(
                            movie: value,
                          ),
                        ),
                      );
                    });

                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        image: NetworkImage('https://image.tmdb.org/t/p/w500${favoriteMovies[index][1]}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No favorite movies',
                style: TextStyle(color: CupertinoColors.systemOrange),
              ),
            );
          }
        },
      ),
    );
  }
}