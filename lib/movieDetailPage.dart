import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatefulWidget {
  final int movieId;

  MovieDetail({this.movieId}) {

  }

  @override
  _MovieDetailState createState() => _MovieDetailState(movieId: movieId);
}

class _MovieDetailState extends State<MovieDetail> {
  double height, width;
  int movieId;
  _MovieDetailState({this.movieId}) {
    _detailPageAPICall(movieId);
  }
  List<Widget> _movieInfo = List();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page of Movie'),
      ),
      body: SizedBox(
          // height: height * .7,
          width: width,
          child: Column(children: _movieInfo)),
    );
  }

  Widget _detailCard(
    String movieTitle,
    double movieRating,
    int movieRuntime,
    String movieDescription,
  ) {
    return Card(
      color: Colors.blue.shade200,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Column(
            children: [
              Text(movieTitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ],
          ),
          Row(
            children: [Text('Rating :'), Text(movieRating.toString())],
          ),
          Row(
            children: [
              Text('Runtime :'),
              Text(movieRuntime.toString()),
            ],
          ),
          Column(
            children: [
              Text('Description :'),
              Text(
                movieDescription,
              ),
            ],
          ),

        ],
      ),
    );
  }

  _detailPageAPICall(int movieId) async {
    print('going to detail page ');
    // _enableLoading();
    String url =
        "https://yts.mx/api/v2/movie_details.json?movie_id=$movieId&with_images=false&with_cast=true";
    // String url = "https://yts.mx/api/v2/movie_details.json?movie_id=$movieId";
    Response response = await get(url);
    print('done get method ');
    // print(response.body);
    _responseDecoder(response.body);
    // _disableLoading();
  }

  _responseDecoder(String body) {
    // print(body);
    Map responseMap = jsonDecode(body);
    Map data = responseMap['data'];
    Map movieData = data['movie'];
    movieData.forEach((key, value) => print('$key: $value'));
    // print(movieData);
    // Widget tempCard = _detailCard()

    // print(movieData.length);

    String movieDescription = movieData['description_intro'];
    double movieRating = movieData['rating'];
    int movieRuntime = movieData['runtime'];
    String movieTitle = movieData['title'];

    // _detailCard(movieRuntime, movieRating, movieDescription )
    // print(movieData['']);
    List<Widget> tempList = List();
    Widget movieDetails =
        _detailCard(movieTitle, movieRating, movieRuntime, movieDescription);
    tempList.add(movieDetails);
    List torrentDataList = movieData['torrents'];
    for (int i = 0; i < torrentDataList.length; i++) {
      Map torrentInfoMap = torrentDataList[i];
      String url = torrentInfoMap['url'];
      String quality = torrentInfoMap['quality'];
      String downloadSize = torrentInfoMap['size'];
      Widget downloadInfo = _downloadInfo(url, quality, downloadSize);
      tempList.add(downloadInfo);
    }
    _movieInfo = tempList;
    setState(() {});
  }

  Widget _downloadInfo(String url, String quality, String downloadSize) {
    return Container(
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(onTap: () => launch(url), child: Text('Download url')),
          Text(quality),
          Text('Size: $downloadSize')
        ],
      ),
    );
  }
}
