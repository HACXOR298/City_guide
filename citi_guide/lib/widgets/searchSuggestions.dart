import 'package:flutter/material.dart';

class SearchSuggestions extends StatelessWidget {
  final String place;
  final String city;
  const SearchSuggestions({super.key, required this.place, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          // bottom: BorderSide(width: 1.5, color: Constants.greyTextColor),
        ),
      ),
      child: Row(
        children: [
          Text(
            place,
            style: TextStyle(
              // color: Constants.greyTextColor,
              fontSize: 14,
            ),
          ),
          Text(
            ", $city",
            style: TextStyle(
              // color: Constants.greyTextColor,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_outward_sharp,
            // color: Constants.greyTextColor,
          )
        ],
      ),
    );
  }
}
