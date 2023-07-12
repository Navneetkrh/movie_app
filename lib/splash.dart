import 'package:flutter/material.dart';
import 'main.dart';
import 'functions.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<List<dynamic>>? _PopularMovies;
  Future<List<dynamic>>? _trendingMovies;
  Future<List<dynamic>>? _upcomingMovies;
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds before navigating to the home screen
    _trendingMovies = fetchTrendingMovies();
    _PopularMovies = fetchPopularMovies();
    _upcomingMovies = fetchUpcomingMovies();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/icon.png',
            //   width: 150,
            //   height: 150,
            // ),
            SizedBox(height: 20),
            Text(
              'My App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}