import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:flutter/material.dart';

class DestinationCards extends StatelessWidget {
  final String imgPath;
  final String location;
  final String city;
  final String distance;
  const DestinationCards({super.key, required this.imgPath, required this.location, required this.city, required this.distance});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: CityImgCard(
        cityImg: imgPath,
        Widthcard: 170,
        ImgHeight: 170,
        OpacityHeight: 50,
        OpacityAboveRemainingHeightForMargin: 120,
        firstOpacityDivRow: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Text(
                location,
                style: TextStyle(
                  // color: Constants.greyColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        secondOpacityDivRow: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TransparentButton(
                  OpacitySet: 0.1,
                  topBottomPadding: 2,
                  leftRightPadding: 7,
                  widget_: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        // color: Constants.greyColor,
                        size: 10,
                      ),
                      Text(
                        city,
                        style: TextStyle(
                          fontSize: 10,
                          // color: Constants.greyColor,
                        ),
                      ),
                    ],
                  ),
                  OntapFunction: () {
                     //
                  },
                  topBottomMargin: 2,
                  leftRightMargin: 0),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TransparentButton(
                  OpacitySet: 0.1,
                  topBottomPadding: 2,
                  leftRightPadding: 7,
                  widget_: Row(
                    children: [
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 10,
                          // color: Constants.greyColor,
                        ),
                      ),
                    ],
                  ),
                  OntapFunction: () {
                    print("navigation button");
                  },
                  topBottomMargin: 2,
                  leftRightMargin: 0),
            ),
          ],
        ),
      ),
    );
  }
}
