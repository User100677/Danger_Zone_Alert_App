import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import './google_map.dart';


class Radius{
   List<Circle> _circles = [];

    handleTap(LatLng tappedPoint) {
       _circles.add(
         Circle(
           circleId: CircleId(tappedPoint.toString()),
           center: tappedPoint,
           radius: 500,
           strokeWidth: 2,
           fillColor: Color.fromRGBO(102, 51, 153, .5),

         ),
       );

   }

   List<Circle> get getCircles {
     return _circles;
   }

   set setCircles(List<Circle> circles) {
     _circles = circles;
   }


 }






