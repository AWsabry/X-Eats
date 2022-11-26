// ignore_for_file: non_constant_identifier_names, unnecessary_const, sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

Widget defultformfield(
        {required final FormFieldValidator<String> validator,
        TextEditingController? controller,
        Color background = Colors.transparent,
        required TextInputType type,
        void Function(String)? onsubmit,
        void Function(String)? changed,
        VoidCallback? suffixpressed,
        VoidCallback? onTap,
        required String label,
        BorderSide? bord,
        bool isPassword = false,
        IconData? prefix,
        String email = 'email',
        TextStyle? Texcolor,
        IconData? suffix,
        double? height,
        double? width,
        TextStyle? labelst}) =>
    Container(
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: isPassword,
        onChanged: changed,
        onTap: onTap,
        onFieldSubmitted: onsubmit,
        keyboardType: type,
        style: GoogleFonts.kanit(
          height: 1.5,
        ),
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(maxWidth: 100, minWidth: 40),
          enabledBorder: const OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: const BorderSide(color: Colors.grey)),
          fillColor: background,
          labelStyle: labelst,
          focusedBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          labelText: label,
          prefixIcon: Icon(
            prefix,
            color: Colors.black,
          ),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixpressed,
                  icon: Icon(
                    suffix,
                    color: Colors.black,
                  ),
                )
              : null,
          border: const OutlineInputBorder(borderSide: BorderSide()),
        ),
      ),
    );
Widget defultbutton({
  double width = 320,
  bool isUppercase = true,
  double radius = 20,
  required VoidCallback function,
  required String text,
  context,
  token,
}) =>
    Container(
      width: width,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius))),
        onPressed: function,
        child: Text(isUppercase ? text : text,
            style: GoogleFonts.kanit(
              textStyle: const TextStyle(
                fontFamily: 'UberMoveTextBold',
                fontSize: 25.0,
                fontStyle: FontStyle.normal,
                color: Colors.black,
              ),
            )),
      ),
    );

Widget NextButton({
  double width = 320,
  bool isUppercase = true,
  double radius = 20,
  required VoidCallback function,
  required String text,
  context,
  token,
}) =>
    Container(
      width: width,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius))),
        onPressed: function,
        child: Row(children: [
          SizedBox(
            width: 117,
          ),
          Text(isUppercase ? text : text,
              style: GoogleFonts.kanit(
                textStyle: const TextStyle(
                  fontFamily: 'UberMoveTextBold',
                  fontSize: 25.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                ),
              )),
        ]),
      ),
    );
void Navigation(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (Route) => false);
List<String> Gender = ['Male', 'Female'];
String? gender;

Widget SelectedGender({
  required final FormFieldValidator<String> form,
  Color background = Colors.transparent,
  void Function(String)? onsubmit,
  void Function(dynamic)? changed,
  VoidCallback? suffixpressed,
  VoidCallback? onTap,
  BorderSide? bord,
  IconData? prefix,
  TextStyle? Texcolor,
  IconData? suffix,
  TextStyle? labelst,
}) =>
    DropdownButtonFormField<String>(
      validator: form,
      alignment: AlignmentDirectional.bottomStart,
      value: gender,
      icon: Image(
        width: 20,
        height: 20,
        fit: BoxFit.fill,
        image: AssetImage(
          'assets/Images/Khaled.png',
        ),
      ),
      onTap: onTap,
      onChanged: changed,
      style: GoogleFonts.kanit(height: 1.5),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: const BorderSide(color: Colors.grey)),
        fillColor: background,
        labelStyle: labelst,
        focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        prefixIcon: Image(
          width: 1,
          height: 1,
          image: AssetImage(
            'assets/Images/gender.png',
          ),
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixpressed,
                icon: Icon(
                  suffix,
                  color: Colors.black,
                ),
              )
            : null,
        border: const OutlineInputBorder(borderSide: BorderSide()),
      ),
      hint: Text('Gender',
          style: GoogleFonts.kanit(
              textStyle: const TextStyle(
            fontFamily: 'UberMoveTextBold',
            fontSize: 20.0,
            fontStyle: FontStyle.normal,
          ))),
      items: Gender.map((String genderr) {
        return DropdownMenuItem<String>(
          child: Row(children: [
            genderr.toString() == 'Male'
                ? Icon(Icons.male)
                : Icon(Icons.female),
            Text(
              genderr.toString(),
              style: GoogleFonts.kanit(
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
Widget OtpField(
        {required final FormFieldValidator<String> validator,
        TextEditingController? controller,
        TextInputAction? Action,
        Color background = Colors.blue,
        required TextInputType type,
        VoidCallback? onTap,
        BorderSide? bord,
        TextStyle? labelst}) =>
    Container(
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        textInputAction: Action,
        validator: validator,
        controller: controller,
        textAlign: TextAlign.center,
        onTap: onTap,
        keyboardType: type,
        style: GoogleFonts.kanit(
            height: 1.5,
            color: Colors.black,
            textStyle: TextStyle(fontSize: 25)),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue,
          prefixIconConstraints: BoxConstraints(maxWidth: 40, minWidth: 30),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Colors.black, width: 4)),
          labelStyle: labelst,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 4),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          border: OutlineInputBorder(borderSide: BorderSide(color: background)),
        ),
      ),
    );
Widget CircularNotchBottom(
        {required List<BottomNavigationBarItem> Items,
        CircularNotchedRectangle? Circle,
        required int currentindex,
        int? notchMargin,
        Color? color,
        Function(int)? ontap}) =>
    BottomNavigationBar(currentIndex: currentindex, onTap: ontap, items: Items);
Widget Resturants({
  double raduisPadding = 8.0,
  double raduisButton = 10.0,
  double Height = 100,
  double Weight = 100,
  Image? image,
  Color? Colors,
  VoidCallback? Navigate,
  String? data,
}) =>
    Column(
      children: [
        Container(
          height: Height,
          width: Weight,
          child: Padding(
            padding: EdgeInsets.all(raduisPadding),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(raduisButton)))),
                onPressed: Navigate,
                child: image),
          ),
        ),
        Text(
          "$data",
          // semanticsLabel: data,
          style: GoogleFonts.kanit(),
        )
      ],
    );
Widget Dividerr() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 5.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );
Widget Product(list, context, {widget, String? Data, String? Assets}) =>
    InkWell(
      onTap: () {
        Navigation(context, widget);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage('$Assets'),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "$Data",
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '$Data',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
Widget ProudctMenu(list, context, {isSearch = false}) => ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => Product(list[index], context),
        separatorBuilder: (context, index) => Dividerr(),
        itemCount: list.length,
      ),
      fallback: (context) => isSearch
          ? Container()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
