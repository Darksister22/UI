import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolmanagement/components/buttoncards.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/deg_cur.dart';
import 'package:schoolmanagement/mains/deg_year.dart';
import 'package:schoolmanagement/models/semseter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../mains/deg_all.dart';

class DegDash extends StatefulWidget {
  const DegDash({Key? key}) : super(key: key);

  @override
  State<DegDash> createState() => _DegDashState();
}

class _DegDashState extends State<DegDash> {
  bool isLoading = true;
  String? sellevel;

  String? selYear;

  List<Semester> _data = [];

  Future _caclDeg() async {
    var data = {};

    try {
      final response = await CallApi().postData(data, '/api/degrees/cacl');
      if (response.statusCode == 200) {
        isLoading = false;
      }
    } catch (e) {
      context.showSnackBar('حدث خطأ ما, يرجى اعادة المحاولة', isError: true);
    }
  }

  final _formKey = GlobalKey<FormState>();

  Future<List<Semester>> fetchAlbum() async {
    final response = await CallApi().getData('/api/semesters/get');
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as List;

      return result.map((e) => Semester.fromJson(e)).toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    "درجات الطلبة",
                    style: GoogleFonts.ibmPlexSansArabic(
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
                        bezierCOlor: Colors.greenAccent,
                        value: 'عرض درجات الكورس الحالي',
                        add: IconButton(
                          icon: const Icon(Icons.person_outline_outlined),
                          onPressed: () async {
                            SharedPreferences localStorage =
                                await SharedPreferences.getInstance();

                            if (localStorage.getString("token") != null) {
                              await _caclDeg();
                            }

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
                        bezierCOlor: Colors.blueAccent,
                        value: 'عرض درجات السنة الحالية ',
                        add: IconButton(
                          icon: const Icon(Icons.person_outline_outlined),
                          onPressed: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DegYear(),
                              ),
                            );
                          },
                        ),
                        topColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ButtonCard(
                        bezierCOlor: Colors.orangeAccent,
                        value: 'عرض درجات السنوات السابقة',
                        add: IconButton(
                          icon: const Icon(Icons.person_outline_outlined),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title:
                                    const Text("الرجاء اختيار السنة الدراسية"),
                                content: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      child: ButtonTheme(
                                        child: FutureBuilder<List<Semester>>(
                                          future: fetchAlbum(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              _data = snapshot.data ?? [];
                                              List<String> list = [];
                                              for (var i = 0;
                                                  i < _data.length;
                                                  i++) {
                                                list.add(_data[i].year);
                                              }
                                              return StatefulBuilder(
                                                builder: (BuildContext context,
                                                    setState) {
                                                  return DropdownButtonFormField<
                                                      String>(
                                                    isExpanded: true,
                                                    validator: (value) {
                                                      if (value == null) {
                                                        context.showSnackBar(
                                                            "الرجاء اختيار سنة دراسية",
                                                            isError: true);
                                                        Navigator.pop(context);
                                                        return "الرجاء اختيار سنة دراسية";
                                                      }
                                                      return null;
                                                    },
                                                    hint: const Text(
                                                        'السنة الدراسية'),
                                                    value: selYear,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selYear =
                                                            newValue.toString();
                                                      });
                                                    },
                                                    items: list.map((ins) {
                                                      return DropdownMenuItem(
                                                        child: Text(ins),
                                                        value: ins,
                                                      );
                                                    }).toList(),
                                                  );
                                                },
                                              );
                                            }
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: const [
                                                CircularProgressIndicator(),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DegAll(
                                                semes: selYear!,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('الذهاب'))
                                ],
                              ),
                            );
                          },
                        ),
                        topColor: Colors.orangeAccent,
                      ),
                    ],
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
