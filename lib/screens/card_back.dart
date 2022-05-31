import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardBack extends ConsumerStatefulWidget {
  const CardBack({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardBackState();
}

class _CardBackState extends ConsumerState<CardBack> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.grey[400]),
      child: Center(
        child: Image.asset(
          "assets/images/netflix_logo.png",
        ),
      ),
    );
  }
}
