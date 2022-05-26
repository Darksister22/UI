import 'package:flutter/material.dart';

import '../stylefiles/style.dart';

class DivderText extends StatelessWidget {
  String title;
  DivderText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(
            indent: 20.0,
            endIndent: 10.0,
            thickness: 1,
          ),
        ),
        Text(
          title,
          style: divider,
        ),
        const Expanded(
          child: Divider(
            indent: 10.0,
            endIndent: 20.0,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
