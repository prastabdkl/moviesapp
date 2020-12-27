import 'package:flutter/material.dart';
import 'package:http/http.dart';

// import "dart:async";
class MoviesList extends StatefulWidget {
  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  Widget _loadingWidget = SizedBox();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text('Movies List'),
        actions: [_refreshButton()],
      ),
      body: _moviesList(),
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
    var url = "https://yts.mx/api/v2/list_movies.json";
    Response response = await get(url);
    // get(url).then((value) => _disableLoading());
    print(response.body);
    _disableLoading();
    // Future<Response> response = await get(url);
  }

  Widget _moviesList() {
    // _getMoviesList();
    return Column(
      children: [
        // _loadingWidget,
        RaisedButton(
          onPressed: () {},
          child: _nextPage(),
        )
      ],
    );
  }

  Widget _nextPage() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [Text('Goto Next Page'), Icon(Icons.arrow_forward)],
    );
  }

  _enableLoading() {
    setState(() {
      _loadingWidget = LinearProgressIndicator();
    });
  }

  _disableLoading() {
    setState(() {
      _loadingWidget = SizedBox();
    });
  }
}
