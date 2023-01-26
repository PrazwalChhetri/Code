// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:review/page/singel_page.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'HomeScreen';
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: IndividualHotel(),
    );
  }
}

class IndividualHotel extends StatefulWidget {
  const IndividualHotel({
    Key? key,
  }) : super(key: key);

  @override
  State<IndividualHotel> createState() => _IndividualHotelState();
}

class _IndividualHotelState extends State<IndividualHotel> {
  @override
  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('review').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index1) {
                      var info = snapshot.data!.docs[index1];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndividualPage(
                                image: snapshot.data!.docs[index1]['image'],
                                name: snapshot.data!.docs[index1]['name'],
                                location: snapshot.data!.docs[index1]
                                    ['location'],
                                des: snapshot.data!.docs[index1]['des'],
                                feature: snapshot.data!.docs[index1]['feature'],
                                amenities: snapshot.data!.docs[index1]
                                    ['amenties'],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 300,
                                width: 250,
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(15),
                                decoration: (BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: NetworkImage(info['image']),
                                      fit: BoxFit.cover),
                                )),
                              ),
                              Container(
                                height: 300,
                                width: 250,
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(15),
                                decoration: (BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withOpacity(0.5),
                                )),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //name
                                    Text(
                                      info['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //des
                                    Text(
                                      info['des'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    //row  of location price rating
                                    FittedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  info['location'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                // '( ${info[index].rating} )',
                                                '5.0',
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Text('data not found');
              }
            }));
  }
}
