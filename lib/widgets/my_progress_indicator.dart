import 'package:dongstagram/constant/screen_size.dart';
import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {

  final double containerSize;
  final double progressSize;

  const MyProgressIndicator({Key? key, required this.containerSize,this.progressSize=60}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        width: containerSize,
        height: containerSize,
        child: Center(child: SizedBox(
            height: progressSize,
            width: progressSize,
            child: Image.asset('assets/images/loading_img.gif'))));
  }
}
