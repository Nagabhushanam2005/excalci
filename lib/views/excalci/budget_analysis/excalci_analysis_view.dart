import 'package:excalci/app_theme.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:excalci/services/cloud/firebase_cloud_storage.dart';
import 'package:excalci/services/auth/auth_service.dart';

import 'dart:developer' as dev show log;

class excalciAnalysisView extends StatefulWidget {
  const excalciAnalysisView({super.key});

  @override
  State<excalciAnalysisView> createState() => _excalciAnalysisViewState();
}

class _excalciAnalysisViewState extends State<excalciAnalysisView> {
  late final FirebaseCloudStorage _cloudService;
  String ownerUserId=AuthService.firebase().currentUser!.id!;

  @override
  void initState() {
    _cloudService=FirebaseCloudStorage();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
  //colour list for each category

  List<Color> colorList = [
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.teal,
    Colors.pink,
    // Colors.lime,
    Colors.amber,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.cyan,
    Colors.indigo,

  ];
  colorList.shuffle();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          Column(
            children: [
              StreamBuilder<Map<String,double>>(
                stream:  _cloudService.allExpensesInCategories(ownerUserId: ownerUserId),
                 builder:
                  (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('An error occurred!'));
                    }
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      //sum all percentages
                      double sum = 0;
                      data!.forEach((key, value) {
                        sum += value;
                      });
                      dev.log(sum.toString());
                      //if sum is 0, then no data is available
                      if (sum == 0) {
                        return const Center(child: Text('No data available!'));
                      }
                      if(sum<=100.0){
                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 20),
                            Text("Monthly Analysis:",style: AppTheme.title,),
                            Card.outlined(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: PieChart(
                                  dataMap: data,
                                  chartType: ChartType.ring,
                                  baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                                  colorList: colorList,
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValuesInPercentage: true,
                                  ),
                                  totalValue: 100,
                                  legendOptions: 
                                    LegendOptions(
                                      showLegendsInRow: false,
                                      legendPosition: LegendPosition.bottom,
                                      showLegends: true,
                                      legendTextStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: AppTheme.primary,
                                      ),
                                    )
                                ),
                              ),
            
                            ),
                            
                          ],
                        );
                      }
                      else{
                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 20),
                            Text("Expenditure Analysis:",style: AppTheme.title,),
                            Card.outlined(
                              
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    PieChart(
                                      dataMap: data,
                                      chartType: ChartType.ring,
                                      baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                                      colorList: colorList,
                                      chartValuesOptions: const ChartValuesOptions(
                                        showChartValuesInPercentage: true,
                                      ),
                                      totalValue: sum,
                                      legendOptions: 
                                        LegendOptions(
                                          showLegendsInRow: false,
                                          legendPosition: LegendPosition.bottom,
                                          showLegends: true,
                                          legendTextStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text("Total expenditure execeeds your budget",style: AppTheme.expense,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
              ),
          
              const SizedBox(height: 20),
              StreamBuilder<Map<String,double>>(
                stream:  _cloudService.allIncomesInCategories(ownerUserId: ownerUserId),
                 builder:
                  (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('An error occurred!'));
                    }
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      //sum all percentages
                      double sum = 0;
                      data!.forEach((key, value) {
                        sum += value;
                      });
                      dev.log(sum.toString());
                      //if sum is 0, then no data is available
                      if (sum == 0) {
                        return const Center(child: Text('No data available!'));
                      }
                      if(sum<=100.0){
                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 20),
                            Text("Income Analysis:",style: AppTheme.title,),
                            Card.outlined(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: PieChart(
                                  dataMap: data,
                                  chartType: ChartType.ring,
                                  baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                                  colorList: colorList,
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValuesInPercentage: true,
                                  ),
                                  totalValue: 100,
                                  legendOptions: 
                                    LegendOptions(
                                      showLegendsInRow: false,
                                      legendPosition: LegendPosition.bottom,
                                      showLegends: true,
                                      legendTextStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: AppTheme.primary,
                                      ),
                                    )
                                ),
                              ),
            
                            ),
                            
                          ],
                        );
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
              ),
              

              StreamBuilder<Iterable<Map<String,double>>>(
                stream: _cloudService.cashBank(ownerUserId: ownerUserId),
                builder: 
                  (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('An error occurred!'));
                    }
                    if (snapshot.hasData) {
                      final data = snapshot.data;

                      // return Center(child: Text("$data"),);

                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 20),
                          Text("Payment modes:",style: AppTheme.title,),
                          Card.outlined(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: 
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Income",
                                          style: AppTheme.subtitle,
                                          ),
                                        Text("Expense",
                                          style: AppTheme.subtitle,
                                          ),
                                        
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("₹${data.last['Cash']}",
                                          style: AppTheme.income,
                                          ),
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: ListTile(
                                            title: Image.asset(
                                              'assets/images/money.png',
                                              width: 50,
                                              height: 50,
                                            ),
                                            subtitle:  Text("   Cash",
                                              style: AppTheme.desc,
                                            ),
                                          ),
                                        ),
                                        Text("₹${data.first['Cash']}",
                                          style: AppTheme.expense,
                                          ),
                                        
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("₹${data.last['Bank']}",
                                          style: AppTheme.income,
                                          ),
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: ListTile(
                                            title: const Icon(Icons.account_balance,
                                              size: 40,
                                            ),
                                            subtitle:  Text("   Bank",
                                              style: AppTheme.desc,
                                            ),
                                          ),
                                        ),
                                        Text("₹${data.first['Bank']}",
                                          style: AppTheme.expense,
                                          ),
                                        
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    //divider
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("₹${data.last['Total']}",
                                          style: AppTheme.income,
                                          ),
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: ListTile(
                                            title: Image.asset(
                                              'assets/images/bill.png',
                                              width: 50,
                                              height: 50,
                                              color: Colors.white,
                                            ),
                                            subtitle:  Text("   Total",
                                              style: AppTheme.desc,
                                            ),
                                          ),
                                        ),
                                        Text("₹${data.first['Total']}",
                                          style: AppTheme.expense,
                                          ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
              ),


              Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      StreamBuilder<double>(
                        stream: _cloudService.averageValue(ownerUserId: ownerUserId),
                        builder: 
                          (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(child: Text('An error occurred!'));
                            }
                            if (snapshot.hasData) {
                              final data = snapshot.data.floor();
                              
                              if(data==0){
                                return const Center(child: Text('No data available!'));
                              }
                              else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Average transaction value:",
                                      style: AppTheme.subtitle,
                                    ),
                                    Text("₹$data",
                                      style: AppTheme.button,
                                    ),
                                  ],
                                );
                              }
                            }
                            return const Center(child: CircularProgressIndicator());
                          }
                      ),

                      StreamBuilder<int>(
                      stream: _cloudService.countExpenses(ownerUserId: ownerUserId),
                      builder: 
                        (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(child: Text('An error occurred!'));
                          }
                          if (snapshot.hasData) {
                            final data = snapshot.data;

                            return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Transactions made:",
                                      style: AppTheme.subtitle,
                                    ),
                                    Text("$data",
                                      style: AppTheme.button,
                                    ),
                                  ],
                                );
                          }
                          return const Center(child: CircularProgressIndicator());
                        }
                      ),
                      
                      StreamBuilder<int>(
                      stream: _cloudService.transactionsOver1000(ownerUserId: ownerUserId),
                      builder: 
                        (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(child: Text('An error occurred!'));
                          }
                          if (snapshot.hasData) {
                            final data = snapshot.data;

                            return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("    Transactions over ₹1000:",
                                      style: AppTheme.subtitle,
                                    ),
                                    Text("$data",
                                      style: AppTheme.success,
                                    ),
                                  ],
                                );
                          }
                          return const Center(child: CircularProgressIndicator());
                        }
                      ),
                      
                      StreamBuilder<int>(
                      stream: _cloudService.transactionsInBank(ownerUserId: ownerUserId),
                      builder: 
                        (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(child: Text('An error occurred!'));
                          }
                          if (snapshot.hasData) {
                            final data = snapshot.data;
                      
                            return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("    Transactions using Bank:",
                                      style: AppTheme.subtitle,
                                    ),
                                    Text("$data",
                                      style: AppTheme.success,
                                    ),
                                  ],
                                );
                          }
                          return const Center(child: CircularProgressIndicator());
                        }
                      ),
                      
                      StreamBuilder<int>(
                      stream: _cloudService.transactionsInCash(ownerUserId: ownerUserId),
                      builder: 
                        (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(child: Text('An error occurred!'));
                          }
                          if (snapshot.hasData) {
                            final data = snapshot.data;
                      
                            return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("    Transactions using Cash:",
                                      style: AppTheme.subtitle,
                                    ),
                                    Text("$data",
                                      style: AppTheme.success,
                                    ),
                                  ],
                                );
                          }
                          return const Center(child: CircularProgressIndicator());
                        }
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80,),
        
            ],
          ),
        ],
      ),
    );
  }
  
}