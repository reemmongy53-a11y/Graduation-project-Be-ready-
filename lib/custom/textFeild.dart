import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';

typedef validator = String? Function(String? text);

class AppFormField extends StatefulWidget {
  const AppFormField({
    this.label,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.hintText,
    this.suffixIcon,
    this.controller,
    this.validator,

    this.readOnly = false,
    this.initialValue,
    super.key,

  });

  final String? label;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? suffixIcon;
  final String? hintText;
  final TextEditingController? controller;
  final validator;

  final bool readOnly;
  final String? initialValue;

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  bool isTextVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;

        return TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword && !isTextVisible,
          style: TextStyle(
            color: isDark ? AppColor.white : AppColor.black,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.label,
            hintStyle: GoogleFonts.inter(
              color: isDark
                  ? AppColor.white.withOpacity(0.4)
                  : AppColor.black.withOpacity(0.4),
              fontSize: 16,
            ),
            labelStyle: GoogleFonts.inter(
              color: isDark
                  ? AppColor.white.withOpacity(0.7)
                  : AppColor.black.withOpacity(0.5),
              fontSize: 16,
            ),
            prefixIcon: widget.icon != null
                ? Icon(
              widget.icon,
              color: isDark ? AppColor.white : AppColor.gray,
            )
                : null,
            suffixIcon: widget.isPassword
                ? InkWell(
              onTap: () {
                setState(() {
                  isTextVisible = !isTextVisible;
                });
              },
              child: Icon(
                isTextVisible ? Icons.visibility : Icons.visibility_off,
                color: isDark ? AppColor.white : AppColor.gray,
              ),
            )
                : null,
            filled: true,
            fillColor: isDark ? AppColor.navy : AppColor.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: isDark ? AppColor.royalBlue : AppColor.softGray,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColor.royalBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColor.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColor.red,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
          validator: widget.validator,
        );
      },
    );
  }
}