import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/stu_sem.dart';
import 'package:schoolmanagement/models/degreesinlge.dart';
import 'package:schoolmanagement/models/student.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../models/course.dart';

class DegEdit extends StatefulWidget {
  final Student student;
  final Course id;
  const DegEdit({Key? key, required this.id, required this.student})
      : super(key: key);

  @override
  State<DegEdit> createState() => _DegEditState();
}

class _DegEditState extends State<DegEdit> {
  Future<DegreeSingle> fetchAlbum() async {
    var data = {
      "course_id": widget.id.id,
      'student_id': widget.student.id,
    };
    DegreeSingle deg = const DegreeSingle(
      id: null,
      student: null,
      course: null,
      fourty: null,
      sixty1: null,
      sixty2: null,
      sixty3: null,
      final1: null,
      final2: null,
      final3: null,
      approx: null,
      sts: null,
    );
    final response = await CallApi().postData(data, "/api/degrees/student");
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return DegreeSingle.fromJson(jsonDecode(response.body));
      }
      return deg;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  late Future<DegreeSingle> futureAlbum;

  var snack = '';
  bool isEnabled = false;
  var error = false;

  Future _editStu() async {
    var data = {
      "course_id": widget.id.id,
      'student_id': widget.student.id,
      'fourty': fourty.text,
      "sixty1": sixty1.text,
      "sixty2": sixty2.text,
      "sixty3": sixty3.text,
    };

    try {
      final response = await CallApi().postData(data, "/api/degrees/create");
      if (response.statusCode == 200) {
        snack = 'تم تحديث معلومات الطالب بنجاح';
      }
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final fourty = TextEditingController();
  final sixty1 = TextEditingController();
  final sixty2 = TextEditingController();
  final sixty3 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: 200,
        child: AlertDialog(
          title: const Text('درجات الطالب'),
          content: FutureBuilder<DegreeSingle>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.fourty != null) {
                  fourty.text = snapshot.data!.fourty.toString();
                }
                if (snapshot.data!.sixty1 != null) {
                  sixty1.text = snapshot.data!.sixty1.toString();
                }
                if (snapshot.data!.sixty2 != null) {
                  sixty2.text = snapshot.data!.sixty1.toString();
                }

                if (snapshot.data!.sixty3 != null) {
                  sixty3.text = snapshot.data!.sixty1.toString();
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: fourty,
                              enabled: isEnabled,
                              validator: (value) {
                                if ((value!.isNotEmpty)) {
                                  if (double.parse(value) > 40) {
                                    return 'لا يمكن ادخال درجة اكبر من 40';
                                  }
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: 'درجة السعي',
                                prefixIcon: const Icon(Icons.numbers),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ).margin9,
                            TextFormField(
                              controller: sixty1,
                              enabled: isEnabled,
                              validator: (value) {
                                if ((value!.isNotEmpty)) {
                                  if (double.parse(value) > 60) {
                                    return 'لا يمكن ادخال درجة اكبر من 60';
                                  }
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: 'درجة الامتحان النهائي الاول',
                                prefixIcon: const Icon(Icons.numbers),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ).margin9,
                            TextFormField(
                              controller: sixty2,
                              enabled: isEnabled,
                              validator: (value) {
                                if ((value!.isNotEmpty)) {
                                  if (double.parse(value) > 60) {
                                    return 'لا يمكن ادخال درجة اكبر من 60';
                                  }
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: 'درجة الامتحان النهائي الثاني',
                                prefixIcon: const Icon(Icons.numbers),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ).margin9,
                            TextFormField(
                              controller: sixty3,
                              enabled: isEnabled,
                              validator: (value) {
                                if ((value!.isNotEmpty)) {
                                  if (double.parse(value) > 60) {
                                    return 'لا يمكن ادخال درجة اكبر من 60';
                                  }
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: 'درجة الامتحان النهائي الثالث',
                                prefixIcon: const Icon(Icons.numbers),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ).margin9,
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('الخروج')),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences localStorage =
                      await SharedPreferences.getInstance();

                  if (localStorage.getString("token") == null) {
                    context.showSnackBar('لا تملك صلاحية الوصول',
                        isError: true);
                  } else {
                    setState(() {
                      isEnabled = true;
                    });
                  }
                },
                child: const Text('تعديل المعلومات')),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences localStorage =
                      await SharedPreferences.getInstance();

                  if (localStorage.getString("token") == null) {
                    context.showSnackBar('لا تملك صلاحية الوصول',
                        isError: true);
                  } else {
                    if (_formKey.currentState!.validate()) {
                      await _editStu();

                      context.showSnackBar(snack, isError: error);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StuSem(
                            current: widget.id,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text('حفظ التغييرات')),
          ],
        ),
      );
    });
  }
}
