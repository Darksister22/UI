import 'dart:convert';
import 'dart:js';
import 'package:schoolmanagement/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:http/http.dart' as http;

import 'package:schoolmanagement/components/sidemenus.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/models/student.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/stylefiles/customtext.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:schoolmanagement/api.dart';
import 'package:schoolmanagement/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addpages/stu_add.dart';
import '../editpages/stu_edit.dart';
import 'login.dart';
import 'settingsmain.dart';

Widget _verticalDivider = VerticalDivider(
  color: Colors.grey,
  thickness: 1,
);

class Students extends StatefulWidget {
  static const String id = 'students';
  const Students({Key? key}) : super(key: key);

  @override
  _StudentsState createState() => _StudentsState();
}

Future<List<Student>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/students'));
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body) as List;

    return result.map((e) => Student.fromJson(e)).toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load');
  }
}

class _StudentsState extends State<Students> {
  late Future<List<Student>> futureAlbum;
  List<Student> _data = [];
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    TextEditingController search = TextEditingController();
    String? sel_level;
    String? sel_year;
    List<String> _Level = [
      'بكالوريوس',
      'ماجستير',
      'دكتوراة',
    ];
    List<String> _Year = [
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
    final _formKey = GlobalKey<FormState>();

    return AdminScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Visibility(
                child: CustomText(
              text: 'تفاصيل الطلبة - نظام اللجنة الامتحانية',
              color: lightgrey,
              size: 20,
              fontWeight: FontWeight.bold,
            )),
            Expanded(
              child: Container(),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              color: dark.withOpacity(.7),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            ),
            Container(
              width: 1,
              height: 22,
              color: lightgrey,
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              color: dark.withOpacity(.7),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 24,
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: dark,
        ),
        backgroundColor: light,
      ),
      sideBar: _sideBar.SideBarMenus(context, Students.id),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width) / 4,
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'اضافة طالب جديد',
                      style: buttons,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return blue;
                        // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () async {
                    SharedPreferences localStorage =
                        await SharedPreferences.getInstance();
                    if (localStorage.getString("token") == null) {
                      context.showSnackBar(
                          'لا تملك صلاحية الوصول, الرجاء تسجيل الدخول',
                          isError: true);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => addStuAlert(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              FutureBuilder<List<Student>>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    {
                      if (snapshot.hasData) {
                        _data = snapshot.data ?? [];
                        return StatefulBuilder(builder: (context, setState) {
                          return PaginatedDataTable(
                            header: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: search,
                                    decoration: InputDecoration(
                                        labelText: 'البحث عن طالب',
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        suffixIcon: IconButton(
                                          icon:
                                              const Icon(Icons.search_outlined),
                                          onPressed: () {
                                            setState(() {
                                              if (search.text.isEmpty) {
                                                _data = snapshot.data!;
                                                return;
                                              }
                                              _data = snapshot.data!.where((s) {
                                                return s.nameAr
                                                    .contains(search.text);
                                              }).toList();
                                            });
                                            search.text = '';
                                          },
                                        )),
                                  ).margin9,
                                ),
                              ],
                            ),
                            columns: [
                              DataColumn(
                                  label: Text(
                                'عرض المعلومات',
                                style: header,
                              )),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text(
                                'رقم الطالب',
                                style: header,
                              )),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text('اسم الطالب ', style: header)),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text('Student Name', style: header)),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text('السنة الدراسية', style: header)),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label:
                                      Text('المرحلة الدراسية', style: header)),
                            ],
                            arrowHeadColor: blue,
                            source: MyData(_data, (_data) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    stuEditAlert(current: _data),
                              );
                            }),
                            columnSpacing: 35,
                            showCheckboxColumn: true,
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('عرض المعلومات حسب...'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 40,
                                                        child: ButtonTheme(
                                                          child:
                                                              DropdownButtonFormField(
                                                            isExpanded: true,
                                                            hint: Text(
                                                                'اختيار المرحلة الدراسية'),
                                                            value: sel_level,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                sel_level = newValue
                                                                    .toString();
                                                              });
                                                            },
                                                            items: _Level.map(
                                                                (level) {
                                                              return DropdownMenuItem(
                                                                child: new Text(
                                                                    level),
                                                                value: level,
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 40,
                                                        child: ButtonTheme(
                                                          child:
                                                              DropdownButtonFormField(
                                                            isExpanded: true,
                                                            hint: Text(
                                                                'اختيار السنة الدراسية'),
                                                            value: sel_year,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                sel_year = newValue
                                                                    .toString();
                                                              });
                                                            },
                                                            items: _Year.map(
                                                                (year) {
                                                              return DropdownMenuItem(
                                                                child: new Text(
                                                                    year),
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
                                              child: Text('الغاء')),
                                          ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (sel_level == null &&
                                                      sel_year == null) {
                                                    Navigator.pop(context);
                                                    return;
                                                  } else if (sel_year == null &&
                                                      sel_level != null) {
                                                    _data = snapshot.data!
                                                        .where((s) {
                                                      return s.level.contains(
                                                          translateLevelAE(
                                                              sel_level!));
                                                    }).toList();
                                                  } else if (sel_level ==
                                                          null &&
                                                      sel_year != null) {
                                                    _data = snapshot.data!
                                                        .where((s) {
                                                      return s.year.contains(
                                                          translateYearAE(
                                                              sel_year!));
                                                    }).toList();
                                                  } else {
                                                    _data = snapshot.data!
                                                        .where((s) {
                                                      return s.year.contains(
                                                              translateYearAE(
                                                                  sel_year!)) &&
                                                          s.level.contains(
                                                              translateLevelAE(
                                                                  sel_level!));
                                                    }).toList();
                                                  }
                                                });
                                              },
                                              child: Text('اضافة'))
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_outlined,
                                    size: 30,
                                  ))
                            ],
                          );
                        });
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                  }),
            ],
          ),
        ).margin9,
      ),
    );
  }
}

class MyData extends DataTableSource {
  final List<Student> snapshot;
  final Function(Student) onEditPressed;
  MyData(this.snapshot, this.onEditPressed);

  // Generate some made-up data
  //final List<Map<String, dynamic>> _data =
  //  List.generate(100, (index) => {"id": index, "price": 11});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => snapshot.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    var current = snapshot[index];

    return DataRow(cells: [
      DataCell(IconButton(
        icon: Icon(
          Icons.visibility_outlined,
          color: Colors.grey[700],
        ),
        onPressed: () {
          onEditPressed(current);
        },
      )),
      DataCell(_verticalDivider),
      DataCell(
        Text(current.id.toString()),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(current.nameAr.toString()),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(current.nameEn.toString()),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(translateYearEA(current.year)),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(translateLevelEA(current.level.toString())),
      ),
    ]);
  }
}
