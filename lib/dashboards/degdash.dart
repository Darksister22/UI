import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:schoolmanagement/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/components/buttoncards.dart';
import 'package:schoolmanagement/mains/deg_cur.dart';
import 'package:schoolmanagement/mains/semester.dart';

import 'package:schoolmanagement/module/extension.dart';
import 'package:http/http.dart' as http;
import 'package:schoolmanagement/translate.dart';
import '../mains/homepage.dart';
import '../mains/users.dart';

class DegDash extends StatefulWidget {
  const DegDash({Key? key}) : super(key: key);

  @override
  State<DegDash> createState() => _DegDashState();
}

class _DegDashState extends State<DegDash> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 28.0, left: 18.0, right: 18.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الفصول الدراسية",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ButtonCard(
                        bezierCOlor: Colors.lightBlue,
                        value: 'حساب درجات الكورس الحالي',
                        add: IconButton(
                          icon: const Icon(Icons.person_outline_outlined),
                          onPressed: () {},
                        ),
                        topColor: Colors.lightBlue,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ButtonCard(
                        bezierCOlor: Colors.greenAccent,
                        value: 'عرض درجات الكورس الحالي',
                        add: IconButton(
                          icon: const Icon(Icons.person_outline_outlined),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DegCur(),
                              ),
                            );
                          },
                        ),
                        topColor: Colors.greenAccent,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ButtonCard(
                        bezierCOlor: Colors.orangeAccent,
                        value: 'عرض درجات السنوات السابقة',
                        add: IconButton(
                          icon: const Icon(Icons.person_outline_outlined),
                          onPressed: () {},
                        ),
                        topColor: Colors.orangeAccent,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
