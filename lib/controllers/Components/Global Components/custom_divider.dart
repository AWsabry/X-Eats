import 'package:flutter/material.dart';

Widget customDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 5.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );
