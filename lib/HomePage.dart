import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'NewPost.dart';
import 'PostDetails.dart';
import 'GridViewHomePage.dart';
import 'Login.dart';
import 'Authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // build body start
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Sales').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) =>
                                PostDetails(data: snapshot.data.docs[index])));
                      },
                      child: ListTile(
                          title:
                              Text(snapshot.data.docs[index].data()["title"]),
                          subtitle: Text(
                            snapshot.data.docs[index].data()["desc"],
                            maxLines: 2,
                          ),
                          isThreeLine: true,
                          leading: AspectRatio(
                            aspectRatio: 18 / 18,
                            child: Image.network(
                                snapshot.data.docs[index].data()["imageURL_1"],
                                fit: BoxFit.fill),
                          ),
                          trailing: Text('\$ ' +
                              snapshot.data.docs[index]
                                  .data()["price"]
                                  .toString()),
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => PostDetails(
                                    data: snapshot.data.docs[index])));
                          })));
            });
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
              icon: new Icon(Icons.apps),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new GridViewHomePage()),
                );
              }),
          new IconButton(
              icon: new Icon(Icons.person),
              onPressed: () {
                _logoutUser();
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new Login()),
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
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("my name"),
              accountEmail: new Text("my email"),
              decoration: new BoxDecoration(color: Colors.blueGrey),
            ),
            new ListTile(
              title: new Text("Profile"),
              leading: new Icon(
                Icons.person,
                color: Colors.purple,
              ),
            ),
            new ListTile(
              title: new Text("Message"),
              leading: new Icon(
                Icons.message,
                color: Colors.redAccent,
              ),
            ),
            new ListTile(
              title: new Text("Setting"),
              leading: new Icon(
                Icons.settings,
                color: Colors.orange,
              ),
            ),
            new Divider(
              height: 10.0,
              color: Colors.black,
            ),
            new ListTile(
              title: new Text("Close"),
              trailing: new Icon(
                Icons.close,
                color: Colors.red,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
