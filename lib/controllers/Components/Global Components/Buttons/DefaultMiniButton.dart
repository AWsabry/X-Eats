import 'package:flutter/material.dart';

class DefaultMiniButton extends StatefulWidget {
  const DefaultMiniButton({
    Key? key,
    required this.function,
    required this.text,
  }) : super(key: key);

  final bool isUppercase = true;
  final double radius = 20;
  final VoidCallback function;
  final String text;

  @override
  State<DefaultMiniButton> createState() => _DefaultMiniButtonState();
}

class _DefaultMiniButtonState extends State<DefaultMiniButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.2,
      height: MediaQuery.of(context).size.height / 16,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor),
        onPressed: widget.function,
        child: Text(widget.isUppercase ? widget.text : widget.text,
            style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
