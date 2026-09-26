import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vizi_dasht/common/const.dart';
import 'package:vizi_dasht/screens/dashboard/finance.dart';
import 'package:vizi_dasht/screens/products/best_products_list.dart';
import 'package:vizi_dasht/widgets/button.dart';
import 'package:vizi_dasht/widgets/custom_shadow_box.dart';
import 'package:vizi_dasht/widgets/deliveri_message.dart';
import 'package:vizi_dasht/widgets/factor.dart';
import 'package:vizi_dasht/widgets/loading/dashboard.dart';
import '../../widgets/circular_indicator.dart';
import '../../widgets/decorated_container.dart';
import '../../widgets/dvider.dart';
import '../../widgets/title.dart';
import 'amazin_product.dart';
import 'bloc/home_bloc.dart';
import 'charts/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    List<int> dailySales = [10, 15, 8, 12, 18, 20, 1];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/ViziDasht-Logo.png', width: 150),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => HomeBloc()..add(HomeStarted()),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return DashboardShimmer().marginAll(Constants.primaryPadding);
              } else
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    DeliveriMessage()
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    Euphoria(themeData: themeData)
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    AmazingProductMng()
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    FinanceRep(themeData: themeData)
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    SalesRep(themeData: themeData)
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    LowStockList(),
                    //
                    WeeklyOrdersRep(dailySales: dailySales)
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    ProductViewRep()
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    MostViewProductRep()
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    MonthlyOrdersRep()
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    BestSalesProducts()
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                    //
                    AllOrdersRep()
                        .marginSymmetric(horizontal: Constants.primaryPadding),
                  ],
                );
            },
          ),
        ),
      ),
    );
  }
}

class AllOrdersRep extends StatelessWidget {
  const AllOrdersRep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTitle(
          title: 'تعداد کل سفارشات',
          isBottomPadding: false,
        ),
        OrdersPieChart(
          totalOrders: 50,
          deliveredOrders: 39,
          undeliveredOrders: 11,
        ),
      ],
    );
  }
}

class BestSalesProducts extends StatelessWidget {
  const BestSalesProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTitle(
          title: 'پرفروش ترین محصولات',
          isBottomPadding: false,
        ),
        BestProductsList(),
        //? Divider
        MyDivider(),
      ],
    );
  }
}

class MonthlyOrdersRep extends StatelessWidget {
  const MonthlyOrdersRep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTitle(title: 'تعداد سفارش ماهانه'),
        CustomShadowBox(
          child: AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 50,
                      showTitles: true,
                      getTitlesWidget: monthTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(fontSize: 14);
                        return Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Text(
                            value.toInt().toString(),
                            style: style,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(width: 1),
                    left: BorderSide(width: 1),
                  ),
                ),
                gridData: FlGridData(show: false),
                barGroups: getBarChartMonthlyReport(context),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}',
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        //?
        MyDivider(),
      ],
    );
  }
}

class WeeklyOrdersRep extends StatelessWidget {
  const WeeklyOrdersRep({
    super.key,
    required this.dailySales,
  });

  final List<int> dailySales;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTitle(title: 'تعداد سفارش هفتگی'),
        CustomShadowBox(
          child: AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true, // نمایش مقادیر فروش در بالای نمودار
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        // مقدار فروش را از بار دیتا می‌گیریم نه از اندیس روزها
                        const style = TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold);
                        int index = value.toInt() - 1; // ایندکس مقادیر فروش
                        if (index >= 0 && index < dailySales.length) {
                          return Text(
                            dailySales[index].toString(), // نمایش مقدار فروش
                            style: style,
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return Container(); // برای جلوگیری از ارور در صورت نادرستی مقدار
                        }
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 50,
                      showTitles: true, // نمایش عناوین روزهای هفته
                      getTitlesWidget:
                          weekTitles, // تابع برای نمایش روزهای هفته
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false, reservedSize: 40),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border(left: BorderSide(width: 1)),
                ),
                gridData: FlGridData(show: false),
                barGroups: getBarChartWeeklyReport(context),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}',
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        MyDivider(),
      ],
    );
  }
}

class MostViewProductRep extends StatelessWidget {
  const MostViewProductRep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTitle(
              title: 'پربازدیدترین محصولات',
            ),
          ],
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                buildTopVisitedProductCard(
                  context,
                  name: 'تسمه تایم سمند',
                  visits: '۲۳۴۵',
                  rank: 1,
                  image: 'assets/images/6260100320116(1).jpg',
                ),
                buildTopVisitedProductCard(
                  context,
                  name: 'کمک فنر جلو پژو 206',
                  visits: '۱۸۲۰',
                  rank: 2,
                  image: 'assets/images/1509547706.jpg',
                ),
                buildTopVisitedProductCard(
                  context,
                  name: 'وایر تقویتی پژو 206',
                  visits: '۱۶۰۵',
                  rank: 3,
                  image: 'assets/images/1526890419.jpg',
                ),
              ],
            )),
        //divider
        MyDivider(),
      ],
    );
  }
}

Widget buildTopVisitedProductCard(
  BuildContext context, {
  required String name,
  required String visits,
  required int rank,
  required String image,
}) {
  final List<Map<String, dynamic>> rankStyles = [
    {
      'gradient': Constants.yellowGradientColors,
      'badge': 'رتبه اول',
    },
    {
      'gradient': Constants.silverGradientColors,
      'badge': 'رتبه دوم',
    },
    {
      'gradient': Constants.brownGradientColors,
      'badge': 'رتبه سوم',
    },
  ];

  final style = rankStyles[(rank >= 1 && rank <= 3) ? rank - 1 : 0];

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      gradient: Constants.myGradient(List<Color>.from(style['gradient'])),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              // تصویر محصول
              Hero(
                tag: 'top-visited-$name',
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // اطلاعات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.remove_red_eye,
                            size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '$visits بازدید',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // رتبه
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: List<Color>.from(style['gradient']),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  style['badge'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

class ProductViewRep extends StatelessWidget {
  const ProductViewRep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTitle(title: 'آمار بازدید محصولات'),
        Row(
          children: [
            Expanded(
              child: buildModernStatCard(
                context,
                title: 'بازدید امروز',
                value: '1,245',
                unit: 'بازدید',
                icon: Icons.trending_up,
                gradient: Constants.blueGradientColors,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: buildModernStatCard(
                context,
                title: 'بازدید ماهانه',
                value: '32,856',
                unit: 'بازدید',
                icon: Icons.bar_chart,
                gradient: Constants.greenGradientColors,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        buildModernStatCard(
          context,
          title: 'بازدید کل',
          value: '245,782',
          unit: 'بازدید',
          icon: Icons.stacked_line_chart,
          gradient: Constants.redGradientColors,
          fullWidth: true,
        ),
        //?Divider
        MyDivider(),
      ],
    );
  }
}

Widget buildModernStatCard(
  BuildContext context, {
  required String title,
  required String value,
  required String unit,
  required IconData icon,
  required List<Color> gradient,
  bool fullWidth = false,
}) {
  return Container(
    width: fullWidth ? double.infinity : null,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: Constants.myGradient(gradient),
      boxShadow: [
        BoxShadow(
          color: gradient.last.withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
            Icon(icon, color: Colors.white, size: 18),
          ],
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

class LowStockList extends StatelessWidget {
  const LowStockList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTitle(
              title: 'موجودی در حد بحرانی',
              isBottomPadding: false,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 20),
              onPressed: () {},
            ),
          ],
        ).marginSymmetric(horizontal: Constants.primaryPadding),
        SizedBox(height: 8),
        SizedBox(
          height: 84,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            //  padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return buildLowStockItem(
                context,
                name: 'کمک فنر جلو پژو 206',
                stock: 1,
                image: 'assets/images/1509547706.jpg',
              ).marginOnly(
                  right: index == 0 ? 16 : 0, left: 16, top: 8, bottom: 8);
            },
          ),
        ),
        MyDivider(),
      ],
    );
  }
}

Widget buildLowStockItem(
  BuildContext context, {
  required String name,
  required int stock,
  required String image,
}) {
  final isCritical = stock <= 2;
  final colors = isCritical
      ? [Color(0xFFFF4D4D), Color(0xFFF00000)]
      : [Color(0xFFFFB347), Color(0xFFFF8C00)];

  return Container(
    width: 200, // عرض ثابت برای یکپارچگی

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: colors.last.withOpacity(0.15),
          blurRadius: 6,
          offset: Offset(2, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          HapticFeedback.lightImpact();
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // تصویر محصول
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),

              // اطلاعات محصول
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$stock عدد باقی مانده',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class SalesRep extends StatelessWidget {
  const SalesRep({
    super.key,
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTitle(
          title: 'گزارش فروش امروز',
          subTitle: 'تا 15:45:12',
          isBottomPadding: false,
        ).marginOnly(bottom: Constants.primaryPadding),
        MyDecoratedContainer(
          gradient: Constants.greenGradientColors,
          child: Column(
            children: [
              FactorItem(
                title: 'تعداد سفارش:',
                secTitle: '73',
              ),
              FactorItem(
                title: 'مبلغ فروش:',
                secTitle: '192,582,000 تومان',
              ),
            ],
          ),
        ),
        //?Divider
        MyDivider(),
      ],
    );
  }
}

class FinanceRep extends StatelessWidget {
  const FinanceRep({
    super.key,
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTitle(title: 'گزارش مالی', isBottomPadding: false),
            MyTextButton(
              title: 'جزئیات',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: themeData.primaryColor),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FinanceScreen(),
                ));
              },
            )
          ],
        ).marginOnly(bottom: Constants.primaryPadding - 2),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FinanceScreen(),
            ));
          },
          child: MyDecoratedContainer(
            gradient: Constants.blueGradientColors,
            child: Column(
              children: [
                FactorItem(
                  title: 'درآمد کل:',
                  secTitle: '150,000,000 تومان',
                ),
                FactorItem(
                  title: 'واریز نشده:',
                  secTitle: '18,000,000 تومان',
                ),
              ],
            ),
          ),
        ),

        //?Divider
        MyDivider(),
      ],
    );
  }
}

class AmazingProductMng extends StatelessWidget {
  const AmazingProductMng({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTitle(title: 'مدیریت پیشنهادات شگفت‌انگیز'),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAmazingProductScreen(),
                ));
          },
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: Constants.myGradient(Constants.pinkGradientColors),
              boxShadow: [
                BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: Offset(0, 5))
              ],
            ),
            child: Stack(
              children: [
                // افکت‌های دکوراتیو
                Positioned(
                  right: -15,
                  top: -15,
                  child: Icon(Icons.star,
                      size: 80, color: Colors.white.withOpacity(0.2)),
                ),
                Positioned(
                  bottom: -20,
                  left: -20,
                  child: Icon(Icons.bolt,
                      size: 100, color: Colors.white.withOpacity(0.1)),
                ),

                // محتوای اصلی کارت
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'مدیریت محصولات ویژه',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '۳ محصول فعال',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      // دکمه CTA
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //?Divider
        MyDivider(),
      ],
    );
  }
}

class Euphoria extends StatelessWidget {
  const Euphoria({
    super.key,
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTitle(title: 'میزان رضایت', isBottomPadding: false),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: '88% ',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'از 16 مرسوله',
                  style: TextStyle(
                      wordSpacing: -3,
                      fontSize: 11,
                      color: themeData.colorScheme.secondary)),
            ])),
          ],
        ),
        SizedBox(height: Constants.primaryPadding),

        RatingSection(
          withoutReturn: 0.98, // 100%
          withoutCancel: 0.70, // 100%
          onTimeDelivery: 0.35, // 100%
        ),
        //?Divider
        MyDivider(),
      ],
    );
  }
}

List<BarChartGroupData> getBarChartMonthlyReport(BuildContext context) {
  List<double> monthlySales = [10, 15, 8, 12, 18, 20, 25, 30, 17, 14, 19, 22];

  return List.generate(monthlySales.length, (index) {
    return BarChartGroupData(
      x: index + 1,
      barRods: [
        BarChartRodData(
          toY: monthlySales[index],
          gradient: Constants.myGradient(Constants.yellowGradientColors),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
      ],
    );
  });
}

List<BarChartGroupData> getBarChartWeeklyReport(BuildContext context) {
  List<int> dailySales = [10, 15, 8, 12, 18, 20, 1];
  return List.generate(dailySales.length, (index) {
    return BarChartGroupData(
      x: index + 1,
      barRods: [
        BarChartRodData(
          width: 20,
          toY: dailySales[index].toDouble(),
          gradient: Constants.myGradient(Constants.blueGradientColors),
          borderRadius: Constants.primaryRadius,
        ),
      ],
    );
  });
}

Widget weekTitles(double value, TitleMeta meta) {
  String text;
  switch (value.toInt()) {
    case 1:
      text = 'شنبه';
      break;
    case 2:
      text = 'یکشنبه';
      break;
    case 3:
      text = 'دوشنبه';
      break;
    case 4:
      text = 'سه شنبه';
      break;
    case 5:
      text = 'چهارشنبه';
      break;
    case 6:
      text = 'پنجشنبه';
      break;
    case 7:
      text = 'جمعه';
      break;
    default:
      text = '';
      break;
  }

  // Apply padding and slight rotation to avoid overlap
  return SideTitleWidget(
    axisSide: meta.axisSide,
    angle: 6,
    space: 2,
    child: Container(
      padding: const EdgeInsets.only(top: 10, right: 8),
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          wordSpacing: -2,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    ),
  );
}

Widget monthTitles(double value, TitleMeta meta) {
  String text;
  switch (value.toInt()) {
    case 1:
      text = 'فروردین';
      break;
    case 2:
      text = 'اردیبهشت';
      break;
    case 3:
      text = 'خرداد';
      break;
    case 4:
      text = 'تیر';
      break;
    case 5:
      text = 'مرداد';
      break;
    case 6:
      text = 'شهریور';
      break;
    case 7:
      text = 'مهر';
      break;
    case 8:
      text = 'آبان';
      break;
    case 9:
      text = 'آذر';
      break;
    case 10:
      text = 'دی';
      break;
    case 11:
      text = 'بهمن';
      break;
    case 12:
      text = 'اسفند';
      break;
    default:
      text = '';
      break;
  }

  // Apply padding and slight rotation to avoid overlap
  return SideTitleWidget(
    axisSide: meta.axisSide,
    angle: -70,
    space: 0,
    child: Container(
      padding: const EdgeInsets.only(top: 10, right: 8),
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    ),
  );
}

class RatingSection extends StatelessWidget {
  final double withoutReturn;
  final double withoutCancel;
  final double onTimeDelivery;

  RatingSection({
    required this.withoutReturn,
    required this.withoutCancel,
    required this.onTimeDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ProfileCircularIndicator(title: 'بدون برگشتی', amount: withoutReturn),
        ProfileCircularIndicator(title: 'بدون لغو', amount: withoutCancel),
        ProfileCircularIndicator(title: 'ارسال بموقع', amount: onTimeDelivery),
      ],
    );
  }
}
