import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageScreen(),
    );
  }
}

class ImageScreen extends StatelessWidget {

  Widget makeImageGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
      itemBuilder: (context, index) {
        return ImageGridItem(index);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('images grid'),
      ),
      body: Container(
        child: makeImageGrid()
      ),
    );
  }
}

class ImageGridItem extends StatefulWidget {
  int _index;
  ImageGridItem(int index) {
    this._index = index;
  }

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {

  Uint8List imageFile;
  StorageReference photosReference = FirebaseStorage.instance.ref().child('photos');

  @override
  void initState() {
    super.initState();
    getImage();
  }


  getImage() {
    int MAX_SIZE = 7*1024*1024; 
    photosReference.child("${widget._index}.png").getData(MAX_SIZE).then((data) {
      this.setState(() {
        imageFile = data;
      });
    }).catchError((error) {

    });
  }

  Widget decideGridGridTileWidget() {
    if (imageFile == null) {
      return Center(child: Text('No Data'));
    } else {
      return Image.memory(
        imageFile,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: decideGridGridTileWidget()
    );
  }
}


