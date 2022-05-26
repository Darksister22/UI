import 'dart:math';

import 'package:flutter/material.dart';

import 'package:schoolmanagement/models/users.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';

import 'dart:convert';

import '../api.dart';

class userEditAlert extends StatelessWidget {
  final List<String> _auth = ['عضو - قراءة و تعديل', 'رئيس - جميع الصلاحيات'];

  User current;
  bool isEnabled = false;
  userEditAlert({Key? key, required this.current}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late String selection = 'عضو - قراءة و تعديل';
  // static String namear = current.level;
  var snack = '';
  var error = false;
  Future _addStu() async {
    var data = {
      'name_ar': 'nameAr.text',
      'name_en': 'nameEn.text',
      //  "level": translateLevelAE(sel_level),
      // "year": translateYearAE(sel_year)
    };

    try {
      final response = await CallApi().postData(data, '/api/students/create');

      if (response.statusCode == 403) {
        snack = 'لا تملك الصلاحية لاضافة طالب';
        error = true;
      } else {
        snack = 'تم اضافة الطالب بنجاح';
      }
      //  nameAr.text = '';
      //   nameEn.text = '';
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('تعديل معلومات المستخدم'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      enabled: isEnabled,
                      decoration: InputDecoration(
                        labelText: 'اسم المستخدم',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).margin9,
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      enabled: isEnabled,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'البريد الالكتروني',
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
                              hint: const Text('اختيار صلاحية المستخدم '),
                              value: selection,
                              onChanged: (newValue) {
                                setState(() {
                                  selection = newValue.toString();
                                });
                              },
                              items: _auth.map((auth) {
                                return DropdownMenuItem(
                                  child: Text(auth),
                                  value: auth,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                  // nameAr.text = current.email;
                  //   nameEn.text = '';
                }
              },
              child: const Text('حفظ التغييرات'))
        ],
      );
    });
  }

  void setState(Null Function() param0) {}
}
