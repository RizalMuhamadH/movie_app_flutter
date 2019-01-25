import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/movieModel.dart';
import './models/data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'movieDetails.dart';

//const baseUrl = "https://api.themoviedb.org/3/movie/";
//const baseImageUrl = "http://image.tmdb.org/t/p/";
//
//const apiKey = "d6fe722d2914c4db8dec242382941dd1";

const nowPlaying =
    "${Data.baseUrl}now_playing?api_key=${Data.apiKey}&language=en-US";
const upcoming =
    "${Data.baseUrl}upcoming?api_key=${Data.apiKey}&language=en-US";
const popular = "${Data.baseUrl}popular?api_key=${Data.apiKey}&language=en-US";
const topRate =
    "${Data.baseUrl}top_rated?api_key=${Data.apiKey}&language=en-US";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyMovieApp(title: 'Movie App'),
    );
  }
}

class MyMovieApp extends StatefulWidget {
  MyMovieApp({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyMoviePageState createState() => _MyMoviePageState();
}

class _MyMoviePageState extends State<MyMovieApp> {
  Movie nowPlayingMovies;
  Movie upcomingMovie;
  Movie pupolarMovie;
  Movie topRatedMovie;
  int heroTag = 0;
  int _currentIndex = 0;

  //paging
  int _pageNumberUpcoming = 1;
  int _totalItemsUpcoming = 0;
  int _pageNumberPopular = 1;
  int _totalItemsPopular = 0;
  int _pageNumberTopRated = 1;
  int _totalItemsTopRated = 0;

//  String nowPlaying = "${Data.baseUrl}now_playing?api_key=${Data.apiKey}&language=en-US";
//  String upcoming = "${Data.baseUrl}upcoming?api_key=${Data.apiKey}&language=en-US";
//  String popular = "${Data.baseUrl}popular?api_key=${Data.apiKey}&language=en-US";
//  String topRate = "${Data.baseUrl}top_rated?api_key=${Data.apiKey}&language=en-US";

  @override
  void initState() {
    super.initState();
    _fetchNowPlayingMovie();
    _fetchUpcomingMovies();
    _fetchPopularMovies();
    _fetchTopRatedMoviews();
  }

  void _fetchNowPlayingMovie() async {
    var response = await http.get(nowPlaying);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      nowPlayingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchUpcomingMovies() async {
    var response = await http.get(
        "${Data.baseUrl}upcoming?api_key=${Data.apiKey}&language=en-US&page=$_pageNumberUpcoming");
    var decodeJson = jsonDecode(response.body);
    upcomingMovie == null
        ? upcomingMovie = Movie.fromJson(decodeJson)
        : upcomingMovie.results.addAll(Movie.fromJson(decodeJson).results);
    setState(() {
      _totalItemsUpcoming = upcomingMovie.results.length;
    });
  }

  void _fetchPopularMovies() async {
    var response = await http.get(popular);
    var decodeJson = jsonDecode(response.body);
    pupolarMovie == null
        ? pupolarMovie = Movie.fromJson(decodeJson)
        : pupolarMovie.results.addAll(Movie.fromJson(decodeJson).results);
    setState(() {
      _totalItemsPopular = pupolarMovie.results.length;
    });
  }

  void _fetchTopRatedMoviews() async {
    var response = await http.get(topRate);
    var decodeJson = jsonDecode(response.body);
    topRatedMovie == null
        ? topRatedMovie = Movie.fromJson(decodeJson)
        : topRatedMovie.results.addAll(Movie.fromJson(decodeJson).results);
    setState(() {
      _totalItemsTopRated = topRatedMovie.results.length;
    });
  }

  Widget _buildCarouselSlider() => CarouselSlider(
        items: nowPlayingMovies == null
            ? <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                ),
              ]
            : nowPlayingMovies.results
                .map(
                  (item) => _buildMovieItem(item),
                )
                .toList(),
        autoPlay: false,
        height: 240.0,
        viewportFraction: 0.5,
      );

  Widget _buildMovieItem(Results movieItem) {
    heroTag += 1;
    movieItem.heroTag = heroTag;
    return Material(
      elevation: 15.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetail(
                    movie: movieItem,
                  ),
            ),
          );
        },
        child: Hero(
          tag: heroTag,
          child: movieItem.posterPath != null
              ? Image.network(
                  "${Data.baseImageUrl}w342${movieItem.posterPath}",
                  fit: BoxFit.cover,
                )
              : Image.asset("assets/emptyfilmposters.jpg"),
        ),
      ),
    );
  }

  Widget _buildMovieListItem(Results resultItem) => Material(
        child: Container(
          width: 128.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(6.0),
                child: _buildMovieItem(resultItem),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 2.0),
                child: Text(
                  resultItem.title,
                  style: TextStyle(fontSize: 8.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 2.0),
                child: Text(
                  DateFormat('yyyy')
                      .format(DateTime.parse(resultItem.releaseDate)),
                  style: TextStyle(fontSize: 8.0),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildMoviesListView(
          Movie movie, String movieListTitle, String type) =>
      Container(
        height: 258.0,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
              child: Text(
                movieListTitle,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Flexible(
              child: _createListView(movie, type),
//              ListView(
//                scrollDirection: Axis.horizontal,
//                children: movie == null
//                    ? <Widget>[
//                        Center(
//                          child: CircularProgressIndicator(),
//                        )
//                      ]
//                    : movie.results
//                        .map((item) => Padding(
//                              padding: EdgeInsets.only(left: 6.0, right: 2.0),
//                              child: _buildMovieListItem(item),
//                            ))
//                        .toList(),
//              ),
            ),
          ],
        ),
      );

  Widget _createListView(Movie movie, String type) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: totalItem(type),
      itemBuilder: (BuildContext context, int index) {
        if (index >= movie.results.length - 1) {
          if (type == 'upcoming') {
            _pageNumberUpcoming++;
            _fetchUpcomingMovies();
          } else if (type == 'popular') {
            _pageNumberPopular++;
            _fetchPopularMovies();
          } else if (type == 'toprated') {
            _pageNumberTopRated++;
            _fetchTopRatedMoviews();
          }
        }
        return Padding(
          padding: EdgeInsets.only(left: 6.0, right: 2.0),
          child: _buildMovieListItem(movie.results[index]),
        );
      },
    );
  }

  int totalItem(String type) {
    if (type == 'upcoming') {
      return _totalItemsUpcoming;
    } else if (type == 'popular') {
      return _totalItemsPopular;
    } else if (type == 'toprated') {
      return _totalItemsTopRated;
    }
  }

  Widget _createDrawer() => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: UserAccountsDrawerHeader(
            accountName: Text("Movie App"),
            accountEmail: Text("Inc."),
          ),
          decoration: BoxDecoration(color: Colors.blue),
        ),
        InkWell(
          onTap: (){},
          child: ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
          ),
        ),
        InkWell(
          onTap: (){},
          child: ListTile(
            title: Text("Latest"),
            leading: Icon(Icons.movie),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
//        leading: IconButton(
//          icon: Icon(Icons.menu),
//          onPressed: () {},
//        ),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.search),
//            onPressed: () {},
//          ),
//          IconButton(
//            icon: Icon(Icons.local_movies),
//            onPressed: () {},
//          ),
        ],
      ),
//      drawer: _createDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'NOW PLAYING',
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              expandedHeight: 290.0,
              floating: false,
//              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        "${Data.baseImageUrl}w500/fw02ONlDhrYjTSZV8XO6hhU3ds3.jpg",
                        fit: BoxFit.cover,
                        width: 1000.0,
                        colorBlendMode: BlendMode.dstATop,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Column(
                        children: nowPlayingMovies == null
                            ? <Widget>[
                                Center(
                                  child: CircularProgressIndicator(),
                                )
                              ]
                            : <Widget>[
                                _buildCarouselSlider(),
                              ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ];
        },
        body: Center(
          child: ListView(
            children: <Widget>[
              _buildMoviesListView(upcomingMovie,
                  'COMING SOON ($_pageNumberUpcoming)', 'upcoming'),
              _buildMoviesListView(
                  pupolarMovie, 'POPULAR ($_pageNumberPopular)', 'popular'),
              _buildMoviesListView(topRatedMovie,
                  'TOP RATED ($_pageNumberTopRated)', 'toprated'),
            ],
          ),
        ),
      ),
//      bottomNavigationBar: BottomNavigationBar(
//        fixedColor: Colors.lightBlue,
//        currentIndex: _currentIndex,
//        onTap: (int index) {
//          setState(() => _currentIndex = index);
//        },
//        items: [
//          BottomNavigationBarItem(
//            icon: Icon(Icons.local_movies),
//            title: Text("All Movies"),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.tag_faces),
//            title: Text("Tickets"),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.person),
//            title: Text("Account"),
//          ),
//        ],
//      ),
    );
  }
}
