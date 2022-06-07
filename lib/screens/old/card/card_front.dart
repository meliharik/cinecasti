import 'package:flutter/material.dart';

class CardFront extends StatelessWidget {
  const CardFront({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.grey[400]),
      child: Center(
        child: Image.asset(
          "assets/images/netflix_logo.png",
        ),
      ),
    );
  }
}
