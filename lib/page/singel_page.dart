// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review/page/profile.dart';
import 'package:review/utilities/rating_bar.dart';
import 'package:review/utilities/show_snack_bar.dart';

class IndividualPage extends StatefulWidget {
  String image;
  String name;
  String des;
  String location;
  String feature;
  String amenities;

  IndividualPage(
      {super.key,
      required this.des,
      required this.image,
      required this.feature,
      required this.name,
      required this.amenities,
      required this.location});

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  TextEditingController feedback = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    feedback.clear();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    feedback.dispose();
    super.dispose();
  }

  int num = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(30),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image:
                            DecorationImage(image: NetworkImage(widget.image))),
                  ),
                  //name
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Restaurent Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('review')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.038,
                          child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    // rating
                                    RatingBarWidget(
                                      rating: snapshot.data!.docs[index]
                                          ['individualrating'],
                                      name: widget.name[index],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          num++;
                                          print(num);
                                        });
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              18.0),
                                                      child: Text(
                                                        'Comment',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 30),
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 2,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor:
                                                                Colors.black,
                                                            child: CircleAvatar(
                                                              radius: 23,
                                                              backgroundColor:
                                                                  Colors.grey,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        'assets/images/signup.png'),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        SizedBox(
                                                          height: 40,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: TextField(
                                                            controller:
                                                                feedback,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                            maxLines: 1,
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  FutureBuilder(
                                                                      future:
                                                                          dataa(),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        return InkWell(
                                                                          onTap:
                                                                              () {
                                                                            FirebaseFirestore.instance.collection('review').doc(widget.name).update({
                                                                              'review': FieldValue.arrayUnion([
                                                                                feedback.text
                                                                              ]
                                                                                  .map((e) => {
                                                                                        'user': '${snapshot.data}',
                                                                                        'user_image': 'user_image',
                                                                                        'comment': feedback.text,
                                                                                        'like': [],
                                                                                        'unlike': [],
                                                                                        'click': false
                                                                                      })
                                                                                  .toList()),
                                                                            });

                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.send,
                                                                            color:
                                                                                Colors.blue,
                                                                          ),
                                                                        );
                                                                      }),
                                                              hintText:
                                                                  'Add a comment ...',
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      thickness: 2,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(18.0),
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          primary: false,
                                                          itemCount: snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['review']
                                                              .toList()
                                                              .length,
                                                          itemBuilder: (context,
                                                              index1) {
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        CircleAvatar(
                                                                          radius:
                                                                              25,
                                                                          backgroundColor:
                                                                              Colors.black,
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                23,
                                                                            backgroundColor:
                                                                                Colors.grey,
                                                                            child:
                                                                                CircleAvatar(radius: 20, backgroundImage: AssetImage('assets/images/signup.png')),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]['review'][index1]['user'],
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    FutureBuilder(
                                                                        future:
                                                                            dataa(),
                                                                        builder:
                                                                            (context,
                                                                                snapp) {
                                                                          return PopupMenuButton<
                                                                              int>(
                                                                            itemBuilder: (context) =>
                                                                                [
                                                                              PopupMenuItem(
                                                                                value: 1,
                                                                                child: Row(
                                                                                  children: const [
                                                                                    Icon(Icons.report_gmailerrorred),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Text("Report")
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              if (snapp.data.toString() == snapshot.data!.docs[index]['review'][index1]['user'])
                                                                                PopupMenuItem(
                                                                                  value: 2,
                                                                                  child: Row(
                                                                                    children: const [
                                                                                      Icon(Icons.delete),
                                                                                      SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      Text("delete")
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              if (snapp.data.toString() == snapshot.data!.docs[index]['review'][index1]['user'])
                                                                                PopupMenuItem(
                                                                                  value: 3,
                                                                                  child: Row(
                                                                                    children: const [
                                                                                      Icon(Icons.edit),
                                                                                      SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      Text("edit")
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                            offset:
                                                                                Offset(0, 40),
                                                                            color:
                                                                                Colors.white,
                                                                            elevation:
                                                                                2,
                                                                            onSelected:
                                                                                (value) {
                                                                              if (value == 1) {
                                                                                _showDialog2(context);
                                                                              } else if (value == 3) {
                                                                                if (snapp.data.toString() == snapshot.data!.docs[index]['review'][index1]['user']) {
                                                                                  _showDialog(
                                                                                    context,
                                                                                    user: snapshot.data!.docs[index]['review'][index1]['user'],
                                                                                    user_image: snapshot.data!.docs[index]['review'][index1]['user_image'],
                                                                                    comment: snapshot.data!.docs[index]['review'][index1]['comment'],
                                                                                    click: snapshot.data!.docs[index]['review'][index1]['click'],
                                                                                    like: snapshot.data!.docs[index]['review'][index1]['like'],
                                                                                    unlike: snapshot.data!.docs[index]['review'][index1]['unlike'],
                                                                                    name: widget.name,
                                                                                  );
                                                                                }
                                                                              } else if (value == 2) {
                                                                                if (snapp.data.toString() == snapshot.data!.docs[index]['review'][index1]['user']) {
                                                                                  _showDialog1(
                                                                                    context,
                                                                                    user: snapshot.data!.docs[index]['review'][index1]['user'],
                                                                                    user_image: snapshot.data!.docs[index]['review'][index1]['user_image'],
                                                                                    comment: snapshot.data!.docs[index]['review'][index1]['comment'],
                                                                                    click: snapshot.data!.docs[index]['review'][index1]['click'],
                                                                                    like: snapshot.data!.docs[index]['review'][index1]['like'],
                                                                                    unlike: snapshot.data!.docs[index]['review'][index1]['unlike'],
                                                                                    name: widget.name,
                                                                                  );
                                                                                }
                                                                              }
                                                                            },
                                                                          );
                                                                        }),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              60),
                                                                  child:
                                                                      FutureBuilder(
                                                                          future:
                                                                              dataa(),
                                                                          builder:
                                                                              (context, snap) {
                                                                            return Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  snapshot.data!.docs[index]['review'][index1]['comment'],
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Text(
                                        ' ( ${snapshot.data!.docs[index]['review'].toList().length} Reviews ) ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }
                              // else {
                              //   return SizedBox();
                              // }
                              // },
                              ),
                        );
                      },
                    ),
                  ),

                  Divider(),

                  //des

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.des,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),

                  //location

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.location,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),

                  //inagredients

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Features',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.feature,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),

                  //amenities

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Amenties',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.amenities,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

//delete
  void _showDialog1(
    BuildContext context, {
    required String user,
    required String name,
    required String user_image,
    required String comment,
    required bool click,
    required List<dynamic> like,
    required List<dynamic> unlike,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Do you want to delete your comment ? "),
          actions: [
            MaterialButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('review')
                    .doc(name)
                    .update({
                  //
                  'review': FieldValue.arrayRemove([feedback.text]
                      .map((e) => {
                            'user': user,
                            'user_image': user_image,
                            'comment': comment,
                            'like': like,
                            'unlike': unlike,
                            'click': click
                          })
                      .toList()),
                });
                showsnackBar(
                    context: context,
                    text: 'Deleted successfully',
                    color: Colors.green);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//edit
  void _showDialog(
    BuildContext context, {
    required String user,
    required String name,
    required String user_image,
    required String comment,
    required bool click,
    required List<dynamic> like,
    required List<dynamic> unlike,
  }) {
    TextEditingController controller = TextEditingController(text: comment);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Comment "),
          content: Container(
            margin: EdgeInsets.all(5),
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              maxLength: 500,
              maxLines: 5,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                filled: true,
                fillColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black, width: 2)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black, width: 2)),
              ),
            ),
          ),
          actions: [
            MaterialButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text(
                "Edit",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('review')
                      .doc(name)
                      .update({
                    //
                    'review': FieldValue.arrayRemove([feedback.text]
                        .map((e) => {
                              'user': user,
                              'user_image': user_image,
                              'comment': comment,
                              'like': like,
                              'unlike': unlike,
                              'click': click
                            })
                        .toList()),
                  });
                  FirebaseFirestore.instance
                      .collection('review')
                      .doc(name)
                      .update({
                    'review': FieldValue.arrayUnion([feedback.text]
                        .map((e) => {
                              'user': user,
                              'user_image': user_image,
                              'comment': controller.text,
                              'like': like,
                              'unlike': unlike,
                              'click': click
                            })
                        .toList()),
                  });
                  showsnackBar(
                      context: context,
                      text: 'Edit successfully',
                      color: Colors.green);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else {
                  FirebaseFirestore.instance
                      .collection('review')
                      .doc(name)
                      .update({
                    'review': FieldValue.arrayUnion([feedback.text]
                        .map((e) => {
                              'user': user,
                              'user_image': user_image,
                              'comment': comment,
                              'like': like,
                              'unlike': unlike,
                              'click': click
                            })
                        .toList()),
                  });
                  showsnackBar(
                      context: context,
                      text: 'Edit successfully',
                      color: Colors.green);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

//report
  void _showDialog2(
    BuildContext context,
  ) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report Comment "),
          content: Container(
            margin: EdgeInsets.all(5),
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              maxLength: 500,
              maxLines: 5,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                filled: true,
                fillColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black, width: 2)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black, width: 2)),
              ),
            ),
          ),
          actions: [
            MaterialButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text(
                "Report",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  showsnackBar(
                      context: context,
                      text: 'Reported successfully',
                      color: Colors.green);
                } else {
                  showsnackBar(
                      context: context,
                      text: 'Enpty valued or null value cannot be recorded',
                      color: Colors.red);
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
