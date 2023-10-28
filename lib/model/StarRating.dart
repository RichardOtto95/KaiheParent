import 'package:flutter/material.dart';
import 'package:parent_side/model/globals.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;

  StarRating({this.starCount = 5, this.rating = .0, this.onRatingChanged});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_rate_rounded,
        size: 35,
        color: StarColor,
      );
    } else {
      icon = new Icon(Icons.star_rate_rounded, size: 35, color: Colors.white);
    }

    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
