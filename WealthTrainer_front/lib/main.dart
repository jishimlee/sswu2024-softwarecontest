import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'company.dart';
import 'stockprovider.dart';

void main() {
  runApp(wealthtrainer());
}

class wealthtrainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StockProvider(),
      child: MaterialApp(
        title: 'Wealth Trainer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF0056A0), // 주요 색상: 진한 블루
            primary: Color(0xFF0056A0), // 앱의 기본 색상
            secondary: Color.fromARGB(255, 134, 176, 222), // 강조 색상: 밝은 블루
            onPrimary: Colors.white, // 기본 색상의 텍스트 색상
            onSecondary: Colors.white, // 강조 색상의 텍스트 색상
            surface: Colors.white,
            onSurface: Colors.black54,
            error: Color(0xFFB00020),
            onError: Colors.white,
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontFamily: 'Sunflower',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Sunflower',
              fontSize: 16,
              color: Colors.black54,
            ),
            labelLarge: TextStyle(
              fontFamily: 'Sunflower',
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            color: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF007BFF), // 버튼 배경 색상
              foregroundColor: Colors.white, // 버튼 텍스트 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              elevation: 4,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black54, // 아이콘 색상
            size: 24, // 아이콘 크기
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF0056A0), // 앱바 배경 색상
            titleTextStyle: TextStyle(
              fontFamily: 'Sunflower',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {'/': (context) => CompanyListPage(),
                '/second': (context) => FirstResultsPage(),
                '/third': (context) => CompanyListSecondPage(),
                '/fourth': (context) => SecondResultsPage(),
                '/fifth': (context) => ResultsPage()
        },
      ),
    );
  }
}

class CompanyListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompanyListPageState();
  }
}
class _CompanyListPageState extends State<CompanyListPage> {
  final List<ComData> companyData = [
    ComData(companyName: 'Company A', price: 100, previousPrice: 150, description: 'Company A는 ...'),
    ComData(companyName: 'Company B', price: 150, previousPrice: 120, description: 'Company B는 ...'),
    ComData(companyName: 'Company C', price: 80, previousPrice: 100, description: 'Company C는 ...'),
    ComData(companyName: 'Company D', price: 120, previousPrice: 80, description: 'Company D는 ...'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wealth Trainer'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1주차', style: Theme.of(context).textTheme.labelLarge),
                Text('보유 금액: 100,000원', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: companyData.length,
        itemBuilder: (context, index) {
          final data = companyData[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                data.companyName, 
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1주당 가격: ${data.price}', style: Theme.of(context).textTheme.bodyLarge),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '전날 대비 가격 변동: ',
                          style: Theme.of(context).textTheme.bodyLarge
                          ),
                        TextSpan(
                          text: '${data.change > 0 ? '+' : ''}${data.change.toStringAsFixed(2)} (${data.changePercentage.toStringAsFixed(2)}%)',
                          style: TextStyle(
                            color: data.change >= 0 ? Colors.red : Colors.blue,
                            fontFamily: 'Sunflower',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () => _showCompanyDetails(context, data),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/second');
        },
        label: Text('결과 확인'),
        icon: Icon(Icons.navigate_next),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }


  void _showCompanyDetails(BuildContext context, ComData data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data.companyName),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(data.description),
              SizedBox(height: 20),
              //회사 로고 등 추가 가능
              Center(
                child: ElevatedButton(
                  onPressed: () => _showPurchaseDialog(context),
                  child: Text('매수'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) => StockPurchaseDialog(),
    );
  }
}

class StockPurchaseDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);

    return AlertDialog(
      content: Column(
        mainAxisSize:  MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton( 
                icon: Icon(Icons.remove),
                onPressed: () => stockProvider.decrementQuantity(),
              ),
              Text('${stockProvider.quantity}', style: TextStyle(fontSize: 24)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => stockProvider.incrementQuantity(),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('금액: ${stockProvider.totalPrice.toStringAsFixed(2)}원', style: TextStyle(fontSize: 18)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('취소')
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              await stockProvider.purchase();
              Navigator.of(context).pop(); // 다이얼로그 닫기
            } catch (error) {
              // 오류 메시지 표시
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('오류'),
                  content: Text('구매를 완료할 수 없습니다. 다시 시도해주세요.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Text('구매')
        ),
      ],
    );
  }
}


class FirstResultsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // 가상 데이터: 주식 변동 결과
    final List<Map<String, dynamic>> stockData = [
      {'companyName': 'Company A', 'price': 100, 'previousPrice': 95},
      {'companyName': 'Company B', 'price': 150, 'previousPrice': 155},
      {'companyName': 'Company C', 'price': 80, 'previousPrice': 78},
      {'companyName': 'Company D', 'price': 120, 'previousPrice': 113},
    ];

    // 변동 가격과 상승률 계산
    List<DataRow> rows = stockData.map((data) {
      final double change = data['price'] - data['previousPrice'];
      final double changePercentage = (change / data['previousPrice']) * 100;
      final TextStyle changeTextStyle = change > 0
        ? TextStyle(color: Colors.red)
        : TextStyle(color: Colors.blue);

      return DataRow(
        cells: [
          DataCell(Text(data['companyName'])),
          DataCell(Text('${data['price']}원')),
          DataCell(Text(
            '${change > 0 ? '+' : ''}${change.toStringAsFixed(2)} (${changePercentage.toStringAsFixed(2)}%)',
            style: changeTextStyle,
          )),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Wealth Trainer'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1주차', style: Theme.of(context).textTheme.labelLarge),
                Text('보유 금액: 100,000원', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주식 변동 결과',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Sunflower')
            ),
            SizedBox(height: 16),
            // 결과 설명 추가
            Text(
              '이번 주 주식 변동 결과를 살펴보겠습니다. 각 회사의 주식 가격과 변동 사항을 '
              '아래 표에서 확인할 수 있습니다. '
              '전염병의 확산으로 인해 제약회사의 주식이 상승세를 보였습니다. 전염병 치료제를 개발하는 제약회사들이 주목받고 있습니다. '
              '또한, 전염병으로 인해 사람들이 비디오 콘텐츠 소비를 증가시키면서 비디오 커뮤니케이션 관련 주식이 상승 하였습니다. '
              '반면, 항공사 주식은 전염병의 여파로 인해 하락세를 보였습니다. 여행 제한과 수요 감소가 주요 원인으로 작용했습니다. '
              '마지막으로, 예상보다 낮은 GDP 성장률로 인해 불확실성이 증가하여 GE 주가는 하락하였습니다',
              style: TextStyle(fontSize: 16, fontFamily:'Sunflower'),
            ),
            SizedBox(height: 16),
            // 데이터 테이블
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16.0,
                headingRowColor: WidgetStateColor.resolveWith((states) => Theme.of(context).colorScheme.secondary),
                columns: [
                  DataColumn(label: Container(width: 150, child: Text('회사', style: TextStyle(fontFamily:'Sunflower')))),
                  DataColumn(label: Container(width: 120, child: Text('가격', style: TextStyle(fontFamily: 'Sunflower')))),
                  DataColumn(label: Container(width: 120, child: Text('변동', style: TextStyle(fontFamily: 'Sunflower')))),
                ],
                rows: rows,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/third');
        },
        label: Text('다음 주차로'),
        icon: Icon(Icons.navigate_next),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class CompanyListSecondPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CompanyListSecondPage();
  }
}
class _CompanyListSecondPage extends State<CompanyListSecondPage> {
  final List<ComData> companyData = [
    ComData(companyName: 'Company A', price: 100, previousPrice: 80, description: 'Company A는 ...'),
    ComData(companyName: 'Company B', price: 150, previousPrice: 190, description: 'Company B는 ...'),
    ComData(companyName: 'Company C', price: 80, previousPrice: 200, description: 'Company C는 ...'),
    ComData(companyName: 'Company D', price: 120, previousPrice: 70, description: 'Company D는 ...'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wealth Trainer'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('주차: 2주차', style: Theme.of(context).textTheme.labelLarge),
                Text('보유 금액: 200,000원', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: companyData.length,
          itemBuilder: (context, index) {
            final data = companyData[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  data.companyName,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1주당 가격: ${data.price}', style: Theme.of(context).textTheme.bodyLarge),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '전날 대비 가격 변동: ',
                          style: Theme.of(context).textTheme.bodyLarge
                          ),
                        TextSpan(
                          text: '${data.change > 0 ? '+' : ''}${data.change.toStringAsFixed(2)} (${data.changePercentage.toStringAsFixed(2)}%)',
                          style: TextStyle(
                            color: data.change >= 0 ? Colors.red : Colors.blue,
                            fontFamily: 'Sunflower',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
                onTap: () => _showCompanyDetailsSecond(context, companyData[index]),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed('/fourth');
          },
          label: Text('결과 확인'),
          icon: Icon(Icons.forward),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
  }

  void _showCompanyDetailsSecond(BuildContext context, ComData data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data.companyName),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(data.description),
              SizedBox(height: 20),
              //회사 로고 등 추가 가능
              Center(
                child: ElevatedButton(
                  onPressed: () => _showPurchaseDialogSecond(context),
                  child: Text('매수'),
                ),
              ),
            ],            
          ),
        );
      },
    );
  }

  void _showPurchaseDialogSecond(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) => StockPurchaseDialogSecond(),
    );
  }  
}
class StockPurchaseDialogSecond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);

    return AlertDialog(
      content: Column(
        mainAxisSize:  MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton( 
                icon: Icon(Icons.remove),
                onPressed: () => stockProvider.decrementQuantity(),
              ),
              Text('${stockProvider.quantity}', style: TextStyle(fontSize: 24)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => stockProvider.incrementQuantity(),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('금액: ${stockProvider.totalPrice.toStringAsFixed(2)}원', style: TextStyle(fontSize: 18)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('취소')
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              await stockProvider.purchase();
              Navigator.of(context).pop(); // 다이얼로그 닫기
            } catch (error) {
              // 오류 메시지 표시
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('오류'),
                  content: Text('구매를 완료할 수 없습니다. 다시 시도해주세요.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Text('구매')
        ),
      ],
    );
  }
}

class SecondResultsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // 가상 데이터: 주식 변동 결과
    final List<Map<String, dynamic>> stockDataSecond = [
      {'companyName': 'Company A', 'price': 100, 'previousPrice': 95},
      {'companyName': 'Company B', 'price': 150, 'previousPrice': 155},
      {'companyName': 'Company C', 'price': 80, 'previousPrice': 78},
      {'companyName': 'Company D', 'price': 120, 'previousPrice': 113},
    ];

    // 변동 가격과 상승률 계산
    List<DataRow> rowssecond = stockDataSecond.map((data) {
      final double change = data['price'] - data['previousPrice'];
      final double changePercentage = (change / data['previousPrice']) * 100;
      final TextStyle changeTextStyle = change > 0
        ? TextStyle(color: Colors.red)
        : TextStyle(color: Colors.blue);

      return DataRow(
        cells: [
          DataCell(Text(data['companyName'])),
          DataCell(Text('${data['price']}원')),
          DataCell(Text(
            '${change > 0 ? '+' : ''}${change.toStringAsFixed(2)} (${changePercentage.toStringAsFixed(2)}%)',
            style: changeTextStyle
          ),),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Wealth Trainer'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('주차: 2주차', style: Theme.of(context).textTheme.labelLarge),
                Text('보유 금액: 200,000원', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주식 변동 결과',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Sunflower'),
            ),
            SizedBox(height: 16),
            // 결과 설명 추가
            Text(
              '이번 주 주식 변동 결과를 살펴보겠습니다. 각 회사의 주식 가격과 변동 사항을 '
              '아래 표에서 확인할 수 있습니다. '
              '전염병의 확산으로 인해 제약회사의 주식이 상승세를 보였습니다. 전염병 치료제를 개발하는 제약회사들이 주목받고 있습니다. '
              '또한, 전염병으로 인해 사람들이 비디오 콘텐츠 소비를 증가시키면서 비디오 커뮤니케이션 관련 주식이 상승 하였습니다. '
              '반면, 항공사 주식은 전염병의 여파로 인해 하락세를 보였습니다. 여행 제한과 수요 감소가 주요 원인으로 작용했습니다. '
              '마지막으로, 예상보다 낮은 GDP 성장률로 인해 불확실성이 증가하여 GE 주가는 하락하였습니다',
              style: TextStyle(fontSize: 16, fontFamily: 'Sunflower'),
            ),
            SizedBox(height: 16),
            // 데이터 테이블
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16.0,
                headingRowColor: WidgetStateColor.resolveWith((states) => Theme.of(context).colorScheme.secondary),
                columns: [
                  DataColumn(label: Container(width: 150, child: Text('회사', style: TextStyle(fontFamily: 'Sunflower')))),
                  DataColumn(label: Container(width: 120, child: Text('가격', style: TextStyle(fontFamily: 'Sunflower')))),
                  DataColumn(label: Container(width: 120, child: Text('변동', style: TextStyle(fontFamily: 'Sunflower')))),
                ],
                rows: rowssecond,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/fifth');
        },
        label: Text('최종 결과 확인'),
        icon: Icon(Icons.navigate_next),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 가상 데이터: 주차 별 주식 데이터
    final List<Map<String, dynamic>> stockData = [
      {
        'companyName': 'Company A',
        'week1Price': 100,
        'week1PreviousPrice': 95,
        'week1Quantity': 50,
        'week1Profit': 250,
        'week2Price': 110,
        'week2PreviousPrice': 100,
        'week2Quantity': 55,
        'week2Profit': 275,
      },
      {
        'companyName': 'Company B',
        'week1Price': 150,
        'week1PreviousPrice': 155,
        'week1Quantity': 20,
        'week1Profit': -100,
        'week2Price': 140,
        'week2PreviousPrice': 150,
        'week2Quantity': 25,
        'week2Profit': -125,
      },
      {
        'companyName': 'Company C',
        'week1Price': 80,
        'week1PreviousPrice': 78,
        'week1Quantity': 30,
        'week1Profit': 60,
        'week2Price': 85,
        'week2PreviousPrice': 80,
        'week2Quantity': 35,
        'week2Profit': 75,
      },
      {
        'companyName': 'Company D',
        'week1Price': 120,
        'week1PreviousPrice': 113,
        'week1Quantity': 40,
        'week1Profit': 280,
        'week2Price': 130,
        'week2PreviousPrice': 120,
        'week2Quantity': 45,
        'week2Profit': 300,
      },
    ];

    // 주차 별 수익 계산
    List<DataRow> profitRows = stockData.map((data) {
      final double totalProfit = data['week1Profit'] + data['week2Profit'];

      return DataRow(
        cells: [
          DataCell(Text(data['companyName'])),
          DataCell(Text(
            '${data['week1Profit'] >= 0 ? '+' : ''}\$${data['week1Profit']}',
            style: TextStyle(
              color: data['week1Profit'] >= 0 ? Colors.blue : Colors.red,
            ),
          )),
          DataCell(Text(
            '${data['week2Profit'] >= 0 ? '+' : ''}\$${data['week2Profit']}',
            style: TextStyle(
              color: data['week2Profit'] >= 0 ? Colors.blue : Colors.red,
            ),
          )),
          DataCell(Text(
            '${totalProfit >= 0 ? '+' : ''}\$${totalProfit}',
            style: TextStyle(
              color: totalProfit >= 0 ? Colors.blue : Colors.red,
            ),
          )),
        ],
      );
    }).toList();

    // 최종 합계 계산
    final double totalWeek1Profit = stockData.fold(0, (sum, data) => sum + data['week1Profit']);
    final double totalWeek2Profit = stockData.fold(0, (sum, data) => sum + data['week2Profit']);
    final double grandTotalProfit = totalWeek1Profit + totalWeek2Profit;

    // 최종 합계 행 추가
    final List<DataRow> profitRowsWithTotal = [
      ...profitRows,
      DataRow(
        cells: [
          DataCell(Text('합계', style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(
            '${totalWeek1Profit >= 0 ? '+' : ''}\$${totalWeek1Profit}',
            style: TextStyle(
              color: totalWeek1Profit >= 0 ? Colors.blue : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          )),
          DataCell(Text(
            '${totalWeek2Profit >= 0 ? '+' : ''}\$${totalWeek2Profit}',
            style: TextStyle(
              color: totalWeek2Profit >= 0 ? Colors.blue : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          )),
          DataCell(Text(
            '${grandTotalProfit >= 0 ? '+' : ''}\$${grandTotalProfit}',
            style: TextStyle(
              color: grandTotalProfit >= 0 ? Colors.blue : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          )),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('최종 결과', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '주식 변동',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Sunflower'),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: WidgetStateColor.resolveWith((states) => Theme.of(context).colorScheme.secondary),
                  columns: [
                    DataColumn(label: Container(width: 150, child: Text('회사', style: TextStyle(fontFamily: 'Sunflower')))),
                    DataColumn(label: Container(width: 120, child: Text('1주차', style: TextStyle(fontFamily: 'Sunflower')))),
                    DataColumn(label: Container(width: 120, child: Text('2주차', style: TextStyle(fontFamily: 'Sunflower')))),
                  ],
                  rows: stockData.map((data) {
                    final double changeWeek1 = data['week1Price'] - data['week1PreviousPrice'];
                    final double changePercentageWeek1 = (changeWeek1 / data['week1PreviousPrice']) * 100;
                    final double changeWeek2 = data['week2Price'] - data['week2PreviousPrice'];
                    final double changePercentageWeek2 = (changeWeek2 / data['week2PreviousPrice']) * 100;

                    return DataRow(
                      cells: [
                        DataCell(Container(width: 150, child: Text(data['companyName']))),
                        DataCell(Container(width: 120, child: Text('${changeWeek1 > 0 ? '+' : ''}${changeWeek1.toStringAsFixed(2)} (${changePercentageWeek1.toStringAsFixed(2)}%)', style: TextStyle(color: changeWeek1 >= 0 ? Colors.blue : Colors.red)))),
                        DataCell(Container(width: 120, child: Text('${changeWeek2 > 0 ? '+' : ''}${changeWeek2.toStringAsFixed(2)} (${changePercentageWeek2.toStringAsFixed(2)}%)', style: TextStyle(color: changeWeek2 >= 0 ? Colors.blue : Colors.red)))),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 32),
              Text(
                '매수 수량',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Sunflower'),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: WidgetStateColor.resolveWith((states) => Theme.of(context).colorScheme.secondary),
                  columns: [
                    DataColumn(label: Container(width: 150, child: Text('회사', style: TextStyle(fontFamily: 'Sunflower')))),
                    DataColumn(label: Container(width: 120, child: Text('1주차', style: TextStyle(fontFamily: 'Sunflower')))),
                    DataColumn(label: Container(width: 120, child: Text('2주차', style: TextStyle(fontFamily: 'Sunflower')))),
                  ],
                  rows: stockData.map((data) {
                    return DataRow(
                      cells: [
                        DataCell(Container(width: 150, child: Text(data['companyName']))),
                        DataCell(Container(width: 120, child: Text('${data['week1Quantity']}주'))),
                        DataCell(Container(width: 120, child: Text('${data['week2Quantity']}주'))),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 32),
              Text(
                '수익',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Sunflower'),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: WidgetStateColor.resolveWith((states) => Theme.of(context).colorScheme.secondary),
                  columns: [
                    DataColumn(label: Container(width: 130, child: Text('회사', style: TextStyle(fontFamily: 'Sunflower')))),
                    DataColumn(label: Container(width: 80, child: Text('1주차 수익', style: TextStyle(fontFamily: 'Sunflower'))), numeric: true),
                    DataColumn(label: Container(width: 80, child: Text('2주차 수익', style: TextStyle(fontFamily: 'Sunflower'))), numeric: true),
                    DataColumn(label: Container(width: 80, child: Text('최종 수익', style: TextStyle(fontFamily: 'Sunflower'))), numeric: true),
                  ],
                  rows: profitRowsWithTotal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}