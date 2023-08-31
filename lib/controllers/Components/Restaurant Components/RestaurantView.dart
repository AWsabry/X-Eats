import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({
    Key? key,
    this.image,
    this.Colors,
    this.Navigate,
    this.data,
  }) : super(key: key);

  final double raduisPadding = 8.0;
  final double raduisButton = 10.0;
  final double Height = 100;
  final double Weight = 100;
  final Widget? image;
  final Color? Colors;
  final VoidCallback? Navigate;
  final String? data;

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.Height,
          width: widget.Weight,
          child: Padding(
            padding: EdgeInsets.all(widget.raduisPadding),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: widget.Colors,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.raduisButton)))),
                onPressed: widget.Navigate,
                child: widget.image),
          ),
        ),
        Text(
          "${widget.data}",
          // semanticsLabel: data,
          style: Theme.of(context).textTheme.displaySmall,
        )
      ],
    );
  }
}
