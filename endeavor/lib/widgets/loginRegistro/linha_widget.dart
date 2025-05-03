import 'package:flutter/material.dart';

class LinhaWidget extends StatelessWidget {

  String title;
  LinhaWidget(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: Colors.black,
          width: 144,
          height: 1,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Container(
          color: Colors.black,
          width: 144,
          height: 1,
        ),
      ],
    );
  }
}