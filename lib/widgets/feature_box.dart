import 'package:allen_ai/colors.dart';
import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descText;
  const FeatureBox({
    super.key,
    required this.color,
    required this.headerText,
    required this.descText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,).copyWith(
          left: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start  ,
          children: [
            Text(
              headerText,
              style: const TextStyle(
                fontFamily: "Cera Pro",
                color: Pallete.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10,),
              child: Text(
                descText,
                style: const TextStyle(
                  fontFamily: "Cera Pro",
                  color: Pallete.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
