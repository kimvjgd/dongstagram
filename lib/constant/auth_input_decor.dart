
import 'package:flutter/material.dart';

import 'common_size.dart';

InputDecoration textInputDecor(String hint) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    hintText: hint,
    enabledBorder: activeInputBorder(),
    focusedBorder: activeInputBorder(),
    errorBorder: errorInputBorder(),
    focusedErrorBorder: errorInputBorder(),
  );
}

OutlineInputBorder errorInputBorder() {
  return OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
      borderRadius: BorderRadius.circular(common_s_gap));
}

OutlineInputBorder activeInputBorder() {
  return OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(common_s_gap));
}