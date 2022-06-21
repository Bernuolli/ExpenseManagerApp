import 'package:expense_manager/controllers/db_controller.dart';
import 'package:expense_manager/pages/homepage.dart';
import 'package:expense_manager/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../localization_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String lng = "English";
  DBController dbController = DBController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('main_title'.tr),
        actions: [
          DropdownButton<String>(
            items: LocalizationService.langs.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: this.lng,
            underline: Container(color: Colors.transparent),
            isExpanded: false,
            onChanged: (newVal) {
              setState(() {
                this.lng = newVal!;
                LocalizationService().changeLocale(newVal);
              });
            },
          ),
        ],
      ),
      //
      backgroundColor: Color(0xffe2e7ef),
      //
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(

          children: [

            SizedBox(
              height: 12,
            ),
            Text(
              "${'main_title'.tr} App",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 200.0,
            ),
            SizedBox(
              height: 50.0,
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Splash(),
                  ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'login'.tr,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Icon(
                        Icons.navigate_next
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
