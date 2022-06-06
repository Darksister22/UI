import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:schoolmanagement/api.dart';
import 'package:schoolmanagement/components/sidemenus.dart';
import 'package:schoolmanagement/editpages/usr_edit.dart';
import 'package:schoolmanagement/models/users.dart';
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

class Users extends StatefulWidget {
  static const String id = 'users';
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

Future<List<User>> fetchAlbum() async {
  final response = await CallApi().getData('/api/users/get');
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body) as List;

    return result.map((e) => User.fromJson(e)).toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load');
  }
}

class _UsersState extends State<Users> {
  late Future<List<User>> futureAlbum;
  List<User> _data = [];
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    TextEditingController search = TextEditingController();
    late String selection = 'عضو - قراءة و تعديل';
    final List<String> _auth = ['عضو - قراءة و تعديل', 'رئيس - جميع الصلاحيات'];
    final _formKey = GlobalKey<FormState>();

    return AdminScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Visibility(
                child: CustomText(
              text: 'تفاصيل المستخدمين - نظام اللجنة الامتحانية',
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
      sideBar: _sideBar.SideBarMenus(context, Users.id),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 16),
              FutureBuilder<List<User>>(
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
                                        labelText: 'البحث عن اسم مستخدم',
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
                                                return s.name
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
                                'رقم المستخدم',
                                style: header,
                              )),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text('اسم المستخدم ', style: header)),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label:
                                      Text('البريد الالكتروني', style: header)),
                              DataColumn(label: _verticalDivider),
                              DataColumn(
                                  label: Text('الصلاحية', style: header)),
                            ],
                            arrowHeadColor: blue,
                            source: MyData(_data, (_data) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    UserEditAlert(current: _data),
                              );
                            }),
                            columnSpacing: 45,
                            showCheckboxColumn: true,
                            actions: [
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 40,
                                                        child: ButtonTheme(
                                                          child:
                                                              DropdownButtonFormField(
                                                            isExpanded: true,
                                                            hint: const Text(
                                                                'صلاحية المستخدم'),
                                                            value: selection,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                selection = newValue
                                                                    .toString();
                                                              });
                                                            },
                                                            items: _auth
                                                                .map((level) {
                                                              return DropdownMenuItem(
                                                                child:
                                                                    Text(level),
                                                                value: level,
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
                                                  _data =
                                                      snapshot.data!.where((s) {
                                                    return s.role ==
                                                        translateRoleAE(
                                                            selection);
                                                  }).toList();
                                                });
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
            ],
          ),
        ).margin9,
      ),
    );
  }
}

class MyData extends DataTableSource {
  final List<User> snapshot;
  final Function(User) onEditPressed;
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
        Text(current.name.toString()),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(current.email.toString()),
      ),
      DataCell(_verticalDivider),
      DataCell(
        Text(translateRoleEA(current.role)),
      ),
    ]);
  }
}
