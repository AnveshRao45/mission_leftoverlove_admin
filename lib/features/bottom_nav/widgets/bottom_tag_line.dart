import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomTagLine extends StatelessWidget {
  const BottomTagLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 8.h, top: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            textDirection: TextDirection.ltr,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Waste ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: '\nLess',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: ' and ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: '\nLove ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: 'More !',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/logo.png",
            scale: 24,
          ),
        ],
      ),
    );
  }
}
