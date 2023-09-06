import 'package:flutter/material.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({
    Key? key,
    this.image,
    this.data,
  }) : super(key: key);
  final Widget? image;
  final Map? data;

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(width / 60),
                child: Container(
                  height: height / 8,
                  width: width / 4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: width / 120),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: width / 5,
                    child: widget.image,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.data!["Name"]}",
                // semanticsLabel: data,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              if ("${widget.data!["address"]}" != "null")
                Text(
                  "${widget.data!["address"]}",
                  // semanticsLabel: data,
                  style: Theme.of(context).textTheme.titleSmall,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,

                  maxLines: 1,
                ),
              Text(
                "Delivery Fees: EGP ${widget.data!["delivery_fees"]}",
                // semanticsLabel: data,
                style: Theme.of(context).textTheme.displaySmall,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        )

        // Container(
        //   height: height / 6,
        //   width: width / 3,
        //   child: Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: ClipRRect(
        //       child: Container(
        //         alignment: Alignment.center,
        //         child: widget.image,
        //       ),
        //       borderRadius: BorderRadius.circular(width / 80),
        //     ),
        //     // child: ElevatedButton(
        //     //     style: ElevatedButton.styleFrom(
        //     //       backgroundColor: widget.Colors,
        //     //       shape: RoundedRectangleBorder(
        //     //         borderRadius: BorderRadius.all(
        //     //           Radius.circular(widget.raduisButton),
        //     //         ),
        //     //       ),
        //     //     ),
        //     //     onPressed: widget.Navigate,
        //     //     child: widget.image),
        //   ),
        // ),
        // Text(
        //   "${widget.data}",
        //   // semanticsLabel: data,
        //   style: Theme.of(context).textTheme.displaySmall,
        // )
      ],
    );
  }
}
