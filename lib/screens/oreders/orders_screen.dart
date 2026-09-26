// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:vizi_dasht/common/const.dart';
// import 'package:vizi_dasht/screens/oreders/bloc/orders_bloc.dart';
// import 'package:vizi_dasht/screens/oreders/order_details_screen.dart';
// import 'package:vizi_dasht/widgets/loading/orders.dart';
// import '../../widgets/deliveri_message.dart';
// import '../../widgets/new_label.dart';

// class OrdersScreen extends StatelessWidget {
//   const OrdersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeData = Theme.of(context);
//     final style = TextStyle(
//       fontSize: 12,
//       fontWeight: FontWeight.bold,
//       color: themeData.colorScheme.secondary,
//     );

//     // لیست سفارشات (در حالت واقعی از بلاک یا دیتابیس می‌آید)
//     final List<Map<String, dynamic>> orders = [
//       // اگر می‌خواهید حالت خالی را تست کنید، این لیست را خالی بگذارید: []
//       {
//         'id': 1,
//         'price': '10,821,000 تومان',
//         'date': '2024/09/15',
//         'time': '12:53:12',
//         'isNew': true
//       },
//       {
//         'id': 2,
//         'price': '5,200,000 تومان',
//         'date': '2024/09/14',
//         'time': '09:12:00',
//         'isNew': false
//       },
//       // ...
//     ];

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: BlocProvider(
//         create: (context) => OrdersBloc()..add(OrdersStarted()),
//         child: BlocBuilder<OrdersBloc, OrdersState>(
//           builder: (context, state) {
//             if (state is OrdersLoading) {
//               return OrdersShimmer();
//             }

//             return Scaffold(
//               appBar: AppBar(
//                 title: Text('سفارشات'),
//                 centerTitle: true,
//                 leading: IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.history,
//                     size: 24,
//                     opticalSize: 24,
//                   ),
//                 ),
//               ),
//               body: SafeArea(
//                 child: orders.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.shopping_bag_outlined,
//                               size: 80,
//                               color: Colors.grey.shade300,
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               'سفارشی موجود نیست',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'هنوز هیچ سفارشی ثبت نشده است',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey.shade400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: orders.length + 1, // +1 برای DeliveriMessage
//                         padding: EdgeInsets.symmetric(
//                             horizontal: Constants.primaryPadding),
//                         itemBuilder: (context, index) {
//                           // نمایش پیام تحویل در ابتدای لیست
//                           if (index == 0) return DeliveriMessage();

//                           final orderIndex = index - 1;
//                           final order = orders[orderIndex];

//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 CupertinoPageRoute(
//                                   builder: (context) => OrderDetailsScreen(
//                                       orderId: order['id'] ?? orderIndex),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               margin: EdgeInsets.symmetric(
//                                   vertical: Constants.primaryPadding / 2),
//                               decoration: BoxDecoration(
//                                 borderRadius: Constants.primaryRadius,
//                                 color: themeData.colorScheme.surface,
//                                 boxShadow: Constants.primaryBoxShadow(context,
//                                     shadowColor: themeData
//                                         .colorScheme.surfaceContainerHighest
//                                         .withAlpha((0.10 * 255).toInt())),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             order['price'] ?? '',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               color: themeData
//                                                   .colorScheme.onSurface,
//                                             ),
//                                           ),
//                                           SizedBox(height: 8),
//                                           Row(
//                                             children: [
//                                               if (order['isNew'] == true)
//                                                 LabelContainer(text: 'جدید')
//                                                     .marginOnly(left: 8),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                       Column(
//                                         children: [
//                                           Text('تاریخ: ${order['date'] ?? ''}',
//                                               style: style),
//                                           SizedBox(height: 12),
//                                           Text('ساعت: ${order['time'] ?? ''}',
//                                               style: style),
//                                         ],
//                                       ),
//                                     ],
//                                   ).marginOnly(top: 16, left: 16, right: 16),
//                                   SizedBox(height: 4),
//                                   SizedBox(
//                                     height: 116,
//                                     child: ListView.builder(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 16),
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: 5,
//                                       itemBuilder: (context, itemIndex) {
//                                         return Container(
//                                           height: 84,
//                                           width: 84,
//                                           padding: EdgeInsets.all(4),
//                                           margin: EdgeInsets.symmetric(
//                                             horizontal: 8,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 Constants.primaryRadius,
//                                             color:
//                                                 themeData.colorScheme.surface,
//                                             boxShadow:
//                                                 Constants.primaryBoxShadow(
//                                                     blurRadius: 4,
//                                                     colorOpacity: 0.05,
//                                                     context),
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 Constants.primaryRadius,
//                                             child: Image.asset(
//                                               'assets/images/1526890419.jpg',
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vizi_dasht/common/const.dart';
import 'package:vizi_dasht/screens/oreders/bloc/orders_bloc.dart';
import 'package:vizi_dasht/screens/oreders/order_details_screen.dart';
import 'package:vizi_dasht/widgets/loading/orders.dart';
import '../../widgets/deliveri_message.dart';
import '../../widgets/new_label.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => OrdersBloc()..add(OrdersStarted()),
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return OrdersShimmer();
            }

            return Scaffold(
              appBar: AppBar(
                title: Text('سفارشات'),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.history,
                    size: 24,
                    opticalSize: 24,
                  ),
                ),
              ),
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'سفارشی ندارید',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
