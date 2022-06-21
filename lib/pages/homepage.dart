import 'package:expense_manager/controllers/db_controller.dart';
import 'package:expense_manager/custom_page_route.dart';
import 'package:expense_manager/pages/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:expense_manager/static.dart' as Static;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../localization_service.dart';
import 'gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBController dbController = DBController();
  late SharedPreferences preferences;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();
  String lng = "English";

  @override
  void initState() {
    super.initState();
    getPreference();
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  List<FlSpot> getPlotPoints(Map entireData){
    dataSet = [];
    entireData.forEach((key, value) {
      if(value['type'] == "Expense" && (value['date'] as DateTime).month == today.month){
        dataSet.add(
            FlSpot(
                (value['date'] as DateTime).day.toDouble(),
                (value['amount'] as int).toDouble(),
            ),
        );
      }
    });
    return dataSet;
  }

  getTotalBalance(Map entireData){
    totalExpense = 0;
    totalIncome = 0;
    totalBalance = 0;
    entireData.forEach((key, value) {
      if(value['type'] == "Income"){
        totalBalance += (value['amount'] as int);
        totalIncome += (value['amount'] as int);
      }else{
        totalBalance -= (value['amount'] as int);
        totalExpense += (value['amount'] as int);
      }
    });
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
      floatingActionButton: SpeedDial(
          icon: Icons.more_vert,
          backgroundColor: Color(0xffadd8e6),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'add_transaction_title'.tr,
              backgroundColor: Static.PrimaryMaterialColor[800],
              onTap: () {
                Navigator.of(context).push(
                  CustomPageRoute(
                    child: AddTransaction(),
                  ),
                ).whenComplete(() {
                  setState(() {});
                });
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.camera),
              label: 'pictures'.tr,
              backgroundColor: Static.PrimaryMaterialColor[800],
              onTap: () {
                Navigator.of(context).push(
                  CustomPageRoute(
                    child: ImageGallery(),
                  ),
                ).whenComplete(() {
                  setState(() {});
                });
              },
            ),
          ]),


      body: FutureBuilder<Map>(
        future: dbController.fetch(),
        builder: (context, snapshot) {
            if(snapshot.hasError){
              return Center(child: Text('unexpected_err'.tr),);
            }
            if(snapshot.hasData){
              if(snapshot.data!.isEmpty){
                return Center(child: Text('no_values_found'.tr),);
              }
              getTotalBalance(snapshot.data!);
              getPlotPoints(snapshot.data!);
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    32.0
                                ),
                                color: Colors.white70,
                              ),

                              child: CircleAvatar(
                                maxRadius: 32.0,
                                child: Image.asset(
                                  "assets/money.png",
                                  width: 64.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "${'welcome'.tr}${preferences.getString('name')}!",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: Static.PrimaryMaterialColor[800],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              12.0
                            ),
                            color: Colors.white70,
                          ),
                          padding: EdgeInsets.all(
                            12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.all(
                      12.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Static.PrimaryColor,
                            Colors.blueGrey,
                          ],
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              22.0,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 8.0,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'balance'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Text(
                            "USD $totalBalance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Padding(
                              padding: EdgeInsets.all(
                                8.0,
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardIncome(
                                    totalIncome.toString(),
                                ),
                                cardExpense(
                                  totalExpense.toString(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'transactions'.tr,
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  dataSet.length < 2 ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 40.0,
                    ),
                    margin: EdgeInsets.all(
                      12.0,
                    ),
                    child: Text(
                      'not_enough_values'.tr,
                    ),
                  ) : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 40.0,
                    ),
                    margin: EdgeInsets.all(
                      12.0,
                    ),
                    height: 400.0,
                    child: LineChart(
                      LineChartData(
                        borderData: FlBorderData(
                          show: false,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: getPlotPoints(snapshot.data!),
                            isCurved: false,
                            barWidth: 2.5,
                            colors: [
                              Static.PrimaryColor,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'recent_trans'.tr,
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map dataAtIndex = snapshot.data![index];
                      if(dataAtIndex["type"] == "Income"){
                        return incomeTile(dataAtIndex["amount"], dataAtIndex["note"]);
                      }else {
                        return expendsTile(dataAtIndex["amount"], dataAtIndex["note"]);
                      }
                    },
                  ),
                ],
              );
            }else{
              return Center(
                child: Text("unexpected_err".tr),
              );
            }
        },
      ),
    );
  }

  Widget cardIncome(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0
            ),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
              Icons.arrow_upward,
            size: 28.0,
              color: Colors.green,
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'income'.tr,
              style: TextStyle(
              fontSize: 14.0,
              color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardExpense(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
                20.0
            ),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.red,
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'expense'.tr,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget expendsTile(int value, String note){
    return Container(
      margin: EdgeInsets.all(
        8.0,
      ),
      padding: EdgeInsets.all(
        18.0,
      ),
      decoration: BoxDecoration(
          color: Color(
            0xffced4eb,
          ),
          borderRadius: BorderRadius.circular(
              8.0
          ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                  Icons.arrow_circle_down_outlined,
                  size: 29.0,
                  color: Colors.red[700],
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                'expense'.tr,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          Text(
            "- $value",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget incomeTile(int value, String note){
    return Container(
      margin: EdgeInsets.all(
        8.0,
      ),
      padding: EdgeInsets.all(
        18.0,
      ),
      decoration: BoxDecoration(
        color: Color(
          0xffced4eb,
        ),
        borderRadius: BorderRadius.circular(
            8.0
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_up_outlined,
                size: 29.0,
                color: Colors.green[700],
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                'income'.tr,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          Text(
            "+ $value",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

}
