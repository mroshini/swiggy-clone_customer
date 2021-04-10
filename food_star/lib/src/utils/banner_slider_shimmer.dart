import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

SizedBox bannerShimmer() => SizedBox(
      width: 150.0,
      height: 150.0,
      child: Shimmer.fromColors(
        child: Card(
          color: Colors.grey[400],
        ),
        baseColor: Colors.grey[100],
        highlightColor: Colors.white,
        direction: ShimmerDirection.ltr,
      ),
    );

ClipRRect mapShimmer(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: Shimmer.fromColors(
          child: Card(
            color: Colors.grey[400],
          ),
          baseColor: Colors.grey[100],
          highlightColor: Colors.white,
          direction: ShimmerDirection.ltr,
        ),
      ),
    );

ClipRRect imageShimmer() => ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        height: 80.0,
        width: 80.0,
        child: Shimmer.fromColors(
          child: Card(
            color: Colors.grey[400],
          ),
          baseColor: Colors.grey[100],
          highlightColor: Colors.white,
          direction: ShimmerDirection.ltr,
        ),
      ),
    );

ClipRRect largeImageShimmer(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Shimmer.fromColors(
          child: Card(
            color: Colors.grey[400],
          ),
          baseColor: Colors.grey[100],
          highlightColor: Colors.white,
          direction: ShimmerDirection.ltr,
        ),
      ),
    );

Image loaderBeforeImage({double height, double width}) => Image.asset(
      'assets/images/rest_image.png',
      height: 70.0,
      width: 70.0,
      // fit: BoxFit.fill,
    );

Image loaderBeforeResturantDetailBannerImage({double height, double width}) =>
    Image.asset(
      'assets/images/banner.png',
      fit: BoxFit.fill,
    );

networkImage({String image, Widget loaderImage, double height, double width}) =>
    CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, url) => loaderImage,
      //largeImageShimmer(context),
      errorWidget: (context, url, error) => loaderBeforeImage(),
      height: height,
      width: width,
      fit: BoxFit.fill,
    );

networkClosedRestImage(
        {String image, Widget loaderImage, double height, double width}) =>
    ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.grey[500], BlendMode.hue),
      child: CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => loaderImage,
//largeImageShimmer(context),
        errorWidget: (context, url, error) => loaderImage,
        height: height,
        width: width,
        fit: BoxFit.fill,
      ),
    );
