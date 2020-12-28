import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blue.shade200,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text('Title :'),
                // Text(movieTitle),
              ],
            ),
            Row(
              children: [
                Text('Year :'),
                // Text(movieYear.toString()),
              ],
            ),
            // Image.network(movieImag),
          ],
        ),
      ),
  }
}