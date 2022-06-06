import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'infocard.dart';
import 'package:schoolmanagement/stylefiles/style.dart';

class ButtonCard extends StatelessWidget {
  final IconButton? add;
  final String? value;
  final Color? topColor;
  final bool isActive;
  final Function? onTap;
  final Color? bezierCOlor;
  const ButtonCard(
      {Key? key,
      this.add,
      this.value,
      this.topColor,
      this.isActive = false,
      this.onTap,
      this.bezierCOlor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 136,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 6),
                color: lightgrey.withOpacity(.1),
                blurRadius: 12)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: topColor ?? blue,
                          height: 10,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: add,
                  ),
                  RichText(
                      textDirection: TextDirection.ltr,
                      strutStyle: const StrutStyle(fontSize: 18, height: 1.5),
                      textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: true,
                          applyHeightToLastDescent: true),
                      textScaleFactor: 1,
                      textWidthBasis: TextWidthBasis.longestLine,
                      locale: const Locale('ar'),
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "$value\n",
                            style: GoogleFonts.lato(
                                fontSize: 25,
                                color: isActive ? blue : dark,
                                fontWeight: FontWeight.bold))
                      ])),
                ],
              ),
              Positioned(
                child: Opacity(
                  //semi red clippath with more height and with 0.5 opacity
                  opacity: 0.1,
                  child: ClipPath(
                    clipper: WaveClipper(), //set our custom wave clipper
                    child: Container(
                      color: bezierCOlor,
                      height: 80,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
