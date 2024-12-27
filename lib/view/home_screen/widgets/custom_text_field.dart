import 'package:flutter/material.dart';
import '../../../utils/color_constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hint,
      this.readOnly = false,
      this.sufixIcon,
      this.onSuffixTap,
      this.maxlines = 1});

  final TextEditingController controller;
  final String hint;
  final int maxlines;
  final bool readOnly;
  final IconData? sufixIcon;
  final VoidCallback? onSuffixTap;

  @override
  Widget build(BuildContext context) {
    final _controller = controller;
    return TextField(
      readOnly: readOnly,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: TextStyle(
        color: ColorConstants.blue,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
      maxLines: maxlines,
      controller: _controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(width: 2, color: ColorConstants.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(width: 2, color: ColorConstants.blue),
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: ColorConstants.blue,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
        suffixIcon: sufixIcon == null
            ? null
            : IconButton(
                onPressed: onSuffixTap,
                icon: Icon(sufixIcon),
                color: ColorConstants.blue,
              ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(23),
        ),
      ),
    );
  }
}
