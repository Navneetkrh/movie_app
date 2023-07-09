import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _popularMovies = fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _popularMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return ListTile(
                  title: Text(movie['title']),
                  subtitle: Text(movie['overview']),
                  leading: Image.network(
                      'https://image.tmdb.org/t/p/w92${movie['poster_path']}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
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
Future<List<dynamic>> fetchPopularMovies() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['results'];
  } else {
    throw Exception('Failed to load popular movies');
  }
}
