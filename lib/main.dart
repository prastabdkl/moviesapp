import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/home.dart';
import 'package:moviesapp/movieslist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      // home: MoviesList(),
      routes: {"/moviesList": (context) => MoviesList()},
    );
  }
}
