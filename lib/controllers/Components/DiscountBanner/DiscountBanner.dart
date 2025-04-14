import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/core/Constants/constants.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dataFromApi = ProductsCubit.getposters;
    return CarouselSlider.builder(
      itemCount: dataFromApi.length,
      itemBuilder: (BuildContext context, int index, int pageViewIndex) {
        return Image(
          errorBuilder: (context, error, stackTrace) {
            return Text(error.toString());
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: Loading(),
            );
          },
          image: CachedNetworkImageProvider(
            AppConstants.BaseUrl + dataFromApi[index]['background_image'],
            maxWidth: MediaQuery.of(context).size.width.toInt(),
            errorListener: (error) => const Text('Error Loading Image'),
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 2.0,
        initialPage: 2,
        height: MediaQuery.of(context).size.height / 4,
      ),
    );
  }
}
