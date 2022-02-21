import 'package:flutter/material.dart';

Color returnComplimentaryColor(Color backgroundColor, Color foregroundColor) {
  print("theyre the same homie1");
  final grayscaleBackground = (0.299 * backgroundColor.red) + (0.587 * backgroundColor.green) + (0.114 * backgroundColor.blue);
  final grayscaleForeground = (0.299 * foregroundColor.red) + (0.587 * foregroundColor.green) + (0.114 * foregroundColor.blue);
  if(grayscaleBackground > 128) {
    if(grayscaleForeground > 128) {
      return Colors.white;
    }else {
      return Colors.black;
    }
  }else{
    if(grayscaleForeground > 128) {
      return foregroundColor;
    }
    return Colors.white;
  }
}
