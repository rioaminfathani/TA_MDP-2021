import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_wikipedia/PageDetails.dart';
import 'package:test_wikipedia/wikiList.dart';

import 'package:test_wikipedia/main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String query = "";
  bool _loading = false;
  WikiList data_list = new WikiList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getMaterialSearchBar(),
      body: Column(
        children: [
          Container(
            child: TextField(
              autofocus: true,
              onSubmitted: (value) {
                setState(() {
                  _loading = true;
                  //hit API

                  hitApi(value);
                  FocusScope.of(context).unfocus();
                  query = "";
                  // http.Response response =
                });
              },
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 10.0, 0.0, 10.0),
                border: new OutlineInputBorder(),
                filled: true,
                hintText: 'Search Here',
              ),
            ),
          ),
          _loading
              ? Center(child: loader(context))
              : data_list.query != null
                  ? Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.orange,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: data_list != null
                            ? data_list.query.pages.length
                            : 0,
                        itemBuilder: (context, index) {
                          return notificationWidget(index);
                        },
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Text("No data found"),
                    ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text('Liked'),
              backgroundColor: Colors.amber)
        ],
        onTap: (index) {
          // Navigate to second route when tapped.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThisApp()),
          );
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  loader(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
    );
  }

  notificationWidget(int index) {
    return Container(
        child: InkWell(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PageDetails("${data_list.query.pages[index].pageid}")));
      }),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                        image: DecorationImage(
                          image: data_list.query.pages[index].thumbnail != null
                              ? NetworkImage(
                                  data_list.query.pages[index].thumbnail.source)
                              : AssetImage("assets/images/ic_profile.png"),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * .72,
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text: data_list.query.pages[index].title +
                                          " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16)),
                                  TextSpan(
                                      text:
                                          data_list.query.pages[index].terms !=
                                                  null
                                              ? data_list.query.pages[index]
                                                  .terms.description[0]
                                              : "Description not available",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 12)),
                                ]))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget getMaterialSearchBar() {
    return AppBar(
      title: Text("Vehiclepedia Search", style: TextStyle(color: Colors.white)),
    );
  }

  hitApi(String text) async {
    await http
        .get(
            "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=100&pilimit=10&wbptterms=description&gpssearch=$text+T&gpslimit=20")
        .then((value) {
      setState(() {
        _loading = false;
        data_list = WikiList.fromJson(json.decode(value.body));
      });
    });
  }
}
