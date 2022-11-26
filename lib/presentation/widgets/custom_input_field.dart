import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../helper/app_colors.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key? key,
    this.controller,
    this.hint,
    this.validator,
    this.showSuffix = false,
    this.isNumber = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.onSuffixTap,
    this.focusNode, this.onSaved,
  }) : super(key: key);
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final bool showSuffix;
  final bool isNumber;
  final bool autoFocus;
  final bool readOnly;
  final Function? validator;
  final Function? onSaved;
  final Function()? onSuffixTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
          readOnly: readOnly,
          cursorColor: mainColor,
          focusNode: focusNode,
          autofocus: autoFocus,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          controller: controller,
          style: const TextStyle(fontSize: 16),
          textInputAction: TextInputAction.next,
          onSaved: (value)=>onSaved!(value),
          validator: (value)=>validator!(value),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              hintText: hint,
              label: Text(
                hint!,
                style: const TextStyle(color: mainColor),
              ),
              suffixIcon: showSuffix
                  ? IconButton(
                      splashColor: mainColor,
                      onPressed: () => onSuffixTap!(),
                      icon: const Icon(
                        Ionicons.add_circle_outline,
                        color: blue,
                      ),
                    )
                  : null)),
    );
  }
}
