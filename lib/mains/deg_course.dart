import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:schoolmanagement/components/sidemenus.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/editpages/inst_edit.dart';
import 'package:schoolmanagement/models/course.dart';
import 'package:schoolmanagement/models/degree.dart';
import 'package:schoolmanagement/models/instructor.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/stylefiles/customtext.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../addpages/ins_add.dart';
import '../api.dart';
import 'login.dart';
import 'settingsmain.dart';

Widget _verticalDivider = const VerticalDivider(
  color: Colors.grey,
  thickness: 1,
);

class DegCourse extends StatefulWidget {
  static const String id = 'deg_course';
  final Course course;
  const DegCourse({Key? key, required this.course}) : super(key: key);
  @override
  _DegCourseState createState() => _DegCourseState();
}

class MyData extends DataTableSource {
  final List<Degree> snapshot;
  MyData(this.snapshot);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => snapshot.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    var current = snapshot[index];
    String check(String col) {
      if (col == "null") {
        return "لا يوجد";
      } else {
        return col;
      }
    }

    return DataRow(cells: [
      DataCell(
        Text(current.stuname!.nameAr.toString()),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(check(current.fourty.toString())),
      ),
    ]);
  }
}

class _DegCourseState extends State<DegCourse> {
  late Future<List<Instructor>> futureAlbum;
  List<Degree> _data = [];
  late int id;
  @override
  void initState() {
    super.initState();
    id = widget.course.id;
  }

  Future<List<Degree>>? fetch() async {
    try {
      final response =
          await CallApi().getData('/api/degrees/fourty?course_id=$id');
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as List;
        final x = result.map((e) => Degree.fromJson(e)).toList();
        return x;
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    TextEditingController search = TextEditingController();

    return AdminScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Visibility(
                child: CustomText(
              text: 'سعيات المادة - نظام اللجنة الامتحانية',
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
                onPressed: () async {
                  SharedPreferences localStorage =
                      await SharedPreferences.getInstance();

                  if (localStorage.getString("token") == null ||
                      localStorage.getString("role") == "admin") {
                    context.showSnackBar('لا تملك صلاحية الوصول',
                        isError: true);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                    );
                  }
                }),
            Container(
              width: 1,
              height: 22,
              color: lightgrey,
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              color: dark.withOpacity(.7),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
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
      sideBar: _sideBar.SideBarMenus(context, DegCourse.id),
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
                      'العودة',
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DegCourse(
                          course: widget.course,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              FutureBuilder<List<Degree>>(
                  future: fetch(),
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
                                                return s.stuname!.nameAr
                                                    .toString()
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
                                'اسم الطالب',
                                style: header,
                              )),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text('درجة السعي', style: header)),
                            ],
                            arrowHeadColor: blue,
                            source: MyData(_data),
                            columnSpacing: 95,
                            showCheckboxColumn: true,
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
