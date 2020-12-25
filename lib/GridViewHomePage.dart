import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart';
import 'NewPost.dart';
import 'PostDetails.dart';

class GridViewHomePage extends StatefulWidget {
  @override
  _GrivdViwHomePageState createState() => new _GrivdViwHomePageState();
}

class _GrivdViwHomePageState extends State<GridViewHomePage> {
  // build body start
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Sales').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return GridView.builder(
            padding: EdgeInsets.all(16.0),
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) =>
                                PostDetails(data: snapshot.data.docs[index])));
                      },
                      child: ListView(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 18 / 15,
                            child: Image.network(
                                snapshot.data.docs[index].data()["imageURL_1"],
                                fit: BoxFit.fill),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.docs[index].data()["title"],
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text('\$ ' +
                                      snapshot.data.docs[index]
                                          .data()["price"]
                                          .toString()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )));
            },
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2));
      },
    );
  }
  //build body end

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Garage Sale"),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.ballot),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new HomePage()),
                );
              }),
        ],
      ),
      body: buildBody(context), ////// build body
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new NewPost()),
          );
        },
        child: Icon(Icons.create_sharp),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
