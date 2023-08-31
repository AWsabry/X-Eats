import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.image,
    required this.press,
    required this.category,
    required this.description,
  }) : super(key: key);

  final String image;
  final String description;
  final String category;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: width / 3,
        height: height / 6,
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: width / 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        width: width / 4,
                        height: height / 6,
                        fit: BoxFit.contain,
                        image: CachedNetworkImageProvider(
                          image,
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: Loading(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.15),
                      const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.15),

                      // Color(0x0489cc).withOpacity(0.4),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: width / 15),
                    child: Text.rich(
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: category,
                          ),
                          TextSpan(
                            text: description,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
