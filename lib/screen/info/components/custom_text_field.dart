import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.icon,
    required this.controller,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        cursorHeight: 14,
        cursorColor: Colors.black54,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,

          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: 'Georgia',
          ),
          prefixIcon: Icon(icon, color: Colors.blue.shade100),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueGrey.shade200, width: 2),
          ),
          filled: true,

          fillColor: Colors.grey.shade50,
        ),
        validator: validator,
        style: const TextStyle(fontSize: 16, fontFamily: 'Georgia'),
      ),
    );
  }
}
