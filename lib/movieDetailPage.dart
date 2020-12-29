import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatefulWidget {
  final int movieId;

  MovieDetail({this.movieId});

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
  List<Widget> _castList = List();
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
          child:
              // ListView(children: _movieInfo)),
              ListView(children: [_movieInfoAndCast()])),
    );
  }

  Widget _movieInfoAndCast() {
    return Column(
      children: _movieInfo,
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
          Divider(),
        ],
      ),
    );
  }

  _detailPageAPICall(int movieId) async {
    // movieId = 15;
    print('going to detail page ');
    // _enableLoading();
    String url =
        "https://yts.mx/api/v2/movie_details.json?movie_id=$movieId&with_images=true&with_cast=true";
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
    List castInfoList = movieData['cast'];
    // if(castInfoList)
    List<Widget> tempList2 = List();
    if (castInfoList != null) {
      tempList2.add(Row(
        children: [
          Text(
            movieTitle + '/Cast',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ));
      for (int i = 0; i < castInfoList.length; i++) {
        List<Widget> castList = [];
        for (int i = 0; i < castInfoList.length; i++) {
          Map eachCastInfoMap = castInfoList[i];
          String castName = eachCastInfoMap['name'];
          String imageUrl = eachCastInfoMap['url_small_image'];
          if (imageUrl == null) {
            imageUrl =
                'https://previews.123rf.com/images/pe3check/pe3check1710/pe3check171000054/88673746-no-image-available-sign-internet-web-icon-to-indicate-the-absence-of-image-until-it-will-be-download.jpg';
          }

          Widget eachcast = _cast(castName, imageUrl);
          castList.add(eachcast);
        }
        //not working horizontal scroll
        // tempList2.add(ListView(
        //     scrollDirection: Axis.horizontal,
        //     children: [Row(children: castList)]));
        tempList2.add(Row(children: castList));
        break;
      }
    }

    // print(castInfoList);
    List torrentDataList = movieData['torrents'];
    for (int i = 0; i < torrentDataList.length; i++) {
      Map torrentInfoMap = torrentDataList[i];
      String url = torrentInfoMap['url'];
      String quality = torrentInfoMap['quality'];
      String downloadSize = torrentInfoMap['size'];
      Widget downloadInfo = _downloadInfo(url, quality, downloadSize);
      tempList.add(downloadInfo);
    }
    _movieInfo = tempList + tempList2;
    setState(() {});
  }

  Widget _downloadInfo(String url, String quality, String downloadSize) {
    return Container(
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
              onTap: () => launch(url),
              child: Text(
                'Download url',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue.shade900,
                    decoration: TextDecoration.underline),
              )),
          Text(quality),
          Text('Size: $downloadSize')
        ],
      ),
    );
  }

  Widget _cast(String name, String imageUrl) {
    return Container(
      height: height * .25,
      width: width * .22,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: height * .15,
            ),
            Text(name),

            // Row(
            //   children: [Text(title + '/Cast')],
            // ),
            // Card(
            //   child: Container(
            //     decoration: BoxDecoration(shape: BoxShape.circle),
            //     child: Column(
            //       children: [
            //         // Image.network(imageUrl),
            //         Text(name),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
