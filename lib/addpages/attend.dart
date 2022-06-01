import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/stu_sem.dart';
import 'package:schoolmanagement/mains/students.dart';
import 'package:schoolmanagement/models/student.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';
import '../api.dart';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class addCarry extends StatefulWidget {
  Student current;

  addCarry({Key? key, required this.current}) : super(key: key);

  @override
  State<addCarry> createState() => _addCarryState();
}

class _addCarryState extends State<addCarry> {
  late int stu;
  late String lvl;
  late String? sel_course;
  late Future<List<Course>> futureAlbum;
  List<Course> _data = [];
  @override
  void initState() {
    super.initState();
    stu = widget.current.id;

    lvl = widget.current.level;
  }

  Future<List<Course>>? fetch() async {
    try {
      final response = await CallApi().getData('/api/courses/level?level=$lvl');
      print(jsonDecode(response.body)['courses']);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body)['courses'] as List;
        final x = result.map((e) => Course.fromJson(e)).toList();
        print(x);
        return x;
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future _addStu() async {
    var data = {
      'name_en': sel_course,
      "student_id": stu,
    };

    try {
      final response = await CallApi().postData(data, '/api/students/attend');

      if (response.statusCode == 410) {
        error = true;
        snack = 'لا يوجد مادة بهذا الاسم, الرجاء التأكد';
      } else if (response.statusCode == 409) {
        error = true;
        snack = 'لا يمكنك اضافة طالب من خارج المرحلة الدراسية للمادة';
      } else if (response.statusCode == 411) {
        error = true;
        snack = 'الطالب ينتمي للمادة مسبقاً';
      } else if (response.statusCode == 200) {
        snack = 'تم اضافة المادة بنجاح';
      } else {
        error = true;
        snack = 'حدث خطأ ما يرجى اعادة المحاولة';
      }
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  TextEditingController nameAr = TextEditingController();

  var snack = '';

  var error = false;

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('اضافة الطالب لمادة'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ButtonTheme(
                          child: FutureBuilder<List<Course>?>(
                            future: fetch(),
                            builder: (context, snapshot) {
                              print(snapshot.connectionState);
                              print(snapshot.data);

                              if (snapshot.hasData) {
                                _data = snapshot.data ?? [];
                                List<String> list = [];
                                for (var i = 0; i < _data.length; i++) {
                                  list.add(_data[i].nameEn);
                                }
                                return StatefulBuilder(
                                  builder: (BuildContext context, setState) {
                                    return DropdownButton<String>(
                                      isExpanded: true,
                                      hint: const Text('اختيار المادة'),
                                      value: null,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sel_course = newValue.toString();
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  CircularProgressIndicator(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('الغاء')),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  //  await _addStu();
                  nameAr.text = '';

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Students(),
                    ),
                  );

                  context.showSnackBar(snack, isError: error);
                }
              },
              child: const Text('اضافة'))
        ],
      );
    });
  }
}
