import 'dart:math';

import 'package:flutter/material.dart';
import 'package:schoolmanagement/models/student.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolmanagement/components/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addpages/attend.dart';
import '../api.dart';
import '../mains/students.dart';

class stuEditAlert extends StatefulWidget {
  Student current;
  stuEditAlert({Key? key, required this.current}) : super(key: key);

  @override
  State<stuEditAlert> createState() => _stuEditAlertState();
}

class _stuEditAlertState extends State<stuEditAlert> {
  late String sel_level = 'بكالوريوس';

  late String sel_year = 'السنة الاولى';

  bool isEnabled = false;

  final List<String> _Level = [
    'بكالوريوس',
    'ماجستير',
    'دكتوراة',
  ];

  final List<String> _Year = [
    'السنة الاولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
    'السنة الخامسة',
    'السنة السادسة',
    'السنة الثامنة',
    'السنة التاسعة',
    'السنة العاشرة',
  ];

  @override
  void initState() {
    super.initState();
    nameAr.text = widget.current.nameAr;
    nameEn.text = widget.current.nameEn;
    note.text = widget.current.note ?? '';
  }

  // static Student currents = const Student(
  TextEditingController nameAr = TextEditingController();

  TextEditingController nameEn = TextEditingController();

  TextEditingController note = TextEditingController();

  // static String namear = current.level;
  var snack = '';

  var error = false;

  Future _delStu() async {
    String id = widget.current.id.toString();
    var data = {};

    try {
      final response =
          await CallApi().postData(data, "/api/students/destroy/$id");

      snack = 'تم حذف الطالب بنجاح';
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  Future _editStu() async {
    String id = widget.current.id.toString();
    var data = {
      "id": id,
      'name_ar': nameAr.text,
      'name_en': nameEn.text,
      "level": translateLevelAE(sel_level),
      "year": translateYearAE(sel_year),
      "note": note.text
    };

    try {
      final response = await CallApi().postData(data, "/api/students/update");

      snack = 'تم تحديث معلومات الطالب بنجاح';
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('تعديل معلومات الطالب'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameAr,
                      enabled: isEnabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "لا يمكن ترك الحقل فارغاً";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'اسم الطالب',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).margin9,
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameEn,
                      enabled: isEnabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "لا يمكن ترك الحقل فارغاً";
                        }
                        return null;
                      },
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'اسم الطالب english',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).margin9,
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ButtonTheme(
                          child: IgnorePointer(
                            ignoring: !isEnabled,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text('اختيار المرحلة الدراسية'),
                              value: sel_level,
                              onChanged: (newValue) {
                                setState(() {
                                  sel_level = newValue.toString();
                                });
                              },
                              items: _Level.map((level) {
                                return DropdownMenuItem(
                                  child: Text(level),
                                  value: level,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ButtonTheme(
                          child: IgnorePointer(
                            ignoring: !isEnabled,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: const Text('اختيار السنة الدراسية'),
                              value: translateYearEA(widget.current.year),
                              onChanged: (newValue) {
                                setState(() {
                                  sel_year = newValue.toString();
                                });
                              },
                              items: _Year.map((year) {
                                return DropdownMenuItem(
                                  child: Text(year),
                                  value: year,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: note,
                      enabled: isEnabled,
                      decoration: InputDecoration(
                        labelText: 'الملاحظات',
                        prefixIcon: const Icon(Icons.note),
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
                  context.showSnackBar('لا تملك صلاحية الوصول', isError: true);
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
                  context.showSnackBar('لا تملك صلاحية الوصول', isError: true);
                } else {
                  await _delStu();
                  context.showSnackBar(snack, isError: error);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Students(),
                    ),
                  );
                }
              },
              child: const Text('حذف الطالب')),
          ElevatedButton(
              onPressed: () async {
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();

                if (localStorage.getString("token") == null) {
                  context.showSnackBar('لا تملك صلاحية الوصول', isError: true);
                } else {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (contest) => addCarry(current: widget.current));
                }
              },
              child: const Text('اضافة الطالب الى مادة')),
          ElevatedButton(
              onPressed: () async {
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();

                if (localStorage.getString("token") == null) {
                  context.showSnackBar('لا تملك صلاحية الوصول', isError: true);
                } else {
                  await _editStu();
                  context.showSnackBar(snack, isError: error);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Students(),
                    ),
                  );
                }
              },
              child: const Text('حفظ التغييرات')),
        ],
      );
    });
  }
}
