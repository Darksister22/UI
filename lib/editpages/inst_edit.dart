// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/instructors.dart';
import 'package:schoolmanagement/models/instructor.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../mains/students.dart';

class InstEditAlert extends StatefulWidget {
  Instructor current;
  InstEditAlert({Key? key, required this.current}) : super(key: key);

  @override
  State<InstEditAlert> createState() => _InstEditAlertState();
}

class _InstEditAlertState extends State<InstEditAlert> {
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    nameAr.text = widget.current.nameAr;
    nameEn.text = widget.current.nameEn;
  }

  // static Student currents = const Student(
  TextEditingController nameAr = TextEditingController();

  TextEditingController nameEn = TextEditingController();

  // static String namear = current.level;
  var snack = '';

  var error = false;

  Future _delInst() async {
    String id = widget.current.id.toString();
    var data = {
      'id': id,
    };

    try {
      
          await CallApi().postData(data, "/api/instructors/destroy/$id");

      snack = 'تم حذف التدريسي بنجاح';
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  Future _editInst() async {
    String id = widget.current.id.toString();
    var data = {
      "id": id,
      'name_ar': nameAr.text,
      'name_en': nameEn.text,
    };

    try {
      
          await CallApi().postData(data, "/api/instructors/update");

      snack = 'تم تحديث معلومات التدريسي بنجاح';
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('تعديل معلومات التدريسي'),
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
                      enabled: isEnabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "لا يمكن ترك الحقل فارغاً";
                        }
                        return null;
                      },
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'اسم التدريسي english',
                        prefixIcon: const Icon(Icons.person),
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
                  await _delInst();
                  context.showSnackBar(snack, isError: error);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Students(),
                    ),
                  );
                }
              },
              child: const Text('حذف التدريسي')),
          ElevatedButton(
              onPressed: () async {
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();

                if (localStorage.getString("token") == null) {
                  context.showSnackBar('لا تملك صلاحية الوصول', isError: true);
                } else {
                  await _editInst();
                  context.showSnackBar(snack, isError: error);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Instructors(),
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
