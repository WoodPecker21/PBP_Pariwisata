import 'package:flutter/material.dart';

Padding inputForm(
  Function(String?) validasi,
  {
    required TextEditingController controller,
    required String hintTxt,
    required String helperTxt,
    required IconData iconData,
    bool password = false,
    Function()? onTap, 
  }
) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, top: 10),
    child: SizedBox( 
      width: 350,
      child: TextFormField(
        validator: (value) => validasi(value),
        autofocus: true,
        controller: controller,
        obscureText: password,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintTxt,
          border: const OutlineInputBorder(),
          helperText: helperTxt,
          prefixIcon: Icon(iconData),
        ),
      ),
    ),
  );
}