import 'package:expense_manager/controllers/db_controller.dart';
import 'package:flutter/material.dart';
import 'package:expense_manager/static.dart' as Static;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../localization_service.dart';
import 'package:expense_manager/pages/homepage.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int? amount;
  String note = "Some Expense";
  String type = "Income";
  DateTime selectedDate = DateTime.now();
  String lng = "English";

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021, 12),
      lastDate: DateTime(2030, 01),
    );

    if(picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
      });
    }
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
      body: ListView(
        padding: EdgeInsets.all(
          12.0,
        ),
        children: [
          SizedBox(
            height: 20.0,
          ),
          Text(
            'add_transaction_title'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Static.PrimaryColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: EdgeInsets.all(
                  12.0,
                ),
                child: Icon(
                  Icons.attach_money,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "0",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val){
                    try{
                      amount = int.parse(val);
                    }catch(e){}
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Static.PrimaryColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: EdgeInsets.all(
                  12.0,
                ),
                child: Icon(
                  Icons.description,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'note_on_transaction'.tr,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  onChanged: (val){
                    note = val;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Static.PrimaryColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: EdgeInsets.all(
                  12.0,
                ),
                child: Icon(
                  Icons.moving_sharp,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              ChoiceChip(
                  label: Text(
                      'expense'.tr,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: type == "Expense" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryColor,
                  selected: type == "Expense" ? true : false,
                  onSelected: (val){
                    if(val){
                      setState(() {
                       type = "Expense";
                      }
                      );
                    }
                  },
              ),
              SizedBox(
                width: 12.0,
              ),
              ChoiceChip(
                label: Text(
                  'income'.tr,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: type == "Income" ? Colors.white : Colors.black,
                  ),
                ),
                selectedColor: Static.PrimaryColor,
                selected: type == "Income" ? true : false,
                onSelected: (val){
                  if(val){
                    setState(() {
                      type = "Income";
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          SizedBox(
            height: 50.0,
            child: TextButton(
                onPressed: () {
                  _selectDate(context);
                },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.zero,
                  ),
              ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Static.PrimaryColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.all(
                        12.0,
                      ),
                      child: Icon(
                        Icons.date_range,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      "${selectedDate.day} ${months[selectedDate.month - 1]}",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          SizedBox(
            height: 50.0,
            child: ElevatedButton(
                onPressed: () async {
                  if(amount != null && note.isNotEmpty){
                    DBController dbController = DBController();
                    await dbController.addData(amount!, selectedDate, note, type);
                    Navigator.of(context).pop();
                  }else{
                    print('not_all_values_provided'.tr);
                  }
                },
                child: Text(
                  'add_transaction'.tr,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ),
          ),
        ],
      )
    );
  }
}
