// ignore_for_file: unnecessary_new

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:review/constants/routes.dart';
import 'package:review/home.dart';
import 'package:review/page/profile.dart';

XFile? image;
String? filename;

class CreateRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              recipeRoute,
              (route) => false,
            );
          },
        ),
        title: const Text('Add Restaurent'),
      ),
      body: MyAddPage(),
    );
  }
}

class CommonThings {
  static Size? size;
}

class MyAddPage extends StatefulWidget {
  @override
  _MyAddPageState createState() => _MyAddPageState();
}

class _MyAddPageState extends State<MyAddPage> {
  TextEditingController name = TextEditingController();
  TextEditingController des = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController feature = TextEditingController();
  TextEditingController Amenties = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Form(
            // key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // ignore: unnecessary_new

                    //image
                    new Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.blueAccent),
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: image == null
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.4,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/user1.png'),
                                  )),
                            )
                          : Container(
                              color: Colors.grey,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Expanded(
                                child: Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    const Divider(),
                    new IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final img =
                            await picker.pickImage(source: ImageSource.camera);
                        setState(() {
                          image = img;
                        });
                      },
                    ),
                    const Divider(),
                    new IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final img =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          image = img;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 10),
                  child: Text('Restaurent Name',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
//name
                Container(
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ' Restaruent Name',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 10),
                  child: Text('Description',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                //description
                Container(
                  child: TextFormField(
                    controller: des,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 10),
                  child: Text('location',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                // location
                Container(
                  child: TextFormField(
                    controller: location,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'location',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 10),
                  child: Text('features',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                //features
                Container(
                  child: TextFormField(
                    controller: feature,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'features',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 10),
                  child: Text('Amenities',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                //Amenities
                Container(
                  child: TextFormField(
                    maxLines: 4,
                    controller: Amenties,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Amenities',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FutureBuilder(
                  future: dataa(),
                  builder: (context, snap) {
                    var cc = snap.data.toString();
                    return ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Created Successfully'),
                                content: InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Container(
                                            child: Text('Creted successfully'),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen()));
                                    },
                                    child: Text('Done')),
                              );
                            });
                        FirebaseFirestore.instance
                            .collection('review')
                            .doc(name.text)
                            .set({
                          'name': name.text,
                          'des': des.text,
                          'email': cc,
                          'location': location.text,
                          'feature': feature.text,
                          'amenties': Amenties.text,
                          'individualrating': '4.1',
                          'review': [
                            {
                              'click': false,
                              'comment': '',
                              'like': {},
                              'unlike': {},
                              'user': cc,
                              'user_image': 'user_image'
                            }
                          ],
                          'image': ''
                        });
                        UploadTask? uploadTask;
                        var ref = FirebaseStorage.instance
                            .ref()
                            .child('review')
                            .child(name.text);
                        ref.putFile(File(image!.path));
                        uploadTask = ref.putFile(File(image!.path));
                        final snap = await uploadTask.whenComplete(() {});
                        final urls = await snap.ref.getDownloadURL();
                        var user = await FirebaseFirestore.instance
                            .collection('review')
                            .doc(name.text);
                        await user.update({'image': urls});
                      },
                      child: const Text('Create',
                          style: TextStyle(color: Colors.white)),
                    );
                  }),
            ],
          )
        ],
      ),
    );
  }
}
