
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class RatingBarWidget extends StatefulWidget {
  RatingBarWidget({Key? key, required this.rating, required this.name})
      : super(key: key);
  double rating;
  String name;

  @override
  State<RatingBarWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text('Rating: $rating '),
        RatingBar.builder(
            initialRating: widget.rating,
            itemSize: 20,
            minRating: 1,
            updateOnDrag: true,
            itemBuilder: (context, index) {
              return Icon(Icons.star, color: Colors.yellow);
            },
            onRatingUpdate: (rating) {
              setState(() {
                widget.rating = rating;
                FirebaseFirestore.instance
                    .collection('review')
                    .doc(widget.name)
                    .update({'individualrating': widget.rating});
              });
            }),
      ],
    );
  }
}