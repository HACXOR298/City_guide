import 'package:flutter/material.dart';

class CityImgCard extends StatelessWidget {
  final double Widthcard;
  final double ImgHeight;
  final double OpacityHeight;
  final double OpacityAboveRemainingHeightForMargin;
  final String cityImg;
  final Widget firstOpacityDivRow;
  final Widget secondOpacityDivRow;

  const CityImgCard({
    Key? key,
    required this.Widthcard,
    required this.ImgHeight,
    required this.OpacityHeight,
    required this.OpacityAboveRemainingHeightForMargin,
    required this.cityImg,
    required this.firstOpacityDivRow,
    required this.secondOpacityDivRow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Widthcard,
      height: ImgHeight,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(cityImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: Widthcard,
              height: OpacityHeight,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView( // Prevent overflow with scroll view
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Adjust to prevent overflow
                  children: [
                    firstOpacityDivRow,
                    secondOpacityDivRow,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
