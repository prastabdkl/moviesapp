import 'package:flutter/material.dart';
import 'package:moviesapp/movieslist.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'To get the list of hot movies',
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              _button(context),
            ]),
      ),
    );
  }

  Widget _button(BuildContext context) {
    return Container(
      // width: Get.width,
      // height: Get.height*.3,

      child: OutlinedButton(
        onPressed: () async {
          await Navigator.pushNamed(context, "/moviesList");
          await Future.delayed(Duration(seconds: 2));
          _displayDialog(context);
        },
        child: Text(
          'Click here',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      // decoration: BoxDecoration(color: Colors.black,
    );
    // );
  }

  void _displayDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              backgroundColor: Colors.green,
              title: Text('You have exited the movies list'));
        });
  }
}
