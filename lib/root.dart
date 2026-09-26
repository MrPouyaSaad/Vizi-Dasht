import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vizi_dasht/main.dart';
import 'package:vizi_dasht/screens/profile/profile_screen.dart';
import 'package:vizi_dasht/screens/dashboard/home_screen.dart';
import 'package:vizi_dasht/screens/oreders/orders_screen.dart';
import 'package:vizi_dasht/screens/products/products_screen.dart';
import 'package:vizi_dasht/widgets/badge.dart';

const int homeIndex = 0;
const int ordersIndex = 1;
const int productsIndex = 2;
const int profileIndex = 3;

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
    this.screen = homeIndex,
  });
  final int screen;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;
  final List<int> _history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _productseKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    ordersIndex: _cartKey,
    productsIndex: _productseKey,
    profileIndex: _profileKey,
  };

  bool canPop = false;

  Future<bool> _onWillPop(bool isPop) async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return isPop;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return isPop;
    } else {
      setState(() {
        floatingSnackBar(
          message: 'برای خروج دوبار دکمه برگشت را بزنید!',
          context: context,
          textColor: Colors.white,
          textStyle: const TextStyle(
            color: Colors.white,
          ),
          duration: const Duration(milliseconds: 3000),
          backgroundColor: Theme.of(context).colorScheme.onSurface,
        );
        canPop = true;
      });
      Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {
            canPop = false;
          }));
    }

    return true;
  }

  void handleMessage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const RootScreen(
                screen: ordersIndex,
              )),
    );
  }

  checkNotificationPermision() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();
    debugPrint(fcmToken);
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // final token = sharedPreferences.getString('access_token') ?? '';
    final token =
        'Test Token'; // Replace with your actual token retrieval logic

    // AuthRepository.authNotifier.value = token;

    // Handling the message when the app is initially opened from a notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        handleMessage();
      }
    });

    // Handle the message when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage();
    });

    if (token.isNotEmpty) {
      // ignore: unused_local_variable
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
          // await notificationRepository.unSeenCount();
          // NotificationRepository.refreshNotificationListNotifier.value = true;
          if (message.notification != null) {
            //

            RemoteNotification notification = message.notification!;
            AndroidNotification android = message.notification!.android!;

            // If `onMessage` is triggered with a notification, construct our own
            // local notification to show to users using the created channel.

            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: android.smallIcon,
                  // other properties...
                ),
              ),
            );
          }
        },
      );
      if (Platform.isAndroid) {
        flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings('ic_notif'),
          ),
          onDidReceiveNotificationResponse: (details) {
            if (details.payload != null) {
              handleMessage();
            }
          },
        );

        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      } else if (Platform.isIOS) {
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            iOS: DarwinInitializationSettings(
              requestAlertPermission: true,
              requestSoundPermission: true,
              requestBadgePermission: true,
            ),
          ),
          onDidReceiveNotificationResponse: (details) {
            if (details.payload != null) {
              handleMessage();
            }
          },
        );
      }
      //    messaging.configure(
      //   onMessage: (Map<String, dynamic> message) async {
      //     print("onMessage: $message");
      //   },
      //   onBackgroundMessage: backgroundMessageHandler,
      //   onLaunch: (Map<String, dynamic> message) async {
      //     print("onLaunch: $message");
      //   },
      //   onResume: (Map<String, dynamic> message) async {
      //     print("onResume: $message");
      //   },
      // );
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }

    // ignore: unused_local_variable
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void initState() {
    super.initState();
    selectedScreenIndex = widget.screen;
    // if (widget.seenCountReq) {
    //   notificationRepository.unSeenCount();
    // }
    checkNotificationPermision();
  }

  void changeIndex(int index) {
    setState(() {
      _history.remove(selectedScreenIndex);
      _history.add(selectedScreenIndex);
      selectedScreenIndex = index;
      canPop = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deActiveColor =
        Theme.of(context).colorScheme.secondary.withAlpha((0.7 * 255).toInt());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: PopScope(
        canPop: canPop,
        // ignore: deprecated_member_use
        onPopInvoked: _onWillPop,
        child: Scaffold(
          body: IndexedStack(
            index: selectedScreenIndex,
            children: [
              _navigator(_homeKey, homeIndex, const HomeScreen()),
              _navigator(_cartKey, ordersIndex, const OrdersScreen()),
              _navigator(_productseKey, productsIndex, const ProductsScreen()),
              _navigator(_profileKey, profileIndex, const ProfileScreen()),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            iconSize: 22,
            selectedLabelStyle:
                TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 11),
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.dashboard_outlined),
                icon: Icon(
                  Icons.dashboard_outlined,
                  color: deActiveColor,
                ),
                label: 'داشبورد',
              ),
              BottomNavigationBarItem(
                activeIcon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.receipt_long_outlined),
                    Positioned(
                      right: -10,
                      top: -10,
                      child: CounterBadge(value: 5, isActive: true),
                    ),
                  ],
                ),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.receipt_long_outlined, color: deActiveColor),
                    Positioned(
                      right: -10,
                      top: -10,
                      child: RippleBadge(
                        value: 0,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
                label: 'سفارشات',
              ),
              BottomNavigationBarItem(
                  activeIcon: Icon(Icons.storefront_outlined),
                  icon: Icon(
                    Icons.storefront_outlined,
                    color: deActiveColor,
                  ),
                  label: 'محصولات من'),
              BottomNavigationBarItem(
                  activeIcon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.person_outline),
                      Positioned(
                        right: -10,
                        top: -10,
                        child: CounterBadge(value: 3, isActive: true),
                      ),
                    ],
                  ),
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: deActiveColor,
                      ),
                      Positioned(
                        right: -10,
                        top: -10,
                        child: CounterBadge(value: 3),
                      ),
                    ],
                  ),
                  label: 'پروفایل'),
            ],
            currentIndex: selectedScreenIndex,
            onTap: (selectedIndex) {
              setState(() {
                _history.remove(selectedScreenIndex);
                _history.add(selectedScreenIndex);
                selectedScreenIndex = selectedIndex;
                canPop = false;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Offstage(
                  offstage: selectedScreenIndex != index, child: child),
            ),
          );
  }
}
