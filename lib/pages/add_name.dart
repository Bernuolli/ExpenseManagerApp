import 'package:expense_manager/controllers/db_controller.dart';
import 'package:expense_manager/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../localization_service.dart';

class AddName extends StatefulWidget {
  const AddName({Key? key}) : super(key: key);

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  String lng = "English";
  String name = "";

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
            SizedBox(
              height: 12,
            ),
            Text(
                'user_name'.tr,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 16.0,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'name_hint'.tr,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  onChanged: (val){
                    name = val;
                  },
                ),
            ),
            SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 50.0,
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: (){
                    if(name.isNotEmpty){
                      dbController.addName(name);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(),
                      ),
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          action: SnackBarAction(
                            label: "OK",
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                          backgroundColor: Colors.white,
                          content: Text(
                            'give_your_name'.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'next'.tr,
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
