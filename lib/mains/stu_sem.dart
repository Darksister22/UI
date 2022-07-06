import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:schoolmanagement/components/sidemenus.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/editpages/course_edit.dart';
import 'package:schoolmanagement/mains/deg_course.dart';
import 'package:schoolmanagement/mains/settingsmain.dart';
import 'package:schoolmanagement/models/student.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:schoolmanagement/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../editpages/deg_edit.dart';
import '../models/course.dart';
import '../stylefiles/customtext.dart';
import 'login.dart';

Widget _verticalDivider = const VerticalDivider(
  color: Colors.grey,
  thickness: 1,
);
late String year;

class MyData extends DataTableSource {
  final List<Student> snapshot;
  final Function(Student, Course) onEditPressed;
  final Course id;
  MyData(this.snapshot, this.id, this.onEditPressed);

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
    String carry() {
      if (current.year != year) {
        return current.nameAr + " (محمل)";
      }
      return current.nameAr;
    }

    return DataRow(cells: [
      DataCell(IconButton(
        icon: Icon(
          Icons.edit_outlined,
          color: Colors.grey[700],
        ),
        onPressed: () {
          onEditPressed(current, id);
        },
      )),
      DataCell(_verticalDivider),
      DataCell(
        Text(current.id.toString()),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(carry()),
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
      DataCell(_verticalDivider),
    ]);
  }
}

class StuSem extends StatefulWidget {
  static const String id = 'studentsem';
  final Course current;
  const StuSem({Key? key, required this.current}) : super(key: key);

  @override
  State<StuSem> createState() => _StuSemState();
}

class _StuSemState extends State<StuSem> {
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

  late List<Student> _data;
  late List<Student> _carries;
  late int id;
  // static Student currents = const Student(
  TextEditingController nameAr = TextEditingController();

  TextEditingController nameEn = TextEditingController();

  TextEditingController note = TextEditingController();

  // static String namear = current.level;
  var snack = '';

  var error = false;

  final _formKey = GlobalKey<FormState>();

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
              text: 'تفاصيل المادة - نظام اللجنة الامتحانية',
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
      sideBar: _sideBar.SideBarMenus(context, StuSem.id),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 16),
              StatefulBuilder(builder: (context, setState) {
                return PaginatedDataTable(
                  header: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: search,
                          decoration: InputDecoration(
                              labelText: 'البحث عن طالب',
                              labelStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search_outlined),
                                onPressed: () {
                                  setState(() {
                                    if (search.text.isEmpty) {
                                      _data = _data;
                                      return;
                                    }
                                    _data = _data.where((s) {
                                      return s.nameAr.contains(search.text);
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
                      'عرض الدرجات',
                      style: header,
                    )),
                    DataColumn(label: _verticalDivider),
                    DataColumn(
                        label: Text(
                      'رقم الطالب',
                      style: header,
                    )),
                    DataColumn(label: _verticalDivider),
                    DataColumn(label: Text('اسم الطالب ', style: header)),
                    DataColumn(label: _verticalDivider),
                    DataColumn(label: Text('Student Name', style: header)),
                    DataColumn(label: _verticalDivider),
                    DataColumn(label: Text('السنة الدراسية', style: header)),
                    DataColumn(label: _verticalDivider),
                    DataColumn(label: Text('المرحلة الدراسية', style: header)),
                    DataColumn(label: _verticalDivider),
                  ],
                  arrowHeadColor: blue,
                  source: MyData(_data, widget.current, (_data, id) {
                    showDialog(
                      context: context,
                      builder: (context) => DegEdit(
                        id: id,
                        student: _data,
                      ),
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 40,
                                            child: ButtonTheme(
                                              child: DropdownButtonFormField(
                                                isExpanded: true,
                                                hint: const Text(
                                                    'اختيار المرحلة الدراسية'),
                                                value: sellevel,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    sellevel =
                                                        newValue.toString();
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 40,
                                            child: ButtonTheme(
                                              child: DropdownButtonFormField(
                                                isExpanded: true,
                                                hint: const Text(
                                                    'اختيار السنة الدراسية'),
                                                value: selyear,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selyear =
                                                        newValue.toString();
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
                                    // sel_year = null;
                                    // sel_level = null;
                                    // Navigator.pop(context);
                                  },
                                  child: const Text('الغاء')),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (sellevel == null && selyear == null) {
                                        Navigator.pop(context);
                                        return;
                                      } else if (selyear == null &&
                                          sellevel != null) {
                                        _data = _data.where((s) {
                                          return s.level.contains(
                                              translateLevelAE(sellevel!));
                                        }).toList();
                                      } else if (sellevel == null &&
                                          selyear != null) {
                                        _data = _data.where((s) {
                                          return s.year.contains(
                                              translateYearAE(selyear!));
                                        }).toList();
                                      } else {
                                        _data = _data.where((s) {
                                          return s.year.contains(
                                                  translateYearAE(selyear!)) &&
                                              s.level.contains(
                                                  translateLevelAE(sellevel!));
                                        }).toList();
                                      }
                                    });
                                    selyear = null;
                                    sellevel = null;
                                    Navigator.pop(context);
                                  },
                                  child: const Text('البحث'))
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        size: 30,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width) / 5,
                          child: TextButton(
                            child: Text(
                              'تعديل معلومات المادة',
                              style: buttons,
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return blue;
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
                                  builder: (context) => EditCourse(
                                    current: widget.current,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width) / 5,
                          child: TextButton(
                            child: Text(
                              'عرض سعيات المادة',
                              style: buttons,
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return blue;
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DegCourse(
                                    course: widget.current,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                );
              })
            ],
          ),
        ).margin9,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _data = widget.current.student!;
    _carries = widget.current.carries!;
    _data = _data + _carries;
    id = widget.current.id;
    year = widget.current.year;
  }
}
