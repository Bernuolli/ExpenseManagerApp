import 'package:expense_manager/controllers/db_controller.dart';
import 'package:expense_manager/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../localization_service.dart';
import 'add_name.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String lng = "English";
  DBController dbController = DBController();

  Future getSettings() async{
    String? name = await dbController.getName();
    if(name != null){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AddName(),
        ),
      );
    }
  }

  @override
  void initState(){
    super.initState();
    getSettings();
  }

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
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Image.asset(
            "assets/icon.png",
            width: 64.0,
            height: 64.0,
          ),
        ),
      ),
    );
  }
}
