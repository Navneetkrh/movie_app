import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/favourites.dart';
import 'dart:convert';
import 'functions.dart';
import 'details.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'search.dart';
import 'topRated.dart';
import 'package:hive_flutter/hive_flutter.dart';


Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.blue, // set notification shade color here
  ));
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.initFlutter();
  await Hive.openBox('listedMovies'); // given box name
  runApp(const MyApp());
}

// @override
//   void dispose() {
//     Hive.close();
//     super.dispose();
//   }
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
      home: MyHomePage(),
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
  
  Future<List<dynamic>>? _PopularMovies;
  Future<List<dynamic>>? _trendingMovies;
  Future<List<dynamic>>? _upcomingMovies;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // navigate to splash screen
    _trendingMovies = fetchTrendingMovies();
    _PopularMovies = fetchPopularMovies();
    _upcomingMovies = fetchUpcomingMovies();
     
   
    
  }

  // bool islisted = false;
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
        //navigation bar

        // add a search button with "search movies"
        actions: [
          IconButton(
            onPressed: () {
              // Handle search
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const movieSearcher(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Colors.blueAccent,
              semanticLabel: 'search movies',
            ),
          ),
        ],
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
              future: _trendingMovies,
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
                  color: Colors.orangeAccent,
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
              future: _PopularMovies,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final Popularmovies = snapshot.data!;
                  return LayoutBuilder(builder: (context, Constraints) {
                    return Container(
                      height: 200.0,
                      color: Colors.black,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Popularmovies.length,
                        itemBuilder: (context, index) {
                          // Popularmovies.removeWhere((item) => Popularmovies[index]['poster_path'] == null); // I am not including the movies which don't have a valid poster url
                          final Popularmovie = Popularmovies[index];
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
                  });
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
                  'Upcoming Movies',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            FutureBuilder<List<dynamic>>(
              future: _upcomingMovies,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final Popularmovies = snapshot.data!;
                  return LayoutBuilder(builder: (context, Constraints) {
                    return Container(
                      height: 200.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Popularmovies.length,
                        itemBuilder: (context, index) {
                          // Popularmovies.removeWhere((item) => Popularmovies[index]['poster_path'] == null); // I am not including the movies which don't have a valid poster url
                          final Popularmovie = Popularmovies[index];
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
                  });
                } else if (snapshot.hasError) {
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
      ),
      // body khatam

      //navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Top Rated',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int value) {
    // setState(() {
    //   _selectedIndex = value;
    // });

    if (value == 1) {
      //  Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const movieSearcher(),
      //           ),
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const toprated(),
          ));
    } else if (value == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Favorites(),
          ));
    }
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




