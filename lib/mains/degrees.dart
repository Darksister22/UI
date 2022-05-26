import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:schoolmanagement/components/sidemenus.dart';
import 'package:schoolmanagement/models/student.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/stylefiles/customtext.dart';
import 'package:schoolmanagement/stylefiles/style.dart';

import '../addpages/addCourse.dart';
import '../addpages/stu_add.dart';
import 'login.dart';
import 'settingsmain.dart';

class Degrees extends StatefulWidget {
  static const String id = 'degrees';
  const Degrees({Key? key}) : super(key: key);

  @override
  _DegreesState createState() => _DegreesState();
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

class _DegreesState extends State<Degrees> {
  final DataTableSource _data = MyData();
  late Future<List<Student>> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    TextEditingController search = TextEditingController();
    bool cleared = false;

    return AdminScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Visibility(
                child: CustomText(
              text: ' الكورسات الدراسية - نظام اللجنة الامتحانية',
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
      sideBar: _sideBar.SideBarMenus(context, Degrees.id),
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
                      'اضافة كورس جديد',
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
                        builder: (context) => const addCourse(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 16,
              ),
              FutureBuilder<List<Student>>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    {
                      if (snapshot.hasData) {
                        return PaginatedDataTable(
                          header: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: search,
                                  //onSubmitted
                                  decoration: InputDecoration(
                                    labelText: 'البحث عن كورس',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ).margin9,
                              ),
                            ],
                          ),
                          columns: [
                            DataColumn(label: Text('اسم الطالب')),
                            DataColumn(label: Text('Student Name')),
                            DataColumn(label: Text('المرحلة الدراسية')),
                            DataColumn(label: Text('السنة الدراسية')),
                            DataColumn(label: Text('الملاحظات')),
                          ],
                          source: _data,
                          columnSpacing: 180,
                          actions: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.filter_alt_outlined,
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  'شروط البحث',
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return const CircularProgressIndicator();
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
  // Generate some made-up data
  final List<Map<String, dynamic>> _data =
      List.generate(2, (index) => {"id": index, "price": 11});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['id'].toString())),
      DataCell(Text(_data[index]["price"].toString())),
      DataCell(Text(_data[index]["price"].toString())),
      DataCell(Text(_data[index]["price"].toString())),
      DataCell(Text(_data[index]["price"].toString())),
    ]);
  }
}
