// import 'dart:io';
// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'package:edriving_spim_app/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'package:auto_route/auto_route.dart';
import '/common_library/services/model/inbox_model.dart';
import '/common_library/services/model/provider_model.dart';
import '/common_library/services/repository/inbox_repository.dart';
import '/router.gr.dart';
import '/services/provider/notification_count.dart';
import '/utils/constants.dart';
import '/common_library/utils/local_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'common_library/services/model/auth_model.dart';
import 'common_library/utils/app_localizations_delegate.dart';
import 'common_library/utils/application.dart';
import '/common_library/services/model/bill_model.dart';
import '/common_library/services/model/kpp_model.dart';
import '/common_library/utils/custom_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'pages/chat/chat_history.dart';
import 'pages/chat/chatnotification_count.dart';
import 'pages/chat/custom_animation.dart';
import 'pages/chat/online_users.dart';
import 'pages/chat/rooms_provider.dart';
import 'pages/chat/socketclient_helper.dart';
import 'services/provider/cart_status.dart';
// import 'package:logging/logging.dart';

/* final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final dynamic notification = message['notification'] ?? message;
  final String messageTitle = notification['title'];
  final String messageBody = notification['body'];
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(
      itemId,
      () => Item(
          messageTitle: messageTitle, messageBody: messageBody, itemId: itemId))
    ..status = data['status'];
  return item;
}

class Item {
  Item({this.messageTitle, this.messageBody, this.itemId});

  final String messageTitle;
  final String messageBody;
  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => Authentication(
            messageTitle: messageTitle,
            messageBody: messageBody,
            itemId: itemId),
      ),
    );
  }
} */
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('A Background message just showed up :  ${message.messageId}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(KppExamDataAdapter());
  // Hive.registerAdapter(EmergencyContactAdapter());
  Hive.registerAdapter(TelcoAdapter());
  Hive.registerAdapter(BillAdapter());
  Hive.registerAdapter(MsgOutboxAdapter());
  Hive.registerAdapter(DiListAdapter());
  // _setupLogging();
  await Hive.openBox('ws_url');
  await Hive.openBox('di_list');
  await Hive.openBox('credentials');
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// Firebase local notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

//Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();

  // setupSentry(() =>
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CallStatusModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeLoadingModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartStatus(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationCount(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatNotificationCount(),
        ),
        ChangeNotifierProvider(create: (context) => OnlineUsers(context)),
        ChangeNotifierProvider(create: (context) => ChatHistory()),
        ChangeNotifierProvider(create: (context) => RoomHistory()),
        ChangeNotifierProvider(
            create: (context) => SocketClientHelper(context)),
      ],
      child: const MyApp(),
    ),
  );
  //);
  configLoading();
}

// Future<void> setupSentry(AppRunner appRunner) async {
//   await SentryFlutter.init((options) {
//     options.dsn = kDebugMode
//         ? ''
//         : 'https://d536e0a55a884055b2fa352bcbab7b4b@o354605.ingest.sentry.io/6717561';
//     options.tracesSampleRate = 1.0;
//     options.attachThreads = true;
//     options.enableWindowMetricBreadcrumbs = true;
//     options.sendDefaultPii = true;
//     options.reportSilentFlutterErrors = true;
//     options.attachScreenshot = true;
//     options.screenshotQuality = SentryScreenshotQuality.low;
//     options.attachViewHierarchy = true;
//     options.maxRequestBodySize = MaxRequestBodySize.always;
//     options.maxResponseBodySize = MaxResponseBodySize.always;
//   }, appRunner: appRunner);
// }

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

// void _setupLogging() {
//   Logger.root.level = Level.ALL;
//   Logger.root.onRecord.listen((rec) {
//     print('${rec.level.name}: ${rec.time}: ${rec.message}');
//   });
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}
final _appRouter = RootRouter();

class MyAppState extends State<MyApp> {
  AppLocalizationsDelegate? _newLocaleDelegate;
  final localStorage = LocalStorage();
  final image = ImagesConstant();
  final inboxRepo = InboxRepo();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _homeScreenText = "Waiting for token...";
  final customDialog = CustomDialog();
  

  @override
  void initState() {
    super.initState();
    context.read<SocketClientHelper>().initSocket();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      getUnreadNotificationCount();
      if (kDebugMode) {
        print('Got a message whilst in the FOREGROUND!');
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      //print('Message data: ${message.data}');
      if (notification != null && android != null) {
        if (await Hive.box('ws_url').get('isInChatRoom') == null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('NOTIFICATION MESSAGE TAPPED');
      }
      getUnreadNotificationCount();
      _navigateToItemDetail(message);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        /*    NotificationPayload notificationPayload =
            NotificationPayload.fromJson(message.data);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatHome2(Room_id: notificationPayload.roomId ?? '')));*/
      }
    });

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: true,
      announcement: false,
      criticalAlert: false,
      carPlay: false,
    );

    /* _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    }); */
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      Hive.box('ws_url').put('push_token', token);
      debugPrint(_homeScreenText);
    });

    // _firebaseMessaging.requestPermission();

    _newLocaleDelegate = const AppLocalizationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
    _loadSavedLocale();
  }

  void _loadSavedLocale() async {
    String storedLocale = (await localStorage.getLocale())!;

    onLocaleChange(Locale(storedLocale));
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppLocalizationsDelegate(newLocale: locale);
    });
  }

  /* Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    debugPrint('Handling a background message ${message.messageId}');

    getUnreadNotificationCount();

    _navigateToItemDetail(message);
  } */

  Future<void> getUnreadNotificationCount() async {
    var result = await inboxRepo.getUnreadNotificationCount();

    if (result.isSuccess) {
      if (int.tryParse(result.data[0].msgCount)! > 0) {
        if (!context.mounted) return;
        Provider.of<NotificationCount>(context, listen: false).setShowBadge(
          showBadge: true,
        );

        Provider.of<NotificationCount>(context, listen: false)
            .updateNotificationBadge(
          notificationBadge: int.tryParse(result.data[0].msgCount),
        );
      } else {
        if (!context.mounted) return;
        Provider.of<NotificationCount>(context, listen: false).setShowBadge(
          showBadge: false,
        );
      }
    } else {
      if (!context.mounted) return;
      Provider.of<NotificationCount>(context, listen: false).setShowBadge(
        showBadge: false,
      );
    }
  }

  /* static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];

      print('Data: ' + data);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];

      print('Notification: ' + notification);
    }

    // Or do other work.
  } */

/*   Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text(item.messageBody),
      actions: <Widget>[
        TextButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  } */

  /* void _showItemDialog(Map<String, dynamic> message) {
    customDialog.show(
      context: context,
      title: message['notification']['title'],
      content: Text(message['notification']['data']),
      customActions: [
        TextButton(
          child: Text(AppLocalizations.of(context).translate('ok_btn')),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      type: DialogType.GENERAL,
    );

    /* showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    }); */
  } */

  void _navigateToItemDetail(RemoteMessage message) {
    var notificationData = message.data;
    var view = notificationData['view'];
    StackRouter router = AutoRouter.of(context);

    if (view != null) {
      switch (view) {
        case 'ENROLLMENT':
          // ExtendedNavigator.of(context).push(router.enrollment);
          router.push(const Enrollment());
          break;
        case 'KPP':
          // ExtendedNavigator.of(context).push(router.kppCategory);
          router.push(const KppCategory());
          break;
        case 'VCLUB':
          // ExtendedNavigator.of(context).push(router.Routes.valueClub);
          router.push(const ValueClub());
          break;
        // case 'CHAT':
        //   // ExtendedNavigator.of(context).push(router.Routes.chatHome);
        //   router.push(const RoomList());
        //   break;
      }
    }
    /* final Item item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    } */
  }

  @override
  Widget build(BuildContext context) {

    precacheImage(AssetImage(image.logo2), context);
    return MaterialApp.router(
      routerConfig: _appRouter.config(
        deepLinkBuilder: (deepLink) {
          if (deepLink.path.startsWith('/')) {
            // continute with the platfrom link
            return deepLink;
          } else {
            return DeepLink.defaultPath;
            // or DeepLink.path('/')
            // or DeepLink([HomeRoute()])
          }
        }
      ),
      title: 'eDriving SPIM',
      theme: ThemeData(
        primaryColor: ColorConstant.primaryColor,
        fontFamily: 'Myriad',
        textTheme: FontTheme().primaryFont,
        primaryTextTheme: FontTheme().primaryFont,
      ),
      // List all of the app's supported locales here
      supportedLocales: application.supportedLocales(),
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        _newLocaleDelegate!,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      builder: EasyLoading.init(),
      // routerDelegate:
      //     _appRouter.delegate(
      //       deepLinkBuilder:(_)=> DeepLink(Authentication as List<PageRouteInfo>)
      //       /* initialRoutes: [const Authentication()] */
      //     ),
      // routeInformationParser: _appRouter.defaultRouteParser(),
      // initialRoute: AUTH,
      // onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  @override
  void dispose() {
    Hive.box('exam_data').compact();
    Hive.box('ws_url').compact();
    // Hive.box('emergencyContact').compact();
    Hive.close();
    super.dispose();
  }
}
