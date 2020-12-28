import 'dart:math';
import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as cv;

import 'package:moviesapp/movieDetailPage.dart';

// import "dart:async";
class MoviesList extends StatefulWidget {
  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  // _MoviesListState(){
  //   print("i'm inside constructor");
  //   _getMoviesList();
  // }
  Widget loadingWidget = SizedBox();
  double height, width;
  List<Widget> _listItems = List();
  bool isFetched = false;
  int page = 1;
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
          var r = Random();

          setState(() {
            isFetched = false;
            page = r.nextInt(100);
          });
          _getMoviesList(page);
        });
  }

  _getMoviesList(int page) async {
    _enableLoading();
    // Future.delayed(Duration(seconds: 5));
    var url = "https://yts.mx/api/v2/list_movies.json?page=$page";
    Response response = await get(url);
    // get(url).then((value) => _disableLoading());
    // print(response.body);
    _responseDecoder(response.body);
    _disableLoading();
    // Future<Response> response = await get(url);
  }

  Widget _cardBody() {
    if (isFetched == false) {
      _getMoviesList(page);
    }

    return Column(
      children: [
        loadingWidget,
        // Text('Movie of the year'),
        _singleCard(), _nextPage(),
      ],
    );
  }

  Widget _singleCard() {
    return Expanded(
      child: ListView(
        children: _listItems,
      ),
    );
  }

  Widget _card(
      String movieTitle, int movieYear, String movieImage, int movieId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetail(movieId: movieId)));
        // _gotoDetailPage(movieId);
      },
      child: Card(
        color: Colors.blue.shade100,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text('Title :'),
                Text(
                  movieTitle,
                  overflow: TextOverflow.visible,
                ),
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

  Widget _nextPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        RaisedButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              isFetched = false;
              page--;
            });
            _getMoviesList(page);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(page.toString(),style: TextStyle(fontSize: 20),),
        ),
        RaisedButton(
          child: Icon(Icons.arrow_forward),
          onPressed: () {
            setState(() {
              isFetched = false;
              page++;
            });
            _getMoviesList(page);
          },
        ),
      ],
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
      Widget eachCard = _card(movieTitle, movieYear, movieImage, movieId);
      tempList.add(eachCard);
    }
    _listItems = tempList;
    setState(() {
      this.isFetched = true;
    });
  }
}
