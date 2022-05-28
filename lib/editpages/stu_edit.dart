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

  bool isEnabled = false;
  Student current;
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
  static Student currents = const Student(
      id: 0,
      year: "",
      note: "",
      level: "",
      nameAr: '',
      nameEn: "",
      avg1: "",
      avg2: "",
      avg10: "",
      avg3: "",
      avg4: "",
      avg5: "",
      avg6: "",
      avg7: "",
      avg8: "",
      avg9: "");
  @override
  void initState() {
    currents = current;
    print(currents.id);
  }

  TextEditingController nameAr = TextEditingController(text: currents.nameAr);
  TextEditingController nameEn = TextEditingController(text: currents.nameEn);
  TextEditingController note = TextEditingController(text: currents.note);

  // static String namear = current.level;
  var snack = '';
  var error = false;
  Future _delStu() async {
    String id = current.id.toString();
    String url = 'http://127.0.0.1:8000/api/students/destroy/' + id;
    try {
      final response = await http
          .delete(Uri.parse('http://127.0.0.1:8000/api/students/destroy/$id'));
      if (response.statusCode == 200) {
        print('done');
      }
    } catch (e) {
      print(e);
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
                  print(currents.id);
                });
              },
              child: const Text('تعديل المعلومات')),
          ElevatedButton(
              onPressed: () async {
                await _delStu();
              },
              child: const Text('حذف الطالب')),
          ElevatedButton(
              onPressed: () async {}, child: const Text('حفظ التغييرات')),
        ],
      );
    });
  }

  void setState(Null Function() param0) {}
}
