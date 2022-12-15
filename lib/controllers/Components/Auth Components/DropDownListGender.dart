import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDownListGender extends StatefulWidget {
  DropDownListGender(
      {Key? key,
      required this.form,
      required this.gender,
      required this.changed})
      : super(key: key);

  final List<String> Gender = ['Male', 'Female'];
  final void Function(void)? changed;
  final String? gender;
  final FormFieldValidator<String> form;
  Color background = Colors.transparent;
  void Function(String)? onsubmit;
  VoidCallback? suffixpressed;
  VoidCallback? onTap;
  BorderSide? bord;
  IconData? prefix;
  TextStyle? Texcolor;
  IconData? suffix;
  TextStyle? labelst;

  @override
  State<DropDownListGender> createState() => _DropDownListGenderState();
}

class _DropDownListGenderState extends State<DropDownListGender> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: widget.form,
      alignment: AlignmentDirectional.bottomStart,
      value: widget.gender,
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
        prefixIcon: Image(
          width: 1.w,
          height: 1.w,
          image: AssetImage(
            'assets/Images/gender.png',
          ),
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
        border: const OutlineInputBorder(borderSide: BorderSide()),
      ),
      hint: Text('Gender',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontFamily: 'UberMoveTextBold',
            fontSize: 20.0.sp,
            fontStyle: FontStyle.normal,
          ))),
      items: widget.Gender.map((String genderr) {
        return DropdownMenuItem<String>(
          child: Row(children: [
            genderr.toString() == 'Male'
                ? Icon(Icons.male)
                : Icon(Icons.female),
            Text(
              genderr.toString(),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                fontFamily: 'UberMoveTextBold',
                fontSize: 20.0,
                fontStyle: FontStyle.normal,
                color: Colors.black,
              )),
            ),
          ]),
          value: genderr,
        );
      }).toList(),
    );
  }
}
