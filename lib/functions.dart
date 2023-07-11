import 'package:http/http.dart' as http;
import 'dart:convert';
Future<List<dynamic>> fetchTrendingMovies() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/trending/movie/day?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['results'];
  } else {
    throw Exception('Failed to load trending movies');
  }
}
Future<List<dynamic>> fetchLatestMovies() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/latest?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4'));
  if (response.statusCode == 200) {
    return [jsonDecode(response.body)];
  } else {
    throw Exception('Failed to load latest movies');
  }
}
Future<List<dynamic>> fetchUpcomingMovies() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/upcoming?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['results'];
  } else {
    throw Exception('Failed to load upcoming movies');
  }
}
Future<List<dynamic>> fetchPopularMovies() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['results'];
  } else {
    throw Exception('Failed to load popular movies');
  }
}
Future<List<dynamic>> searchMovies(String query) async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4&query=$query'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['results'];
  } else {
    throw Exception('Failed to search movies');
  }
}
Future<List<dynamic>> fetchTopRatedMovies() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/top_rated?api_key=3b8bb1c2e8a9e9a4b0521d7c79db39d4'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['results'];
  } else {
    throw Exception('Failed to load top rated movies');
  }
}
