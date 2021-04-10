import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:shimmer/shimmer.dart';

Container showRestaurantShimmer(BuildContext context) => Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[200],
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100.0,
                color: Colors.white,
              ),
            ),
            verticalSizedBoxTwenty(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    width: 100,
                    height: 20.0,
                    color: Colors.white,
                  ),
                ),
                horizontalSizedBox(),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    width: 100,
                    height: 20.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            verticalSizedBoxTwenty(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    width: 100,
                    height: 40.0,
                    color: Colors.white,
                  ),
                ),
                horizontalSizedBox(),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    width: 100,
                    height: 40.0,
                    color: Colors.white,
                  ),
                ),
                horizontalSizedBox(),
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    width: 100,
                    height: 40.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

//            Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Shimmer.fromColors(
//                  baseColor: Colors.grey[100],
//                  highlightColor: Colors.grey[200],
//                  child: Container(
//                    width: MediaQuery.of(context).size.width / 2,
//                    height: 10.0,
//                    color: Colors.white,
//                  ),
//                ),
//                verticalSizedBox(),
//                Shimmer.fromColors(
//                  baseColor: Colors.grey[100],
//                  highlightColor: Colors.grey[200],
//                  child: Container(
//                    width: MediaQuery.of(context).size.width / 5,
//                    height: 10.0,
//                    color: Colors.green,
//                  ),
//                ),
//                verticalSizedBox(),
//                Shimmer.fromColors(
//                  baseColor: Colors.grey[100],
//                  highlightColor: Colors.grey[200],
//                  child: Container(
//                    width: MediaQuery.of(context).size.width / 3,
//                    height: 10.0,
//                    color: Colors.green,
//                  ),
//                ),
//              ],
//            ),
//            ),
            ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 63.5,
                      child: Row(
                        children: <Widget>[
                          Shimmer.fromColors(
                            baseColor: Colors.grey[100],
                            highlightColor: Colors.grey[200],
                            child: Container(
                              width: 80,
                              height: 80.0,
                              color: Colors.white,
                            ),
                          ),
                          horizontalSizedBoxTwenty(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Shimmer.fromColors(
                                baseColor: Colors.grey[100],
                                highlightColor: Colors.grey[200],
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 10.0,
                                  color: Colors.white,
                                ),
                              ),
                              verticalSizedBox(),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[100],
                                highlightColor: Colors.grey[200],
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: 10.0,
                                  color: Colors.green,
                                ),
                              ),
                              verticalSizedBox(),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[100],
                                highlightColor: Colors.grey[200],
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 10.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })

            //        Container(

            //          alignment: Alignment.centerLeft,

            //          margin: const EdgeInsets.symmetric(

            //            vertical: 10.0,

            //            horizontal: 15.0,

            //          ),

            //          height: 63.5,

            //          child: Row(

            //            children: <Widget>[

            //              Shimmer.fromColors(

            //                baseColor: Colors.grey[100],

            //                highlightColor: Colors.grey[200],

            //                child: Container(

            //                  width: 80,

            //                  height: 80.0,

            //                  color: Colors.white,

            //                ),

            //              ),

            //              horizontalSizedBoxTwenty(),

            //              Column(

            //                mainAxisAlignment: MainAxisAlignment.center,

            //                crossAxisAlignment: CrossAxisAlignment.start,

            //                children: <Widget>[

            //                  Shimmer.fromColors(

            //                    baseColor: Colors.grey[100],

            //                    highlightColor: Colors.grey[200],

            //                    child: Container(

            //                      width: MediaQuery.of(context).size.width / 2,

            //                      height: 10.0,

            //                      color: Colors.white,

            //                    ),

            //                  ),

            //                  verticalSizedBox(),

            //                  Shimmer.fromColors(

            //                    baseColor: Colors.grey[100],

            //                    highlightColor: Colors.grey[200],

            //                    child: Container(

            //                      width: MediaQuery.of(context).size.width / 5,

            //                      height: 10.0,

            //                      color: Colors.green,

            //                    ),

            //                  ),

            //                  verticalSizedBox(),

            //                  Shimmer.fromColors(

            //                    baseColor: Colors.grey[100],

            //                    highlightColor: Colors.grey[200],

            //                    child: Container(

            //                      width: MediaQuery.of(context).size.width / 3,

            //                      height: 10.0,

            //                      color: Colors.green,

            //                    ),

            //                  ),

            //                ],

            //              ),

            //            ],

            //          ),

            //        ),
          ],
        ),
      ),
    );
