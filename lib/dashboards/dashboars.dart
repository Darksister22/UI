import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolmanagement/components/infocard.dart';
import 'package:schoolmanagement/models/counts.dart';
import 'package:schoolmanagement/translate.dart';

import '../api.dart';

class OverviewCards extends StatefulWidget {
  const OverviewCards({Key? key}) : super(key: key);

  @override
  State<OverviewCards> createState() => _OverviewCardsState();
}

Future<Counts> fetchCounts() async {
  final response = await CallApi().getData('/api/homepage');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return Counts.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class _OverviewCardsState extends State<OverviewCards> {
  late Future<Counts> futureCounts;

  @override
  void initState() {
    super.initState();
    futureCounts = fetchCounts();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return FutureBuilder<Counts>(
        future: futureCounts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 28.0, left: 18.0, right: 18.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الصفحة الرئيسية",
                              style: GoogleFonts.poppins(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            InfoCard(
                              title: snapshot.data!.year,
                              value: translateNumEA(snapshot.data!.number),
                              bezierCOlor: Colors.green,
                              onTap: () {},
                              topColor: Colors.greenAccent,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                InfoCard(
                                  bezierCOlor: Colors.blue,
                                  title: 'عدد الطلبة الكلي',
                                  value: (snapshot.data!.stucount).toString(),
                                  onTap: () {},
                                  topColor: Colors.blue,
                                ),
                                SizedBox(
                                  width: _width / 64,
                                ),
                                InfoCard(
                                  title: 'عدد التدريسيين الكلي',
                                  value: (snapshot.data!.inscount).toString(),
                                  bezierCOlor: Colors.orange,
                                  onTap: () {},
                                  topColor: Colors.deepOrangeAccent,
                                ),
                                // St
                                SizedBox(
                                  width: _width / 64,
                                ),
                                InfoCard(
                                  title: 'عدد الكورسات الحالية',
                                  value: (snapshot.data!.crscount).toString(),
                                  bezierCOlor: Colors.cyanAccent,
                                  onTap: () {},
                                  topColor: Colors.cyanAccent,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        } //col ends here
        );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path =  Path();
    path.lineTo(
        0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
