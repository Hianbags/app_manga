import 'package:appmanga/Chat/page/User_selected.dart';
import 'package:appmanga/Chat/page/chat.dart';
import 'package:appmanga/Chat/page/selected_user.dart';
import 'package:appmanga/DatabaseHelper/Addresses_helper.dart';
import 'package:appmanga/DatabaseHelper/database_helper.dart' as db;
import 'package:appmanga/Model/Shop_Model/cart_model.dart';
import 'package:appmanga/Page/Manga_Page/manga_detail_page.dart';
import 'package:appmanga/firebase/page/login_gg.dart';
import 'package:appmanga/forum/page/forum_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:appmanga/firebase/Firebase.dart';
import 'package:appmanga/provider_model/Manga/manga_search.dart';
import 'package:appmanga/provider_model/Manga/reding_history.dart';
import 'package:appmanga/provider_model/theme.dart';
import 'package:appmanga/Model/Shop_Model/cart_provider_model.dart';
import 'package:appmanga/Page/Manga_Page/Manga_Page.dart';
import 'package:appmanga/Page/Manga_Page/account_page.dart';
import 'package:appmanga/Page/Shop_page/shop_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.black,
  hintColor: Colors.white,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // You can perform background tasks here
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize the Firebase API to set up notification handlers
  FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();

  // Initialize flutter_local_notifications
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Retrieve the token and user ID
  String? token = await db.DatabaseHelper().getToken();
  String? currentUserId;
  if (token != null) {
    currentUserId = getUserIdFromToken(token);
    print('User ID: $currentUserId');
  } else {
    print('Token is null. Unable to retrieve user ID.');
  }

  runApp(MyApp(currentUserId: currentUserId));
}

String getUserIdFromToken(String token) {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  String userId = decodedToken['sub']; // Adjust 'sub' if your token uses a different key
  return userId;
}

class MyApp extends StatelessWidget {
  final String? currentUserId;

  MyApp({this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()..initializeCart()),
        ChangeNotifierProvider(create: (_) => MangaProvider()),
        ChangeNotifierProvider(create: (_) => ReadingHistoryNotifier()),
        ChangeNotifierProvider(create: (_) => ReadingHistoryListNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Your App Title',
            theme: themeNotifier.themeData,
            home: MyHomePage(currentUserId: currentUserId),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? currentUserId;

  MyHomePage({this.currentUserId});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    if (widget.currentUserId == null) {
      // Handle the null case, for example by showing an error or defaulting to a guest user page
      _widgetOptions = <Widget>[
        MangaListWidget(),
        ProductPage(),
        CategoryPage(),
        Center(child: Text('User not logged in')), // Example error message widget
        AccountPage(),
      ];
    } else {
      _widgetOptions = <Widget>[
        MangaListWidget(),
        ProductPage(),
        CategoryPage(),
        FetchRoomsPage(currentUserId: widget.currentUserId!), // Safe to use `!` now
        AccountPage(),
      ];
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground notification received: ${message.messageId}');
      _showNotification(message);
    });

    // Handle messages when the app is in the background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification caused app to open: ${message.messageId}');
      _handleMessage(message);
    });

    // Handle messages when the app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from terminated state by notification: ${message.messageId}');
        _handleMessage(message);
      }
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  void _handleMessage(RemoteMessage message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MangaDetailPage(mangaId: int.parse(message.data['manga_id'])),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10.0,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Manga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cửa Hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Xã Hội',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Tài Khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
