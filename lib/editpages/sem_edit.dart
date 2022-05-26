import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:schoolmanagement/api.dart';
import 'package:schoolmanagement/components/sidemenus.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/dashboards/dashboars.dart';
import 'package:schoolmanagement/dashboards/sem_edit_dash.dart';
import 'package:schoolmanagement/mains/login.dart';
import 'package:schoolmanagement/mains/settingsmain.dart';
import 'package:schoolmanagement/stylefiles/customtext.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SemEditMain extends StatefulWidget {
  static const String id = 'semedit';
  const SemEditMain({Key? key}) : super(key: key);

  @override
  _SemEditMainState createState() => _SemEditMainState();
}

class _SemEditMainState extends State<SemEditMain> {
  SideBarWidget _sideBarWidget = SideBarWidget();
  late int res;
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Visibility(
                  child: CustomText(
                text: 'تعديل الفصل الدراسي',
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
                  if (localStorage.getString("token") == null) {
                    context.showSnackBar(
                        'لا تملك صلاحية الوصول, الرجاء تسجيل الدخول',
                        isError: true);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                    );
                  }
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
                  await preferences.remove('token');
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
        backgroundColor: light,
        sideBar: _sideBarWidget.SideBarMenus(context, SemEditMain.id),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Visibility(child: SemesterEditDash()),
              ],
            ),
          ),
        ));
  }
}
