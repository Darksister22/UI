import 'package:flutter/material.dart';
import 'package:schoolmanagement/mains/instructors.dart';
import 'package:schoolmanagement/mains/students.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolmanagement/components/utils.dart';
import '../api.dart';

class addInsAlert extends StatelessWidget {
  TextEditingController nameAr = TextEditingController();
  TextEditingController nameEn = TextEditingController();
  var snack = '';
  var error = false;
  Future _addIns() async {
    var data = {
      'name_ar': nameAr.text,
      'name_en': nameEn.text,
    };

    try {
      final response =
          await CallApi().postData(data, '/api/instructors/create');

      snack = 'تم اضافة التدريسي بنجاح';

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
        title: const Text('اضافة تدريسي جديد'),
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
                        labelText: 'اسم التدريسي',
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
                        labelText: 'اسم التدريسي english',
                        prefixIcon: const Icon(Icons.password),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).margin9,
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
              child: const Text('الغاء')),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _addIns();
                  nameAr.text = '';
                  nameEn.text = '';
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Instructors(),
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
}
