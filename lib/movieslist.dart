import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as cv;

// import "dart:async";
class MoviesList extends StatefulWidget {
  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  Widget loadingWidget = SizedBox();
  double height, width;
  List<Widget> _listItems = List();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        // textTheme: ,
        title: Text('Movies List'),
        actions: [_refreshButton()],
      ),
      body: _cardBody(),
    );
  }

  Widget _refreshButton() {
    return IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          _getMoviesList();
        });
  }

  _getMoviesList() async {
    _enableLoading();
    // Future.delayed(Duration(seconds: 5));
    var url = "https://yts.mx/api/v2/list_movies.json";
    Response response = await get(url);
    // get(url).then((value) => _disableLoading());
    // print(response.body);
    _responseDecoder(response.body);
    _disableLoading();
    // Future<Response> response = await get(url);
  }

  Widget _cardBody() {
    // _getMoviesList();
    return Column(
      children: [
        loadingWidget,
        // Text('Movie of the year'),
        _singleCard(),
        RaisedButton(
          onPressed: () {},
          child: _nextPage(),
        )
      ],
    );
  }

  Widget _singleCard() {
    return SizedBox(
      height: height * .81,
      width: width,
      child: ListView(
        children: _listItems,
      ),
    );
  }

  Widget _card(String movieTitle, int movieYear, String movieImage) {
    return GestureDetector(
      onTap: () {
        _gotoDetailPage();
      },
      child: Card(
        color: Colors.blue.shade100,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text('Title :'),
                Text(movieTitle),
              ],
            ),
            Row(
              children: [
                Text('Year :'),
                Text(movieYear.toString()),
              ],
            ),
            Image.network(movieImage),
          ],
        ),
      ),
    );
  }

  _gotoDetailPage() async {
    print('going to detail page ');
    _enableLoading();
    String url = "https://yts.mx/api/v2/movie_details.json?movie_id=25409";
    Response response = await get(url);
    print(response.body);
    _disableLoading();
  }

  Widget _nextPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [Text('Goto Next Page'), Icon(Icons.arrow_forward)],
    );
  }

  _enableLoading() {
    setState(() {
      // print('enable Setstate called');
      loadingWidget = LinearProgressIndicator(
        backgroundColor: Colors.red,
        minHeight: 10,
      );
    });
  }

  _disableLoading() {
    setState(() {
      // print('disable Setstate called');
      loadingWidget = SizedBox();
    });
  }

  _responseDecoder(String body) {
    Map responseMap = cv.jsonDecode(body);
    // print(responseMap);
    // print(responseMap.length);
    // print(responseMap.keys);
    // responseMap.forEach((k, v) => print('$k: $v'));
    // for(Map each in responseMap){
    // for (int i = 0; i < responseMap.length; i++) {
    //   Map data = responseMap['data'];
    //   // print(data);
    //   print(data.length);

    // }
    Map data = responseMap['data'];
    // data.forEach((k, v) => print('$k: $v'));
    List movieInfo = data['movies'];
    // print(movieInfo.length);
    // print(movieInfo[2]);

    Map _eachMoviedata = movieInfo[0];
    _eachMoviedata.forEach((k, v) => print('$k: $v'));
    List<Widget> tempList = List();
    for (int i = 0; i < movieInfo.length; i++) {
      Map _eachMoviedata = movieInfo[i];
      String movieTitle = _eachMoviedata['title'];
      String movieImage = _eachMoviedata['medium_cover_image'];
      // String movieImage = _eachMoviedata['cover_image'];
      int movieYear = _eachMoviedata['year'];
      int movieId = _eachMoviedata['id'];
      Widget eachCard = _card(movieTitle, movieYear, movieImage);
      tempList.add(eachCard);
    }
    _listItems = tempList;
    setState(() {});
  }
}
