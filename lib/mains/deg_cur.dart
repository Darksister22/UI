import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:schoolmanagement/api.dart';
import 'package:schoolmanagement/components/sidemenus.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/editpages/addhelp.dart';
import 'package:schoolmanagement/models/course.dart';
import 'package:schoolmanagement/models/degree.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/stylefiles/customtext.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:schoolmanagement/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'settingsmain.dart';

Widget _verticalDivider = const VerticalDivider(
  color: Colors.grey,
  thickness: 1,
);

class DegCur extends StatefulWidget {
  static const String id = 'degrees';
  const DegCur({Key? key}) : super(key: key);

  @override
  _DegCurState createState() => _DegCurState();
}

Future<List<Degree>> fetchAlbum() async {
  final response = await CallApi().getData('/api/degrees');
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body) as List;
    return result.map((e) => Degree?.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load');
  }

  // If that call was not successful, throw an error.
}

Future<List<Course>> fetchCourse() async {
  final response = await CallApi().getData('/api/courses');
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body) as List;
    return result.map((e) => Course.fromJson(e)).toList();
  } else {
    throw ('لا يوجد كورس دراسي حالي, الرجاء عرض الدرجات من الكورسات السابقة');
  }
}

class _DegCurState extends State<DegCur> {
  late Future<List<Degree>> futureAlbum;
  List<Course> _course = [];
  List<Degree> _data = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    TextEditingController search = TextEditingController();
    String? selLevel;
    String? selYear;
    List<String> _level = [
      'بكالوريوس',
      'ماجستير',
      'دكتوراة',
    ];
    String? selCourse;

    List<String> _year = [
      'السنة الاولى',
      'السنة الثانية',
      'السنة الثالثة',
      'السنة الرابعة',
      'السنة الخامسة',
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
      sideBar: _sideBar.SideBarMenus(context, DegCur.id),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: FutureBuilder<List<Degree>>(
              future: fetchAlbum(),
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
                                    labelText: 'العرض حسب طالب او مادة...',
                                    labelStyle:
                                        const TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.search_outlined),
                                      onPressed: () {
                                        setState(() {
                                          if (search.text.isEmpty) {
                                            _data = snapshot.data ?? [];
                                            return;
                                          }
                                          _data = snapshot.data!.where((s) {
                                            return s.stuname.nameAr
                                                    .contains(search.text) ||
                                                s.coursename.nameEn
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
                              label: Text(
                            'اسم المادة',
                            style: header,
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(
                              label: Text('درجة الدور الاول', style: header)),
                          DataColumn(label: _verticalDivider),
                          DataColumn(
                              label: Text('درجة الدور الثاني', style: header)),
                          DataColumn(label: _verticalDivider),
                          DataColumn(
                              label: Text('درجة الدور الثالث', style: header)),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Text('التقدير', style: header)),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Text('الحالة', style: header)),
                          DataColumn(label: _verticalDivider),
                        ],
                        arrowHeadColor: blue,
                        source: MyData(_data, (_data) {
                          showDialog(
                            context: context,
                            builder: (context) => AddHelp(current: _data),
                          );
                        }),
                        columnSpacing: MediaQuery.of(context).size.width / 30,
                        showCheckboxColumn: true,
                        actions: [
                          IconButton(
                              onPressed: () async {},
                              icon: const Icon(Icons.download)),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('عرض المعلومات حسب...'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 40,
                                                    child: ButtonTheme(
                                                      child: FutureBuilder<
                                                          List<Course>?>(
                                                        future: fetchCourse(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            _course =
                                                                snapshot.data ??
                                                                    [];
                                                            List<String> list =
                                                                [];
                                                            for (var i = 0;
                                                                i <
                                                                    _course
                                                                        .length;
                                                                i++) {
                                                              list.add(
                                                                  _course[i]
                                                                      .nameEn);
                                                            }
                                                            return StatefulBuilder(
                                                              builder:
                                                                  (BuildContext
                                                                          context,
                                                                      setState) {
                                                                return DropdownButton<
                                                                    String>(
                                                                  isExpanded:
                                                                      true,
                                                                  hint: const Text(
                                                                      'اختيار المادة'),
                                                                  value:
                                                                      selCourse,
                                                                  onChanged:
                                                                      (newValue) {
                                                                    setState(
                                                                        () {
                                                                      selCourse =
                                                                          newValue
                                                                              .toString();
                                                                    });
                                                                  },
                                                                  items: list
                                                                      .map(
                                                                          (ins) {
                                                                    return DropdownMenuItem(
                                                                      child: Text(
                                                                          ins),
                                                                      value:
                                                                          ins,
                                                                    );
                                                                  }).toList(),
                                                                );
                                                              },
                                                            );
                                                          }
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              CircularProgressIndicator(),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 40,
                                                    child: ButtonTheme(
                                                      child:
                                                          DropdownButtonFormField(
                                                        isExpanded: true,
                                                        hint: const Text(
                                                            'اختيار المرحلة الدراسية'),
                                                        value: selLevel,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            selLevel = newValue
                                                                .toString();
                                                          });
                                                        },
                                                        items:
                                                            _level.map((level) {
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 40,
                                                    child: ButtonTheme(
                                                      child:
                                                          DropdownButtonFormField(
                                                        isExpanded: true,
                                                        hint: const Text(
                                                            'اختيار السنة الدراسية'),
                                                        value: selYear,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            selYear = newValue
                                                                .toString();
                                                          });
                                                        },
                                                        items:
                                                            _year.map((year) {
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
                                          onPressed: () {
                                            setState(() {
                                              if (selLevel == null &&
                                                  selYear == null &&
                                                  selCourse == null) {
                                                Navigator.pop(context);
                                                return;
                                              } else if (selYear == null &&
                                                  selLevel != null &&
                                                  selCourse == null) {
                                                _data =
                                                    snapshot.data!.where((s) {
                                                  return s.coursename.level
                                                      .contains(
                                                          translateLevelAE(
                                                              selLevel!));
                                                }).toList();
                                              } else if (selLevel == null &&
                                                  selYear != null &&
                                                  selCourse == null) {
                                                _data =
                                                    snapshot.data!.where((s) {
                                                  return s.coursename.year
                                                      .contains(translateYearAE(
                                                          selYear!));
                                                }).toList();
                                              } else if (selLevel != null &&
                                                  selYear != null &&
                                                  selCourse == null) {
                                                _data =
                                                    snapshot.data!.where((s) {
                                                  return s.coursename.year
                                                          .contains(
                                                              translateYearAE(
                                                                  selYear!)) &&
                                                      s.coursename.level
                                                          .contains(
                                                              translateLevelAE(
                                                                  selLevel!));
                                                }).toList();
                                              } else if (selLevel == null &&
                                                  selYear == null &&
                                                  selCourse != null) {
                                                _data =
                                                    snapshot.data!.where((s) {
                                                  return s.coursename.nameEn
                                                      .contains(selCourse!);
                                                }).toList();
                                              } else if (selLevel != null &&
                                                  selYear == null &&
                                                  selCourse != null) {
                                                _data =
                                                    snapshot.data!.where((s) {
                                                  return s.coursename.nameEn
                                                          .contains(
                                                              selCourse!) &&
                                                      s.coursename.level
                                                          .contains(
                                                              translateLevelAE(
                                                                  selLevel!));
                                                }).toList();
                                              } else if (selLevel == null &&
                                                  selYear != null &&
                                                  selCourse != null) {
                                                _data =
                                                    snapshot.data!.where((s) {
                                                  return s.coursename.nameEn
                                                          .contains(
                                                              selCourse!) &&
                                                      s.coursename.year
                                                          .contains(
                                                              translateYearAE(
                                                                  selYear!));
                                                }).toList();
                                              } else if (selLevel != null &&
                                                  selYear != null &&
                                                  selCourse != null) {
                                                _data =
                                                    snapshot.data!.where((s) {
                                                  return s.coursename.nameEn ==
                                                          (selCourse!) &&
                                                      s.coursename.year
                                                          .contains(
                                                              translateYearAE(
                                                                  selYear!)) &&
                                                      s.coursename.level
                                                          .contains(
                                                              translateLevelAE(
                                                                  selLevel!));
                                                }).toList();
                                              }
                                            });
                                            selYear = null;
                                            selLevel = null;
                                            selCourse = null;
                                            Navigator.pop(context);
                                          },
                                          child: const Text('العرض'))
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

                  return const CircularProgressIndicator();
                }
              }),
        ).margin9,
      ),
    );
  }
}

class MyData extends DataTableSource {
  final List<Degree> snapshot;
  final Function(Degree) onEditPressed;
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
    String check(String col) {
      if (col == "null") {
        return "لا يوجد";
      } else {
        return col;
      }
    }

    String carry() {
      if (current.stuname.year != current.coursename.year) {
        return (current.stuname.nameAr + " (محمل)");
      }
      return current.stuname.nameAr;
    }

    return DataRow(cells: [
      DataCell(Text(carry())),
      DataCell(_verticalDivider),
      DataCell(
        Text(current.coursename.nameEn),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(check(current.final1.toString())),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(check(current.final2.toString())),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(check(current.final3.toString())),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(check(current.approx.toString())),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(
          translateStsEA(current.sts),
          style: TextStyle(
              backgroundColor:
                  (current.sts) == "pass" ? Colors.green : Colors.red,
              color: Colors.white),
        ),
      ),
      DataCell(_verticalDivider),
    ]);
  }
}
