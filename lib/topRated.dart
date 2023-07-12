import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'functions.dart';
import 'details.dart';
import 'main.dart';

class toprated extends StatefulWidget {
  const toprated({super.key});

  @override
  State<toprated> createState() => _topratedState();
}

class _topratedState extends State<toprated> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
    
    title: Text('Top Rated'),
    // automaticallyImplyLeading: false,
  ),
      // appBar: AppBar(
      //   title: Text('toprated'),
      // ),
      
      body: FutureBuilder(
          future: fetchTopRatedMovies(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movies = snapshot.data;
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: movies!.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailsPage(movie: movies[index]),
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
                                  'https://image.tmdb.org/t/p/w500${movies[index]['poster_path']}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          movies[index]['title'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '(${movies[index]['vote_count']} votes)',
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
                              '${movies[index]['vote_average']}',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ); //GestureDetector
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          }),

      //     bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   selectedItemColor: Colors.blue,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.star),
      //       label: 'Top Rated',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite),
      //       label: 'Favorites',
      //     ),
      //   ],
      // ),
    );
  }
  // void _onItemTapped(int value) {
  //   setState(() {
  //     _selectedIndex = value;
  //   });
    
  //   // if (value == 1) {
  //   //   //  Navigator.push(
  //   //   //           context,
  //   //   //           MaterialPageRoute(
  //   //   //             builder: (context) => const movieSearcher(),
  //   //   //           ),
  //   //   Navigator.push(
  //   //       context,
  //   //       MaterialPageRoute(
  //   //         builder: (context) => const toprated(),
  //   //       ));
  //   // }
  //    if(value == 0){
  //           Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const MyHomePage(),
  //         ));
  //   }
  // }

}


