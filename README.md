# Movie App

Movie App is a mobile app that allows users to browse and search for movies, view movie details, and save their favorite movies to a watchlist.
I have used flutter to build this app and The movies database api for data.

## Features

- Browse popular movies
- Search for movies by title
- View movie details, including synopsis, cast, and reviews
- Mark movies as favourite


## How to (with screenshots)
![homepage](screenshots/1.jpg)   ![homepage2](screenshots/2.jpg)
home page contains a movie corousal of trending now movies,the horizontally scrollable list of 
popular and upcoming movies.

![toprated](screenshots/3.jpg)
on clicking on top rated on bottom navigation bar ,it will take to this screen of top rated movies,

![search](screenshots/4.jpg)
on clicking the search icon in the appbar of home screen
![search 2](screenshots/5.jpg)
on entering movie name it fetches output.

![details page](screenshots/6.jpg) ![details2](screenshots/Screenshot_1689153363.jpg)
on clicking any movie from any page,will open the details page which contains the details about a movie
and a favourite button to set movie as favourite
 
 on cliking favourite button a notification appears bottom
![favourite](screenshots/7.jpg) ![unfavourite](screenshots/8.jpg)

the favourite movies can be opened from homepage->favourite
![favourite list](screenshots/9.jpg)
a movie can be removed also
![remove](screenshots/10.jpg)
after removing
![less movies](screenshots/11.jpg)


## Download

To get started with Movie App, download the apk
https://drive.google.com/file/d/1EqFX9TG9fKHTfaucEPyoYUvpSEkFlm3e/view?usp=sharing

## Dependencies

Movie App uses the following dependencies:
-uses TMDB api for data
- http
- cached_network_image
- hive database (offline async database to store favourite movies)
-basic cupertino icon for heart



