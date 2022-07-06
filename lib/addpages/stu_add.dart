// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/students.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';

import '../api.dart';

class AddStuAlert extends StatelessWidget {
  String? sellevel;
  String? selyear;
  final List<String> _level = [
    'بكالوريوس',
    'ماجستير',
    'دكتوراة',
  ];

  final List<String> _year = [
    'السنة الاولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
    'السنة الخامسة',
  ];
  TextEditingController nameAr = TextEditingController();
  TextEditingController nameEn = TextEditingController();
  var snack = '';
  var error = false;
  final _formKey = GlobalKey<FormState>();
  AddStuAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('اضافة طالب جديد'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameAr,
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
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ButtonTheme(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text('اختيار المرحلة الدراسية'),
                            value: sellevel,
                            onChanged: (newValue) {
                              setState(() {
                                sellevel = newValue.toString();
                              });
                            },
                            items: _level.map((level) {
                              return DropdownMenuItem(
                                child: Text(level),
                                value: level,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ButtonTheme(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            hint: const Text('اختيار السنة الدراسية'),
                            value: selyear,
                            onChanged: (newValue) {
                              setState(() {
                                selyear = newValue.toString();
                              });
                            },
                            items: _year.map((year) {
                              return DropdownMenuItem(
                                child: Text(year),
                                value: year,
                              );
                            }).toList(),
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
                  await _addStu();
                  nameAr.text = '';
                  nameEn.text = '';
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

  void setState(Null Function() param0) {}

  Future _addStu() async {
    var data = {
      'name_ar': nameAr.text,
      'name_en': nameEn.text,
      "level": translateLevelAE(sellevel!),
      "year": translateYearAE(selyear!)
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
}
