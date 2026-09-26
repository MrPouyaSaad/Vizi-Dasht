import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vizi_dasht/common/const.dart';
import 'package:vizi_dasht/widgets/button.dart';
import 'package:vizi_dasht/widgets/text_field.dart';

class AddProductDetails extends StatefulWidget {
  final int id;
  final bool isEdit;

  const AddProductDetails({
    Key? key,
    required this.id,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<AddProductDetails> createState() => _AddProductDetailsState();
}

class _AddProductDetailsState extends State<AddProductDetails> {
  String? selectedProduct;
  bool isDiscount = false;
  final _formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();

  // Controllers for form fields
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final technicalCodeController = TextEditingController();
  final stockController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  // Sample product data for auto parts
  final List<Map<String, String>> products = [
    {
      'name': 'کمک فنر جلو پژو 206',
      'image': 'assets/images/shock_absorber.jpg',
      'code': 'PRD-001',
      'brand': 'ساکس',
      'model': '206',
      'year': '1385-1400',
      'technicalCode': 'SF-206-01'
    },
    {
      'name': 'لنت ترمز عقب پراید',
      'image': 'assets/images/brake_pad.jpg',
      'code': 'PRD-002',
      'brand': 'آمپر',
      'model': 'پراید 131',
      'year': '1375-1400',
      'technicalCode': 'LB-131-02'
    },
    {
      'name': 'فیلتر روغن 405',
      'image': 'assets/images/oil_filter.jpg',
      'code': 'PRD-003',
      'brand': 'مان',
      'model': '405',
      'year': '1370-1395',
      'technicalCode': 'OF-405-03'
    },
    {
      'name': 'ترمومتر موتور سمند',
      'image': 'assets/images/thermostat.jpg',
      'code': 'PRD-004',
      'brand': 'ورنات',
      'model': 'سمند',
      'year': '1380-1400',
      'technicalCode': 'TH-SM-04'
    },
    {
      'name': 'شمع جرقه زنی تیبا',
      'image': 'assets/images/spark_plug.jpg',
      'code': 'PRD-005',
      'brand': 'بوش',
      'model': 'تیبا',
      'year': '1385-1400',
      'technicalCode': 'SP-TB-05'
    },
  ];

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    technicalCodeController.dispose();
    stockController.dispose();
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'ویرایش قطعه یدکی' : 'افزودن قطعه یدکی'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.primaryColor,
        actions: widget.isEdit
            ? [
                IconButton(
                  onPressed: () => _showDeleteDialog(),
                  icon: Icon(Icons.delete_outline,
                      color: theme.colorScheme.error),
                  tooltip: 'حذف قطعه',
                )
              ]
            : null,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderInfo(theme),
            const SizedBox(height: 16),
            if (!widget.isEdit) _buildProductSelector(theme),
            if (selectedProduct != null || widget.isEdit)
              _buildSelectedProductCard(theme),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTechnicalSection(theme),
                  const SizedBox(height: 16),
                  _buildInventorySection(theme),
                  const SizedBox(height: 16),
                  _buildPricingSection(theme),
                  const SizedBox(height: 24),
                  _buildSubmitButton(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.isEdit
                  ? 'در حال ویرایش قطعه یدکی با کد #${widget.id}'
                  : 'برای افزودن قطعه جدید، ابتدا محصول را جستجو یا اسکن کنید',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSelector(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: theme.colorScheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.search, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'انتخاب قطعه یدکی',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: const TextFieldProps(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(),
                          labelText: 'جستجو در قطعات',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        final product = products
                            .firstWhere((product) => product['name'] == item);
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.car_repair,
                                color: theme.primaryColor),
                          ),
                          title: Text(
                            product['name']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            'کد: ${product['code']} | ${product['brand']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Text(
                            product['technicalCode']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                      menuProps: MenuProps(
                        animationDuration: const Duration(milliseconds: 300),
                        barrierCurve: Curves.easeInOut,
                        barrierDismissible: true,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: products.map((product) => product['name']!).toList(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'نام قطعه را جستجو کنید',
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Constants.primaryPadding,
                          vertical: 12,
                        ),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      baseStyle: const TextStyle(fontSize: 13),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value;
                        final product = products
                            .firstWhere((p) => p['name'] == selectedProduct);
                        // Auto-fill fields
                        brandController.text = product['brand'] ?? '';
                        modelController.text = product['model'] ?? '';
                        technicalCodeController.text =
                            product['technicalCode'] ?? '';
                      });
                    },
                    selectedItem: selectedProduct,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: Constants.primaryButtonHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.primaryColor,
                  ),
                  child: IconButton(
                    onPressed: () => _startBarcodeScanner(context),
                    icon: const Icon(Icons.qr_code_scanner,
                        color: Colors.white, size: 28),
                    tooltip: 'اسکن بارکد قطعه',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedProductCard(ThemeData theme) {
    final product = widget.isEdit
        ? {
            'name': 'قطعه یدکی انتخاب شده',
            'image': 'assets/images/placeholder.jpg',
            'code': 'PRD-${widget.id}',
            'brand': 'برند نمونه',
            'model': 'مدل نمونه',
            'technicalCode': 'TECH-${widget.id}'
          }
        : products.firstWhere((p) => p['name'] == selectedProduct,
            orElse: () => {
                  'name': 'قطعه انتخاب نشده',
                  'image': 'assets/images/placeholder.jpg',
                  'code': '---',
                  'brand': '---',
                  'model': '---',
                  'technicalCode': '---'
                });

    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.dividerColor.withOpacity(0.2), width: 1),
              ),
              child:
                  Icon(Icons.car_repair, color: theme.primaryColor, size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name']!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip('کد: ${product['code']}', theme),
                      _buildInfoChip('برند: ${product['brand']}', theme),
                      _buildInfoChip(
                          'کد فنی: ${product['technicalCode']}', theme),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.check_circle, color: theme.primaryColor, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTechnicalSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader(
                icon: Icons.engineering, title: 'اطلاعات فنی قطعه'),
            const SizedBox(height: 12),
            _buildFormField(
              controller: brandController,
              label: 'برند قطعه',
              isRequired: true,
              icon: Icons.branding_watermark,
              hint: 'مثال: بوش، ساکس، مان',
            ),
            _buildFormField(
              controller: modelController,
              label: 'مدل خودرو',
              isRequired: true,
              icon: Icons.directions_car,
              hint: 'مثال: پژو 206، پراید، سمند',
            ),
            _buildFormField(
              controller: yearController,
              label: 'سال ساخت خودرو',
              isRequired: false,
              icon: Icons.calendar_today,
              hint: 'مثال: 1385 تا 1400',
              keyboardType: TextInputType.text,
            ),
            _buildFormField(
              controller: technicalCodeController,
              label: 'کد فنی قطعه',
              isRequired: true,
              icon: Icons.qr_code,
              hint: 'مثال: SF-206-01',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventorySection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader(
                icon: Icons.inventory_2, title: 'موجودی و بسته‌بندی'),
            const SizedBox(height: 12),
            _buildFormField(
              controller: stockController,
              label: 'تعداد موجود برای فروش',
              isRequired: true,
              keyboardType: TextInputType.number,
              icon: Icons.store,
              hint: '0',
            ),
            _buildFormField(
              label: 'تعداد در هر بسته',
              isRequired: true,
              keyboardType: TextInputType.number,
              icon: Icons.layers,
              hint: '1',
            ),
            _buildFormField(
              label: 'تاریخ انقضاء (اختیاری)',
              isRequired: false,
              hint: 'YYYY/MM/DD',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader(
                icon: Icons.attach_money, title: 'قیمت‌گذاری قطعه'),
            const SizedBox(height: 12),
            _buildFormField(
              padding: EdgeInsets.zero,
              controller: priceController,
              label: 'قیمت هر قطعه (تومان)',
              isRequired: true,
              keyboardType: TextInputType.number,
              icon: Icons.money,
              hint: '0',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'میانگین قیمت بازار',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    wordSpacing: -2,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                MyTextButton(
                  title: '188,000 تومان',
                  onTap: () {
                    setState(() {});
                  },
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildFormField(
              label: 'قیمت عمده (5 عدد به بالا)',
              isRequired: false,
              keyboardType: TextInputType.number,
              icon: Icons.attach_money,
              hint: '0',
            ),
            _buildFormField(
              label: 'قیمت مصرف‌کننده (پیشنهادی)',
              isRequired: true,
              keyboardType: TextInputType.number,
              icon: Icons.price_check,
              hint: '0',
            ),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'درصد تخفیف',
                    isRequired: false,
                    keyboardType: TextInputType.number,
                    icon: Icons.discount,
                    hint: '0-99',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFormField(
                    label: 'مبلغ تخفیف (تومان)',
                    isRequired: false,
                    keyboardType: TextInputType.number,
                    icon: Icons.money_off,
                    hint: '0',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.primaryColor, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    bool isRequired = true,
    String? hint,
    EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 14),
    IconData? icon,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: padding,
      child: MyTextField(
        controller: controller,
        keyboardType: keyboardType,
        pbottom: 4,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        labelText: '$label${isRequired ? ' *' : ''}',
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        validator: isRequired
            ? (value) => value?.isEmpty ?? true ? 'این فیلد الزامی است' : null
            : null,
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: Constants.primaryButtonHeight,
      child: MyElevatedButton(
        onTap: () {
          if (_formKey.currentState?.validate() ?? false) {
            _submitForm();
          } else {
            final startPosition = scrollController.position.minScrollExtent;
            final duration = const Duration(milliseconds: 250);
            scrollController.animateTo(
              startPosition,
              duration: duration,
              curve: Curves.ease,
            );
          }
        },
        icon: Icon(
          widget.isEdit ? Icons.save : Icons.add_circle_outline,
          size: 24,
          color: Colors.white,
        ),
        title: widget.isEdit ? 'ذخیره تغییرات' : 'افزودن قطعه یدکی',
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _startBarcodeScanner(BuildContext context) async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'بارکد قطعه را اسکن کنید',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      MobileScanner(
                        onDetect: (capture) {
                          final barcode = capture.barcodes.first;
                          final value = barcode.rawValue;
                          if (value != null) {
                            log('📦 Barcode: $value');
                            Get.back();
                            Get.snackbar(
                              'بارکد خوانده شد',
                              'کد: $value',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.white),
                            );
                            // Auto-fill technical code
                            technicalCodeController.text = value;
                          }
                        },
                      ),
                      // Scan overlay frame
                      _buildScanOverlay(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: MyElevatedButton(
                    onTap: () => Get.back(),
                    title: 'لغو اسکن',
                    backgroundColor: Colors.grey[800]!,
                    foregroundColor: Colors.white,
                    // height: 48,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      Get.snackbar(
        'دسترسی رد شد',
        'برای اسکن بارکد به دسترسی دوربین نیاز است.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.camera_alt, color: Colors.white),
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text(
            'تنظیمات',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget _buildScanOverlay() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Corner markers
          Positioned(
            top: -2,
            left: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.redAccent, width: 4),
                  left: BorderSide(color: Colors.redAccent, width: 4),
                ),
              ),
            ),
          ),
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.redAccent, width: 4),
                  right: BorderSide(color: Colors.redAccent, width: 4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            left: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.redAccent, width: 4),
                  left: BorderSide(color: Colors.redAccent, width: 4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.redAccent, width: 4),
                  right: BorderSide(color: Colors.redAccent, width: 4),
                ),
              ),
            ),
          ),
          // Center crosshair
          Positioned(
            top: 125 - 1,
            left: 125 - 20,
            child: Container(
              width: 40,
              height: 2,
              color: Colors.redAccent.withOpacity(0.5),
            ),
          ),
          Positioned(
            top: 125 - 20,
            left: 125 - 1,
            child: Container(
              width: 2,
              height: 40,
              color: Colors.redAccent.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    Get.back();
    Get.snackbar(
      'موفقیت آمیز',
      widget.isEdit
          ? 'قطعه یدکی با موفقیت ویرایش شد'
          : 'قطعه یدکی با موفقیت اضافه شد',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            const Text(
              'حذف قطعه یدکی',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'آیا از حذف این قطعه یدکی اطمینان دارید؟',
          style: TextStyle(fontSize: 15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'انصراف',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              Get.back();
              Get.back();
              Get.snackbar(
                'حذف شد',
                'قطعه یدکی با موفقیت حذف شد',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                icon: const Icon(Icons.delete_outline, color: Colors.white),
              );
            },
            child: const Text('حذف قطعه'),
          ),
        ],
      ),
    );
  }
}
