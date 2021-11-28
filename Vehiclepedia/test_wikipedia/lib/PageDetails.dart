import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_wikipedia/PageDetailsPojo.dart';

class PageDetails extends StatefulWidget {
String pageid;
PageDetails(this.pageid);
  @override
  _PageDetailsState createState() => _PageDetailsState(pageid);
}

class _PageDetailsState extends State<PageDetails> {
  String pageid;
  _PageDetailsState(this.pageid);
  bool _loading = false;
  PageDetailsPojo pojo;

  @override
  void initState() {hitApi();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:pojo!=null?Text(pojo.query.pages[0].title):Text("Wait"),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: ()  {
                Navigator.of(context).pop();
              }),
        ),
        body:   _loading?Center(child: loader(context)):SingleChildScrollView(

            child: pojo!=null?Column(children: [ pojo.query.pages[0].thumbnail!=null?Container(
              padding: EdgeInsets.all(8),
              height:double.parse("${pojo.query.pages[0].thumbnail.height}"),
              width:double.parse("${pojo.query.pages[0].thumbnail.width}"),
              child: pojo.query.pages[0].thumbnail!=null?Image.network(pojo.query.pages[0].thumbnail.source):SizedBox(),
            ):SizedBox(),
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Align(
                 alignment: Alignment.center,
                 child: Container(
                   child: Text(
                     pojo.query.pages[0].extract,style: TextStyle(color: Colors.black,  fontSize: 15,),textAlign: TextAlign.left,
                   ),
                 ),
               ),
             )
            ]):Text("Please wait..!!"),

    ));
  }
  loader(BuildContext context){
    return  CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
    );
  }
  hitApi() async {
    _loading=true;
    await http.get("https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts%7Cpageimages&pageids=$pageid&redirects=1&formatversion=2&exsentences=5&exintro=1&explaintext=1&piprop=thumbnail&pithumbsize=300")
        .then((value){
      print(value.body);
      setState(() {
        pojo=PageDetailsPojo.fromJson(json.decode(value.body));

        if(pojo.query.pages[0].thumbnail!=null){print(pojo.query.pages[0].thumbnail.source);}

        _loading=false;

      });

    });
  }
}