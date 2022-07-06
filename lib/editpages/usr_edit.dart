import 'package:flutter/material.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/users.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../models/users.dart';

class UserEditAlert extends StatefulWidget {
  final User current;
  const UserEditAlert({Key? key, required this.current}) : super(key: key);

  @override
  State<UserEditAlert> createState() => _UserEditAlertState();
}

class _UserEditAlertState extends State<UserEditAlert> {
  final List<String> _auth = ['عضو - قراءة و تعديل', 'رئيس - جميع الصلاحيات'];

  bool isEnabled = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late String selection = 'عضو - قراءة و تعديل';

  @override
  void initState() {
    super.initState();
    nameController.text = widget.current.name;
    emailController.text = widget.current.email;
  }

  // static Student currents = const Student(

  // static String namear = current.level;
  var snack = '';

  var error = false;

  Future _delUsr() async {
    String id = widget.current.id.toString();
    var data = {
      'id': id,
    };

    try {
      await CallApi().postData(data, "/api/users/destroy/$id");

      snack = 'تم حذف المستخدم بنجاح';
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }

  Future _editUsr() async {
    String id = widget.current.id.toString();
    var data = {
      'id': id,
      'email': emailController.text,
      'name': nameController.text,
      "role": translateRoleAE(selection),
    };

    try {
      final response = await CallApi().postData(data, "/api/users/update");

      if (response.statusCode == 409) {
        snack = 'الايميل مكرر, يرجى ادخال ايميل جديد';
        error = true;
      } else {
        snack = 'تم تحديث معلومات المستخدم بنجاح';
      }
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "لا يمكن ترك الحقل فارغاً";
                        }
                        return null;
                      },
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "لا يمكن ترك الحقل فارغاً";
                        }
                        return null;
                      },
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'البريد الالكتروني',
                        prefixIcon: const Icon(Icons.email_outlined),
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
                  await _delUsr();
                  context.showSnackBar(snack, isError: error);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Users(),
                    ),
                  );
                }
              },
              child: const Text('حذف المستخدم')),
          ElevatedButton(
              onPressed: () async {
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();

                if (localStorage.getString("token") == null) {
                  context.showSnackBar('لا تملك صلاحية الوصول', isError: true);
                } else {
                  await _editUsr();
                  context.showSnackBar(snack, isError: error);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Users(),
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
