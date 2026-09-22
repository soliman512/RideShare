import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider_share/constants/app_constants.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.showCursor,
    this.fontSize,
    this.textAlign,
    this.inputColor,
    this.fontWeight,
    this.validator,
    this.focusNode,
    this.inputAction,
    this.onChange,
    this.maxLength,
    this.counterText = '',
  });

  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final Function(String value)? onChange;
  final bool obscureText;
  final int? maxLength;
  final bool? showCursor;
  final double? fontSize;
  final String? counterText;
  final FontWeight? fontWeight;
  final Color? inputColor;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: inputAction,
      onChanged: onChange,
      obscureText: obscureText,
      maxLength: maxLength,
      cursorColor: AppConstColors.secondary,
      showCursor: showCursor,
      style: GoogleFonts.outfit(
        color: inputColor ?? AppConstColors.secondaryDark,
        fontWeight: fontWeight ?? .normal,
        fontSize: fontSize ?? 16,
      ),
      textAlign: textAlign ?? .start,
      validator: validator,
      decoration: InputDecoration(
        counterText: counterText,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: GoogleFonts.outfit(
          color: const Color.fromARGB(255, 143, 143, 143),
          fontWeight: .w300,
          fontSize: 14,
        ),
        labelStyle: Theme.of(context).textTheme.labelLarge!
            .copyWith(color: AppConstColors.secondaryDark),
        filled: true,
        fillColor: AppConstColors.grey,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey, width: .5),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey, width: .5),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppConstColors.secondaryDark,
            width: 1.6,
          ),
        ),
      ),
    );
  }
}
