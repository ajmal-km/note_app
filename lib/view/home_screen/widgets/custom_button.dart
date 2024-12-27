import 'package:flutter/material.dart';

import '../../../utils/color_constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onpressed, required this.label});

  final VoidCallback? onpressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: 170,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorConstants.blue,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: ColorConstants.appBarFont,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
          ),
        ),
      ),
    );
  }
}
