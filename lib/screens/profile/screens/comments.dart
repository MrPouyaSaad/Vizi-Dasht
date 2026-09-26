import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vizi_dasht/widgets/button.dart';

import '../../../common/const.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نظرات من'),
        ),
        body: SafeArea(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: Constants.primaryPadding),
            itemCount: 5,
            itemBuilder: (context, index) {
              return MyCommentItem(index: index);
            },
          ),
        ),
      ),
    );
  }
}

class MyCommentItem extends StatelessWidget {
  const MyCommentItem({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final String statusText;
    final Color statusTextColor;
    final IconData statusIcon;
    Function()? onTap;
    switch (index) {
      case 0:
        statusText = 'درحال بررسی';
        statusTextColor = themeData.colorScheme.secondary;
        statusIcon = CupertinoIcons.arrow_2_circlepath;

        break;
      case 1:
        statusText = 'رد شده';
        statusTextColor = themeData.colorScheme.error;
        statusIcon = Icons.cancel_outlined;

        break;

      default:
        statusText = 'تایید شده';
        statusTextColor = themeData.colorScheme.tertiary;
        statusIcon = CupertinoIcons.check_mark_circled;
        onTap = () {};
        break;
    }
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Constants.primaryPadding,
          vertical: Constants.primaryPadding / 2),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
        borderRadius: Constants.primaryRadius,
        boxShadow: Constants.primaryBoxShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Image.asset('assets/images/1509547706.jpg'),
              ),
              const SizedBox(width: Constants.primaryPadding / 2),
              Flexible(
                child: Wrap(
                  children: [
                    const Text('کمک فنر جلو پژو 206'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.primaryPadding / 3),
          Divider(color: themeData.colorScheme.secondary.withOpacity(0.2)),
          const SizedBox(height: Constants.primaryPadding / 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text('خیلی عالی'),
              ),
              const SizedBox(width: Constants.primaryPadding / 3),
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    color: themeData.colorScheme.tertiary,
                  ),
                  const SizedBox(width: Constants.primaryPadding / 3),
                  Text(
                    'پیشنهاد میشود',
                    style: TextStyle(
                        color: themeData.colorScheme.tertiary, fontSize: 12),
                  )
                ],
              ),
            ],
          ),
          Text('11 خرداد 1403', style: themeData.textTheme.bodySmall),
          const SizedBox(height: Constants.primaryPadding / 3),
          const Text(
            'خیلی زود و سالم ارسال شد',
            style: TextStyle(height: 1.4, fontSize: 12),
          ),
          Divider(color: themeData.colorScheme.secondary.withOpacity(0.2)),
          Row(
            children: [
              Icon(
                statusIcon,
                size: 20,
                color: statusTextColor,
              ),
              SizedBox(width: 6),
              Text(
                statusText,
                style: TextStyle(
                  wordSpacing: -2,
                  color: statusTextColor,
                ),
              ),
              Spacer(),
              MyTextButton(onTap: onTap, title: 'پاسخ')
            ],
          )
        ],
      ),
    );
  }
}
