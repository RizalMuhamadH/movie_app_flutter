import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/movieDetailModel.dart';
import 'package:intl/intl.dart';
import './models/data.dart';
import './models/movieModel.dart';
import './models/movieCreditsModel.dart';
import './models/cast_crew.dart';

const apiKey = Data.apiKey;

class MovieDetail extends StatefulWidget {
  final Results movie;

  MovieDetail({this.movie});

  @override
  _MovieDetail createState() => new _MovieDetail();
}

class _MovieDetail extends State<MovieDetail> {
//  String movieDetailUrl;
  MovieDetailModel detail;
  MovieCredits credits;
  List<CastCrew> castCrew = new List<CastCrew>();

  bool isLoading;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetail();
    _fetchMovieCredits();
  }

  void _fetchMovieDetail() async {
    var response = await http.get(
        "${Data.baseDetailUrl}${widget.movie.id}?api_key=$apiKey&language=en-US");
    var decodeJson = jsonDecode(response.body);
    setState(() {
      detail = MovieDetailModel.fromJson(decodeJson);
    });
  }

  void _fetchMovieCredits() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(
        "${Data.baseDetailUrl}${widget.movie.id}/credits?api_key=$apiKey&language=en-US");
    var decodeJson = jsonDecode(response.body);
    credits = MovieCredits.fromJson(decodeJson);

    credits.cast.forEach((c) => castCrew.add(CastCrew(
        id: c.castId,
        name: c.name,
        subName: c.character,
        imagePath: c.profilePath,
        personType: "Actors")));

    credits.crew.forEach((c) => castCrew.add(CastCrew(
        id: c.id,
        name: c.name,
        subName: c.job,
        imagePath: c.profilePath,
        personType: "Crew")));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final moviePoster = Container(
      height: 350.0,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Center(
        child: Card(
          elevation: 15.0,
          child: Hero(
            tag: widget.movie.heroTag,
            child: Image.network(
              "${Data.baseImageUrl}w342${widget.movie.posterPath}",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    final movieTitle = Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Center(
        child: Text(
          widget.movie.title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    final movieTickets = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          detail != null ? _getMovieDuration(detail.runtime) : '',
          style: TextStyle(
            fontSize: 11.0,
          ),
        ),
        Container(
          height: 20.0,
          width: 1.0,
          color: Colors.black,
        ),
        Text(
          "Relese Date : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.movie.releaseDate))}",
          style: TextStyle(
            fontSize: 11.0,
          ),
        ),
        RaisedButton(
          onPressed: () {},
          shape: StadiumBorder(),
          elevation: 15.0,
          color: Colors.red[700],
          child: Text(
            "Tickets",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );

    final genreList = Container(
      height: 25.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: detail == null
              ? []
              : detail.genres
                  .map(
                    (g) => Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: FilterChip(
                            backgroundColor: Colors.grey[600],
                            labelStyle: TextStyle(fontSize: 10.0),
                            label: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(g.name),
                            ),
                            onSelected: (b) {},
                          ),
                        ),
                  )
                  .toList(),
        ),
      ),
    );

    final middleContent = Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          genreList,
          Divider(),
          Text(
            "SYNOPSIS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.movie.overview,
            style: TextStyle(color: Colors.grey, fontSize: 11.0),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );

    Widget _buildCastCrewContent(String personType) => Container(
          height: 115.0,
          padding: EdgeInsets.only(top: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  personType,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: isLoading
                      ? <Widget>[
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ]
                      : castCrew
                          .where((type) => type.personType == personType)
                          .map((item) => Padding(
                                padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                child: Container(
                                  width: 65.0,
                                  child: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 28.0,
                                        backgroundImage: item.imagePath != null
                                            ? NetworkImage(
                                                "${Data.baseImageUrl}w154${item.imagePath}")
                                            : AssetImage(
                                                "assets/person_icon.png"),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                              fontSize: 8.0,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        item.subName,
                                        style: TextStyle(fontSize: 8.0),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                ),
              ),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Movies Detail",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          moviePoster,
          movieTitle,
          movieTickets,
          middleContent,
          _buildCastCrewContent("Actors"),
          _buildCastCrewContent("Crew"),
//          castContent,
//          crewContent,
        ],
      ),
    );
  }

  String _getMovieDuration(int runtime) {
    if (runtime == null) return "No data";
    double movieHours = runtime / 60;
    int movieMunites = ((movieHours - movieHours.floor()) * 60).round();
    return "${movieHours.floor()}h ${movieMunites}min";
  }
}
