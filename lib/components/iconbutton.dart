import 'package:flutter/material.dart';

class IconColumn extends StatelessWidget {
  final String title;
  final Icon icon;
  const IconColumn({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: icon),
        Text(
          title,
          style: const TextStyle(fontSize: 15),
        )
      ],
    );
  }
}
