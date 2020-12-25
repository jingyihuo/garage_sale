import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';
import 'dart:io';
import 'HomePage.dart';

class NewPost extends StatefulWidget {
  @override
  createState() => NewPostState();
}

class NewPostState extends State<NewPost> {
  String title = '';
  int price = 0;
  String description = '';
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final desController = TextEditingController();
  File testImage_1, testImage_2, testImage_3, testImage_4;
  String testImageUrl_1 = '',
      testImageUrl_2 = '',
      testImageUrl_3 = '',
      testImageUrl_4 = '';

  Future getImage1FromCamera(BuildContext context) async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      testImage_1 = File(image.path);
    });
  }

  Future getImage2FromCamera(BuildContext context) async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      testImage_2 = File(image.path);
    });
  }

  Future getImage3FromCamera(BuildContext context) async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      testImage_3 = File(image.path);
    });
  }

  Future getImage4FromCamera(BuildContext context) async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      testImage_4 = File(image.path);
    });
  }

  ///////////////////////////////

  Future testUploadImage1() async {
    await FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(testImage_1.path)}}')
        .putFile(testImage_1);
    var url = await FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(testImage_1.path)}}')
        .getDownloadURL();
    setState(() {
      testImageUrl_1 = url;
    });
  }

  Future testUploadImage2() async {
    await FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(testImage_2.path)}}')
        .putFile(testImage_2);
    var url = await FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(testImage_2.path)}}')
        .getDownloadURL();
    setState(() {
      testImageUrl_2 = url;
    });
  }

  Future testUploadImage3() async {
    await FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(testImage_3.path)}}')
        .putFile(testImage_3);
    var url = await FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(testImage_3.path)}}')
        .getDownloadURL();
    setState(() {
      testImageUrl_3 = url;
    });
  }

  Future testUploadImage4() async {
    await FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(testImage_4.path)}}')
        .putFile(testImage_4);
    var url = await FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(testImage_4.path)}}')
        .getDownloadURL();
    setState(() {
      testImageUrl_4 = url;
    });
  }

  //提交post
  Future addNewPost() async {
    /////先上传图片
    if (testImage_1 != null) {
      await testUploadImage1();
    }
    if (testImage_2 != null) {
      await testUploadImage2();
    }
    if (testImage_3 != null) {
      await testUploadImage3();
    }
    if (testImage_4 != null) {
      await testUploadImage4();
    }

    /////再提交文字
    await FirebaseFirestore.instance.collection("Sales").add({
      "title": titleController.text,
      "price": int.parse(priceController.text),
      "desc": desController.text,
      "imageURL_1": testImageUrl_1,
      "imageURL_2": testImageUrl_2,
      "imageURL_3": testImageUrl_3,
      "imageURL_4": testImageUrl_4,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Post Submitted'),
    ));
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new HomePage()),
    );
  }

  //submit后显示的对话框，问是continue还是cancel
  void confirmSubmitDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        addNewPost();
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Submit New Post"),
          content: Text("Would you like to continue?"),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text('New Post'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Builder(
          builder: (context) => (new ListView(
                children: [
                  ...[
                    new Container(
                        child: Column(children: [
                      new SizedBox(height: 28),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  getImage1FromCamera(context);
                                },
                                child: testImage_1 != null
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: 120.0,
                                        height: 120.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.file(
                                            testImage_1,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: 120.0,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey[50],
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.blueGrey,
                                        ),
                                      )),
                            GestureDetector(
                                onTap: () {
                                  getImage2FromCamera(context);
                                },
                                child: testImage_2 != null
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: 120.0,
                                        height: 120.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.file(
                                            testImage_2,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: 120.0,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey[50],
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.blueGrey,
                                        ),
                                      )),
                          ]),
                      new SizedBox(height: 28),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  getImage3FromCamera(context);
                                },
                                child: testImage_3 != null
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: 120.0,
                                        height: 120.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.file(
                                            testImage_3,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: 120.0,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey[50],
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.blueGrey,
                                        ),
                                      )),
                            GestureDetector(
                                onTap: () {
                                  getImage4FromCamera(context);
                                },
                                child: testImage_4 != null
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: 120.0,
                                        height: 120.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.file(
                                            testImage_4,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: 120.0,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey[50],
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.blueGrey,
                                        ),
                                      )),
                          ]),
                    ])),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        fillColor: Colors.blueGrey[30],
                        filled: true,
                        hintText: 'Enter a title...',
                        labelText: 'Title',
                      ),
                    ),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.attach_money),
                          SizedBox(width: 15),
                          Container(
                              width: 300,
                              child: TextField(
                                controller: priceController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor: Colors.blueGrey[30],
                                  filled: true,
                                  hintText: 'Enter a price...',
                                  labelText: 'Price',
                                ),
                              ))
                        ]),
                    TextField(
                      controller: desController,
                      decoration: InputDecoration(
                        fillColor: Colors.blueGrey[30],
                        filled: true,
                        hintText: 'Enter a description...',
                        labelText: 'Description',
                      ),
                      onChanged: (value) {
                        description = value;
                      },
                      maxLines: 6,
                    ),
                    RaisedButton(
                      child: const Text('Submit',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      color: Colors.blueGrey,
                      onPressed: () {
                        confirmSubmitDialog(context);
                      },
                    ),
                  ].expand(
                    (widget) => [
                      widget,
                      SizedBox(
                        height: 8,
                      )
                    ],
                  )
                ],
              ))),
    );
  }
}
