import 'package:flutter/material.dart';
import 'package:teatcher_app/core/style/app_color.dart';

class TextFormFiledComponent extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validate;

  const TextFormFiledComponent({
    super.key,
    this.controller,
    this.keyboardType,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    required this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validate,
      cursorColor: Theme.of(context).primaryColor,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle:
            TextStyle(color: Colors.grey[400], fontSize: 16.0, height: 1.0),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: 20.0,
                color: AppColor.primerColor.withOpacity(0.7),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColor.primerColor.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
