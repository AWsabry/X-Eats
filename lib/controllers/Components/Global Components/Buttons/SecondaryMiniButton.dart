import 'package:flutter/material.dart';

class SecondaryMiniButton extends StatefulWidget {
  const SecondaryMiniButton({
    Key? key,
    required this.function,
    required this.text,
  }) : super(key: key);

  final bool isUppercase = true;
  final double radius = 20;
  final VoidCallback function;
  final String text;

  @override
  State<SecondaryMiniButton> createState() => _SecondaryMiniButtonState();
}

class _SecondaryMiniButtonState extends State<SecondaryMiniButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.2,
      height: MediaQuery.of(context).size.height / 16,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        onPressed: widget.function,
        child: Text(widget.isUppercase ? widget.text : widget.text,
            style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}
