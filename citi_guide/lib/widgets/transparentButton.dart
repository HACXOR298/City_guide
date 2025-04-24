import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final double topBottomPadding;
  final double leftRightPadding;
  final Widget widget_;
  final Function OntapFunction;
  final double topBottomMargin;
  final double leftRightMargin;
  final double OpacitySet;
  const TransparentButton({
    super.key,
    required this.topBottomPadding,
    required this.leftRightPadding,
    required this.widget_,
    required this.OntapFunction,
    required this.topBottomMargin,
    required this.leftRightMargin, required this.OpacitySet,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        OntapFunction();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: topBottomMargin, horizontal: leftRightMargin),
        decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(OpacitySet),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.transparent,
            )),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: topBottomPadding,
                horizontal: leftRightPadding), // Adjust the padding as needed
            child: widget_,
          ),
        ),
      ),
    );
  }
}
