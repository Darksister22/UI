import 'dart:math';

import 'package:flutter/material.dart';
import 'package:schoolmanagement/models/student.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolmanagement/components/utils.dart';
import '../api.dart';

class stuEditAlert extends StatelessWidget {
  late String sel_level = 'بكالوريوس';
  late String sel_year = 'السنة الاولى';
  Student current;
  bool isEnabled = false;
  stuEditAlert({Key? key, required this.current}) : super(key: key);

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
  TextEditingController nameAr = TextEditingController();
  TextEditingController nameEn = TextEditingController();
  TextEditingController note = TextEditingController();
  // static String namear = current.level;
  var snack = '';
  var error = false;
  Future _addStu() async {
    var data = {
      'name_ar': nameAr.text,
      'name_en': nameEn.text,
      "level": translateLevelAE(sel_level),
      "year": translateYearAE(sel_year)
    };

    try {
      final response = await CallApi().postData(data, '/api/students/create');

      if (response.statusCode == 403) {
        snack = 'لا تملك الصلاحية لاضافة طالب';
        error = true;
      } else {
        snack = 'تم اضافة الطالب بنجاح';
      }
      nameAr.text = '';
      nameEn.text = '';
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
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'اسم الطالب english',
                        prefixIcon: const Icon(Icons.password),
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
                              value: translateYearEA(current.year),
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
              onPressed: () {
                setState(() {
                  isEnabled = true;
                });
              },
              child: const Text('تعديل المعلومات')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  isEnabled = true;
                });
              },
              child: const Text('حذف الطالب')),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  //  await _addStu();
                  nameAr.text = current.level;
                  nameEn.text = '';
                }
              },
              child: const Text('حفظ التغييرات')),
        ],
      );
    });
  }

  void setState(Null Function() param0) {}
}
