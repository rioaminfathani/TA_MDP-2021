// To parse this JSON data, do
//
//     final pageDetailsPojo = pageDetailsPojoFromJson(jsonString);

import 'dart:convert';

PageDetailsPojo pageDetailsPojoFromJson(String str) => PageDetailsPojo.fromJson(json.decode(str));

String pageDetailsPojoToJson(PageDetailsPojo data) => json.encode(data.toJson());

class PageDetailsPojo {
  PageDetailsPojo({
    this.batchcomplete,
    this.query,
  });

  bool batchcomplete;
  Query query;

  factory PageDetailsPojo.fromJson(Map<String, dynamic> json) => PageDetailsPojo(
    batchcomplete: json["batchcomplete"] == null ? null : json["batchcomplete"],
    query: json["query"] == null ? null : Query.fromJson(json["query"]),
  );

  Map<String, dynamic> toJson() => {
    "batchcomplete": batchcomplete == null ? null : batchcomplete,
    "query": query == null ? null : query.toJson(),
  };
}

class Query {
  Query({
    this.pages,
  });

  List<Page> pages;

  factory Query.fromJson(Map<String, dynamic> json) => Query(
    pages: json["pages"] == null ? null : List<Page>.from(json["pages"].map((x) => Page.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pages": pages == null ? null : List<dynamic>.from(pages.map((x) => x.toJson())),
  };
}

class Page {
  Page({
    this.pageid,
    this.ns,
    this.title,
    this.extract,
    this.thumbnail,
  });

  int pageid;
  int ns;
  String title;
  String extract;
  Thumbnail thumbnail;

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    pageid: json["pageid"] == null ? null : json["pageid"],
    ns: json["ns"] == null ? null : json["ns"],
    title: json["title"] == null ? null : json["title"],
    extract: json["extract"] == null ? null : json["extract"],
    thumbnail: json["thumbnail"] == null ? null : Thumbnail.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "pageid": pageid == null ? null : pageid,
    "ns": ns == null ? null : ns,
    "title": title == null ? null : title,
    "extract": extract == null ? null : extract,
    "thumbnail": thumbnail == null ? null : thumbnail.toJson(),
  };
}

class Thumbnail {
  Thumbnail({
    this.source,
    this.width,
    this.height,
  });

  String source;
  int width;
  int height;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
    source: json["source"] == null ? null : json["source"],
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
  );

  Map<String, dynamic> toJson() => {
    "source": source == null ? null : source,
    "width": width == null ? null : width,
    "height": height == null ? null : height,
  };
}
