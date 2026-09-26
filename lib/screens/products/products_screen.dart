import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vizi_dasht/screens/products/add_product/add_product_details.dart';
import 'package:vizi_dasht/screens/products/add_product/select_category.dart';
import 'package:vizi_dasht/screens/products/bloc/product_screen_bloc.dart';
import 'package:vizi_dasht/widgets/button.dart';
import 'package:vizi_dasht/widgets/loading/product.dart';
import 'package:vizi_dasht/widgets/title.dart';

import '../../common/const.dart';
import '../../widgets/text_field.dart';
import 'rec_add_product.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  final List<Map<String, String>> products = const [
    {
      'name': 'واشر گلویی اگزوز تیگو ۷',
      'image': 'assets/images/1.jpg',
      'code': 'PRD-001',
      'brand': 'ساکس',
      'price': 'برای استعلام با شماره 09143257407 تماس بگیرید',
      'stock': '15',
    },
    {
      'name': 'واشر منیفولد دود x22 , mvm 315',
      'image': 'assets/images/2.jpg',
      'code': 'PRD-002',
      'brand': 'آمپر',
      'price': 'برای استعلام با شماره 09143257407 تماس بگیرید',
      'stock': '5',
    },
    {
      'name': 'واشر منیفولد دود تیگو ۷',
      'image': 'assets/images/3.jpg',
      'code': 'PRD-003',
      'brand': 'مان',
      'price': 'برای استعلام با شماره 09143257407 تماس بگیرید',
      'stock': '0',
    },
    {
      'name': 'واشر بغل اگزوز تیگو ۵',
      'image': 'assets/images/4.jpg',
      'code': 'PRD-004',
      'brand': 'ساکس',
      'price': 'برای استعلام با شماره 09143257407 تماس بگیرید',
      'stock': '8',
    },
    {
      'name': 'واشر منیفولد دود ۵۳۰',
      'image': 'assets/images/5.jpg',
      'code': 'PRD-005',
      'brand': 'آمپر',
      'price': 'برای استعلام با شماره 09143257407 تماس بگیرید',
      'stock': '3',
    },
    {
      'name': 'واشر گلویی اگزوز دو پیچ mvm110',
      'image': 'assets/images/6.jpg',
      'code': 'PRD-006',
      'brand': 'مان',
      'price': 'برای استعلام با شماره 09143257407 تماس بگیرید',
      'stock': '12',
    },
    {
      'name': 'واشر گلویی اگزوز دو پیچ ۵۳۰',
      'image': 'assets/images/7.jpg',
      'code': 'PRD-007',
      'brand': 'ساکس',
      'price': 'برای استعلام با شماره 09143257407 تماس بگیرید',
      'stock': '0',
    },
    {
      'name': 'واشر گلویی اگزوز سه پیچ ۵۳۰',
      'image': 'assets/images/8.jpg',
      'code': 'PRD-008',
      'brand': 'آمپر',
      'price': 'برای استعلام با شماره 09143257407 تماس بگیرید',
      'stock': '20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return BlocProvider(
      create: (context) => ProductScreenBloc()..add(ProductScreenStarted()),
      child: BlocBuilder<ProductScreenBloc, ProductScreenState>(
        builder: (context, state) {
          if (state is ProductScreenLoading) {
            return const ProductShimmer();
          } else {
            return Scaffold(
              backgroundColor: Colors.grey[50],
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: SizedBox(
                width: double.infinity,
                height: Constants.primaryButtonHeight,
                child: MyElevatedButton(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CategorySelectionScreen(),
                      ),
                    );
                  },
                  backgroundColor: themeData.primaryColor,
                  icon: const Icon(Icons.add, color: Colors.white),
                  title: 'افزودن قطعه یدکی جدید',
                  foregroundColor: Colors.white,
                ),
              ).marginSymmetric(horizontal: 24),
              body: SafeArea(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        toolbarHeight: 80,
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        title: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: MyTextField(
                            textAlign: TextAlign.right,
                            textAlignVertical: TextAlignVertical.center,
                            hintText: 'جستجو در قطعات یدکی',
                            isDense: true,
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 24,
                              color: Colors.grey,
                            ),
                          ),
                        ).marginOnly(top: 12, bottom: 8),
                        automaticallyImplyLeading: false,
                        centerTitle: true,
                        elevation: 0,
                        floating: true,
                        pinned: false,
                        snap: true,
                      ),
                    ];
                  },
                  body: ListView.builder(
                    itemCount: products.length + 1,
                    padding: const EdgeInsets.only(bottom: 90, top: 8),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return SizedBox();
                        // return Column(
                        //   children: [
                        //     Row(
                        //       children: [
                        //         const SizedBox(width: 16),
                        //         Expanded(
                        //           child: AppTitle(title: 'قطعات پیشنهادی'),
                        //         ),
                        //         TextButton(
                        //           onPressed: () {},
                        //           child: Text(
                        //             'مشاهده همه',
                        //             style: TextStyle(
                        //               fontSize: 12,
                        //               color: themeData.primaryColor,
                        //               fontWeight: FontWeight.w600,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     const RecomendedAddProducts(),
                        //   ],
                        // ).marginOnly(top: 8, bottom: 16);
                      } else {
                        final productIndex = index - 1;
                        final product = products[productIndex];
                        final stock =
                            int.tryParse(product['stock'] ?? '0') ?? 0;
                        final isOutOfStock = stock == 0;
                        final isLowStock = stock > 0 && stock <= 5;

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddProductDetails(
                                  id: productIndex + 1,
                                  isEdit: true,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 3),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 1),
                                  spreadRadius: 0,
                                ),
                              ],
                              border: Border.all(
                                color: isOutOfStock
                                    ? Colors.grey.shade100
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Stock Status Badge
                                if (!isOutOfStock)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isLowStock
                                            ? Colors.orange.shade50
                                            : Colors.green.shade50,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(18),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isLowStock
                                                ? Icons.warning_amber_rounded
                                                : Icons.check_circle,
                                            size: 12,
                                            color: isLowStock
                                                ? Colors.orange.shade700
                                                : Colors.green.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            isLowStock
                                                ? '${stock} عدد باقی'
                                                : 'موجود',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isLowStock
                                                  ? Colors.orange.shade700
                                                  : Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (isOutOfStock)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(18),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            size: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'ناموجود',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        product['image'] ?? '',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: themeData.primaryColor
                                                  .withOpacity(0.06),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Icon(
                                              Icons.car_repair,
                                              color: themeData.primaryColor
                                                  .withOpacity(0.3),
                                              size: 32,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // Product Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'] ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              height: 1.3,
                                              color: isOutOfStock
                                                  ? Colors.grey.shade500
                                                  : themeData
                                                      .colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 6),

                                          // Brand & Code
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: themeData.primaryColor
                                                      .withOpacity(0.08),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  product['brand'] ?? '',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        themeData.primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '• ${product['code']}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey.shade400,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),

                                          // Price & Edit
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  isOutOfStock
                                                      ? 'ناموجود'
                                                      : 'موجود',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: isOutOfStock
                                                        ? Colors.grey.shade400
                                                        : themeData.colorScheme
                                                            .primary,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: isOutOfStock
                                                      ? Colors.grey.shade100
                                                      : themeData.primaryColor
                                                          .withOpacity(0.08),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  Icons.edit_outlined,
                                                  size: 18,
                                                  color: isOutOfStock
                                                      ? Colors.grey.shade400
                                                      : themeData.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
