import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultFormField extends StatefulWidget {
  const DefaultFormField({
    Key? key,
    required this.validator,
    required this.type,
    required this.label,
    this.controller,
    this.prefix,
    this.suffixpressed,
    this.suffix,
    this.onTap,
    required this.isPassword,
  }) : super(key: key);

  final FormFieldValidator<String> validator;
  final TextInputType type;
  final String label;
  final TextEditingController? controller;
  final bool isPassword;
  final IconData? prefix;
  final VoidCallback? suffixpressed;
  final IconData? suffix;
  final VoidCallback? onTap;

  @override
  State<DefaultFormField> createState() => _DefaultFormFieldState();
}

class _DefaultFormFieldState extends State<DefaultFormField> {
  Color background = Colors.transparent;
  void Function(String)? onsubmit;
  void Function(String)? changed;
  BorderSide? bord;
  String email = 'email';
  TextStyle? Texcolor;
  double? height;
  double? width;

  TextStyle? labelst;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
          validator: widget.validator,
          controller: widget.controller,
          obscureText: widget.isPassword,
          onChanged: changed,
          onTap: widget.onTap,
          onFieldSubmitted: onsubmit,
          keyboardType: widget.type,
          style: GoogleFonts.poppins(
            height: 1.5,
          ),
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                borderSide: const BorderSide(color: Colors.grey)),
            fillColor: background,
            labelStyle: labelst,
            focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            labelText: widget.label,
            prefixIcon: Icon(
              widget.prefix,
              color: Colors.black,
            ),
            suffixIcon: widget.suffix != null
                ? IconButton(
                    onPressed: widget.suffixpressed,
                    icon: Icon(
                      widget.suffix,
                      color: Colors.black,
                    ),
                  )
                : null,
            border: const OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
          )),
    );
  }
}
