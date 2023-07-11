import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'functions.dart';
import 'details.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

// stateful MyHomePage widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<dynamic>>? _popularMovies;
  Future<List<dynamic>>? _PopularMovies;
  Future<List<dynamic>>? _trendingMovies;

  @override
  void initState() {
    super.initState();
    _trendingMovies = fetchTrendingMovies();
    _PopularMovies = fetchPopularMovies();
    _popularMovies = fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Movie App',
            style: TextStyle(color: Colors.blueAccent),
            textScaleFactor: 1.5,
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
    
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.trending_up,
                    size: 30.0,
                    color: Colors.redAccent,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Trending Now',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              FutureBuilder<List<dynamic>>(
                future: fetchTrendingMovies(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final movies = snapshot.data!;
                    return CarouselSlider.builder(
                      itemCount: movies.length,
                      options: CarouselOptions(
                        height: 400,
                        viewportFraction: .8,
                        autoPlay: true,
                      ),
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        final movie = movies[index];
                        final rating =
                            double.parse(movie['vote_average'].toString())
                                .toStringAsFixed(1);
                        final title = movie['title'];
                        final description = movie['overview'].length > 100
                            ? '${movie['overview'].substring(0, 100)}...'
                            : movie['overview'];
                        return GestureDetector(
                          onTap: () {
                            // Handle movie tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailsPage(movie: movie),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                ),
                                fit: BoxFit.cover,
                                colorFilter: const ColorFilter.mode(
                                  Colors.black26,
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Colors.black54,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              rating,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          description,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const Center(
                      heightFactor: 11,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Row(
                children: const [
                  Icon(
                    CupertinoIcons.play_circle,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Popular Movies',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              FutureBuilder<List<dynamic>>(
                future: fetchPopularMovies(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final Popularmovies = snapshot.data!;
                    return LayoutBuilder(
                      builder: (context,Constraints) {
                        return Container(
                          height: 200.0,
                          color:Colors.black38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: Popularmovies.length,
                            itemBuilder:(context, index) {
                              
                              // Popularmovies.removeWhere((item) => Popularmovies[index]['poster_path'] == null); // I am not including the movies which don't have a valid poster url
                              final Popularmovie=Popularmovies[index];
                              return GestureDetector(
                                onTap: () {
                                  // Handle movie tap
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetailsPage(movie: Popularmovie),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${Popularmovie['poster_path']}',
                                      fit: BoxFit.cover,
                                      width: 120.0,
                                      height: 180.0,
                                    ),
                                  ),
                                ),
                              );
                              
                            },
                                
                          
                          ),
                        );
                      }
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const Center(
                      heightFactor: 11,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
              ,
              Row(
                children: const [
                  Icon(
                    CupertinoIcons.play_circle,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Upcoming Movies',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              FutureBuilder<List<dynamic>>(
                future: fetchUpcomingMovies(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final Popularmovies = snapshot.data!;
                    return LayoutBuilder(
                      builder: (context,Constraints) {
                        return Container(
                          
                          height: 200.0,
                          
                          child: ListView.builder(
                            
                            scrollDirection: Axis.horizontal,
                            itemCount: Popularmovies.length,
                            itemBuilder:(context, index) {
                              
                              // Popularmovies.removeWhere((item) => Popularmovies[index]['poster_path'] == null); // I am not including the movies which don't have a valid poster url
                              final Popularmovie=Popularmovies[index];
                              return GestureDetector(
                                onTap: () {
                                  // Handle movie tap
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetailsPage(movie: Popularmovie),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${Popularmovie['poster_path']}',
                                      fit: BoxFit.cover,
                                      width: 120.0,
                                      height: 180.0,
                                    ),
                                  ),
                                ),
                              );
                              
                            },
                                
                          
                          ),
                        );
                      }
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const Center(
                      heightFactor: 11,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ));
        
  }
  
}

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Movie App'),
//         backgroundColor: Colors.blueGrey[900],
//       ),
//       body: ,
//     );
//   }
// }


