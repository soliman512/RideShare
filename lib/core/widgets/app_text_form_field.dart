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
    this.mainColor,
    this.filledColor,
    this.isFilled,
    this.isReadOnly = false,
    this.isExpands = false,
    this.minLines,
    this.maxLines,
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
  final bool? isFilled;
  final double? fontSize;
  final String? counterText;
  final FontWeight? fontWeight;
  final Color? inputColor;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final String? outLabel;
  final Color? mainColor;
  final Color? filledColor;
  final bool isReadOnly;
  final bool isExpands;
  final int? minLines;
  final int? maxLines;
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
                    .copyWith(color: mainColor ?? AppConstColors.secondary),
              ),
            ),
          ),
        TextFormField(
          expands: isExpands,
          minLines: minLines,
          maxLines: maxLines,
          readOnly: isReadOnly,
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

            filled: isFilled ?? true,
            fillColor: filledColor ?? AppConstColors.input,

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
                color: mainColor ?? AppConstColors.secondary,
                width: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
