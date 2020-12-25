import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart';

class PostDetails extends StatefulWidget {
  final DocumentSnapshot data;
  PostDetails({this.data});
  @override
  _PostDetailsState createState() => new _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new HomePage()),
                );
              },
            );
          },
        ),
        title: new Text("Post Details"),
        backgroundColor: Colors.blueGrey,
      ),
      body: new Card(
        elevation: 10.0,
        margin: EdgeInsets.all(10.0),
////////////////
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  new SizedBox(
                    height: 20,
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            width: 120.0,
                            height: 120.0,
                            padding: new EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) => ImageFullScreen(
                                            url: widget.data
                                                .data()['imageURL_1'])));
                              }, // handle your image tap here
                              child: Image.network(
                                widget.data.data()['imageURL_1'],
                                fit: BoxFit
                                    .cover, // this is the solution for border
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            width: 120.0,
                            height: 120.0,
                            padding: new EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) => ImageFullScreen(
                                            url: widget.data
                                                .data()['imageURL_2'])));
                              }, // handle your image tap here
                              child: Image.network(
                                widget.data.data()['imageURL_2'],
                                fit: BoxFit
                                    .cover, // this is the solution for border
                              ),
                            )),
                      ]),
                  new SizedBox(
                    height: 15,
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            width: 120.0,
                            height: 120.0,
                            padding: new EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) => ImageFullScreen(
                                            url: widget.data
                                                .data()['imageURL_3'])));
                              }, // handle your image tap here
                              child: Image.network(
                                widget.data.data()['imageURL_3'],
                                fit: BoxFit
                                    .cover, // this is the solution for border
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            width: 120.0,
                            height: 120.0,
                            padding: new EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) => ImageFullScreen(
                                            url: widget.data
                                                .data()['imageURL_4'])));
                              }, // handle your image tap here
                              child: Image.network(
                                widget.data.data()['imageURL_4'],
                                fit: BoxFit
                                    .cover, // this is the solution for border
                              ),
                            )),
                      ]),
                  new Container(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: <Widget>[
                          new Text(
                            widget.data.data()['title'],
                            style: TextStyle(fontSize: 28.0),
                          ),
                        ],
                      )),
                  new Container(
                    margin: EdgeInsets.all(20.0),
                    child: new Text(
                      '\$ ' + widget.data.data()['price'].toString(),
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.all(20.0),
                    child: new Text(
                      widget.data.data()['desc'],
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageFullScreen extends StatelessWidget {
  final String url;
  const ImageFullScreen({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: new Image.network(
        url,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
