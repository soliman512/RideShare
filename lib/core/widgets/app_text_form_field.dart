import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_share/core/constants/app_const_colors.dart';

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
    this.outLabel,
    this.inputFormatters,
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
  final String? outLabel;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        if (outLabel != null)
          Align(
            alignment: .topStart,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                outLabel!,
                style: TextTheme.of(context).labelSmall!
                    .copyWith(color: AppConstColors.secondary),
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: inputAction,
          onChanged: onChange,
          obscureText: obscureText,
          maxLength: maxLength,
          cursorColor: AppConstColors.subSecondary,
          showCursor: showCursor,
          style: GoogleFonts.outfit(
            color: inputColor ?? AppConstColors.secondary,
            fontWeight: fontWeight ?? .normal,
            fontSize: fontSize ?? 18,
          ),
          textAlign: textAlign ?? .start,
          validator: validator,
          decoration: InputDecoration(
            counterText: counterText,
            hintText: hintText,
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintStyle: TextTheme.of(context).labelLarge!
                .copyWith(color: AppConstColors.secondaryText, fontSize: 14),
            labelStyle: Theme.of(context).textTheme.labelMedium!
                .copyWith(color: AppConstColors.secondaryText, fontSize: 14),

            filled: true,
            fillColor: Color(0xFFe8ecf5),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppConstColors.border, width: .6),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppConstColors.border, width: .6),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: AppConstColors.secondary,
                width: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
