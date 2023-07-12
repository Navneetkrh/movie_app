import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'favourites.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MovieDetailsPage extends StatefulWidget {
  final dynamic movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  dynamic _movieDetails;
  dynamic _movieCredits;
  bool islisted = false;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
    _fetchMovieCredits();
    
  }

  Future<void> _fetchMovieDetails() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movie['id']}?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4&language=en-US'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _movieDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<void> _fetchMovieCredits() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movie['id']}/credits?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4&language=en-US'),
    );
    // final box = await Hive.openBox('listedMovies');
    // islisted = box.containsKey(widget.movie['id']);
    if (response.statusCode == 200) {
      setState(() {
        _movieCredits = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movie credits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie['title']),
      ),
      body:ValueListenableBuilder(
        valueListenable: Hive.box('listedMovies').listenable(),
        builder: (context, box, child) {
          final heart=Hive.box('listedMovies').get(widget.movie['id'])!=null;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.0),
                Hero(
                  tag: widget.movie['id'],
                  
                  child: Container(
                    
                    height: 350.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
                        ),
                        fit: BoxFit.cover,
                        
                      ),
                     
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.movie['title'],
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          // TODO: Implement favorite button functionality

                          final box = await Hive.openBox('listedMovies');
                          final isMovieListed = box.containsKey(widget.movie['id']);
                          islisted = isMovieListed;
                          if (isMovieListed) {
                            await box.delete(widget.movie['id']);
                            final snackBar = SnackBar(
                              content: Text('Removed from lists'),
                              backgroundColor: CupertinoColors.systemOrange,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            await box.put(widget.movie['id'], [
                              widget.movie['id'],
                              widget.movie['poster_path'],
                              widget.movie['release_date'],
                            ]);
                            final snackBar = SnackBar(
                              content: Text('Added to lists'),
                              backgroundColor: CupertinoColors.systemOrange,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        icon: Icon(heart
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16.0,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        '${widget.movie['vote_average']} (${widget.movie['vote_count']} votes)',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        'Release Date: ${widget.movie['release_date']}',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                if (_movieCredits != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Cast:',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      if (_movieCredits['cast'] != null &&
                          _movieCredits['cast'].isNotEmpty)
                        SizedBox(
                          height: 120.0,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _movieCredits['cast'].length,
                            separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(width: 25);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 45.0,
                                    backgroundImage: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${_movieCredits['cast'][index]['profile_path']}',
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    _movieCredits['cast'][index]['name'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      if (_movieCredits['cast'] == null ||
                          _movieCredits['cast'].isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'No cast available.',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                if (_movieCredits == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Loading movie credits...',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Overview:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.movie['overview'] ?? 'No overview available.',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Genres:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                if (widget.movie['genres'] != null &&
                    widget.movie['genres'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(
                        widget.movie['genres'].length,
                        (index) => Chip(
                          label: Text(
                            '${widget.movie['genres'][index]['name']} keyword',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                if (widget.movie['genres'] == null ||
                    widget.movie['genres'].isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'No genres available.',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Full Movie Details:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                if (_movieDetails != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Runtime: ${_movieDetails['runtime']} minutes',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Budget: \$${_movieDetails['budget']}',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Revenue: \$${_movieDetails['revenue']}',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_movieDetails == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Loading full movie details...',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
      ),
    );
  }
}
