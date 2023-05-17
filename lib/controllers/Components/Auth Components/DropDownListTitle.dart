// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectedTitle extends StatefulWidget {
  SelectedTitle({Key? key, required this.form, required this.changed})
      : super(key: key);

  final FormFieldValidator<String> form;
  Color background = Colors.transparent;
  void Function(String)? onsubmit;
  final void Function(dynamic)? changed;
  VoidCallback? suffixpressed;
  VoidCallback? onTap;
  BorderSide? bord;
  IconData? prefix;
  TextStyle? Texcolor;
  IconData? suffix;
  TextStyle? labelst;

  @override
  State<SelectedTitle> createState() => _SelectedTitleState();
}

List<String> Listtitle = ['Freshman', 'Sophomore', 'Junior', 'Senior'];
String? title;

class _SelectedTitleState extends State<SelectedTitle> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: widget.form,
      alignment: AlignmentDirectional.bottomStart,
      value: title,
      icon: Image(
        width: 20,
        height: 20,
        fit: BoxFit.fill,
        image: AssetImage(
          'assets/Images/Khaled.png',
        ),
      ),
      onTap: widget.onTap,
      onChanged: widget.changed,
      style: GoogleFonts.poppins(height: 1.5),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: const BorderSide(color: Colors.grey)),
        fillColor: widget.background,
        labelStyle: widget.labelst,
        focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        suffixIcon: widget.suffix != null
            ? IconButton(
                onPressed: widget.suffixpressed,
                icon: Icon(
                  widget.suffix,
                  color: Colors.black,
                ),
              )
            : null,
        border: const OutlineInputBorder(borderSide: BorderSide()),
      ),
      hint: Text('title',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontFamily: 'UberMoveTextBold',
            fontSize: 20.0.sp,
            fontStyle: FontStyle.normal,
          ))),
      items: Listtitle.map((String titlee) {
        return DropdownMenuItem<String>(
          child: Row(children: [
            Text(
              titlee.toString(),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                fontFamily: 'UberMoveTextBold',
                fontSize: 20.0,
                fontStyle: FontStyle.normal,
                color: Colors.black,
              )),
            ),
          ]),
          value: titlee,
        );
      }).toList(),
    );
  }
}
