import 'package:flutter/material.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/editpages/avergasgrad.dart';
import 'package:schoolmanagement/mains/grads.dart';
import 'package:schoolmanagement/models/grads.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';

class GradEditAlert extends StatefulWidget {
  final Grad current;
  const GradEditAlert({Key? key, required this.current}) : super(key: key);

  @override
  State<GradEditAlert> createState() => _GradEditAlertState();
}

class _GradEditAlertState extends State<GradEditAlert> {
  late String sellevel = 'بكالوريوس';

  late String selyear = 'السنة الاولى';

  bool isEnabled = false;

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

  @override
  void initState() {
    super.initState();
    nameAr.text = widget.current.nameAr;
    nameEn.text = widget.current.nameEn;
    note.text = widget.current.note ?? '';
    deg.text = widget.current.summer ?? "";
  }

  // static Student currents = const Student(
  TextEditingController nameAr = TextEditingController();

  TextEditingController nameEn = TextEditingController();

  TextEditingController note = TextEditingController();
  TextEditingController deg = TextEditingController();

  // static String namear = current.level;
  var snack = '';

  var error = false;

  Future _editStu() async {
    String id = widget.current.id.toString();
    var data = {"id": id, "note": note.text, "summer_deg": deg.text};

    try {
      await CallApi().postData(data, "/api/grads/update");

      snack = 'تم تحديث معلومات الطالب بنجاح';
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
                      enabled: false,
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
                      enabled: false,
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
                          child: IgnorePointer(
                            ignoring: true,
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
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ButtonTheme(
                          child: IgnorePointer(
                            ignoring: true,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: const Text('اختيار السنة الدراسية'),
                              value: translateYearEA(widget.current.year),
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
                    TextFormField(
                      controller: note,
                      enabled: isEnabled,
                      decoration: InputDecoration(
                        labelText: 'درجة التدريب الصيفي',
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
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        AveragesGrad(current: widget.current));
              },
              child: const Text('عرض معدلات الطالب')),
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
                  await _editStu();
                  context.showSnackBar(snack, isError: error);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Grads(),
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
