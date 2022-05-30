import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
//if (kIsWeb) {
//import 'dart:html' if (dart.library.html);
//}
import 'package:universal_html/html.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import './common/socket_service.dart';
import './common/localstorage_service.dart';

import './routes.dart';

import './modules/user_auth/current_user_state.dart';

main() async {
  await dotenv.load(fileName: '.env');

  if (kIsWeb) {
    // Check for redirect.
    bool redirectIt = false;
    String url = Uri.base.toString();
    // dot env is not loading properly if on www? So just assume if null to redirect.
    // Check www first so can also redirect http to https after if necessary.
    if ((dotenv.env['REDIRECT_WWW'] == '1' || dotenv.env['REDIRECT_WWW'] == null) && url.contains('www.')) {
      if (url.contains('https://') || url.contains('http://')) {
        url = url.replaceAll('www.', '');
      } else {
        url = url.replaceAll('www.', 'https://');
      }
      redirectIt = true;
    }
    if (dotenv.env['REDIRECT_HTTP'] == '1' && url.contains('http://')) {
      url = url.replaceAll('http://', 'https://');
      redirectIt = true;
    }
    if (redirectIt) {
      window.location.href = url;
    }
  }

  LocalstorageService _localstorageService = LocalstorageService();
  _localstorageService.init(dotenv.env['APP_NAME']);

  SocketService _socketService = SocketService();
  _socketService.connect(dotenv.env['SOCKET_URL_PUBLIC']);

  setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => CurrentUserState()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    
    AppRouter appRouter = AppRouter(
      routes: AppRoutes.routes,
      notFoundHandler: AppRoutes.routeNotFoundHandler,
    );

    appRouter.setupRoutes();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CurrentUserState>(context, listen: false).checkAndLogin();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sadhan',
      onGenerateRoute: AppRouter.router.generator,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 255, 255, 1),
        accentColor: Color.fromRGBO(2, 39, 53, 1),
        hintColor: Color.fromRGBO(255, 255, 255, 1),
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Color.fromRGBO(255, 255, 255, 1),
          secondary: Color.fromRGBO(2, 39, 53, 1),
          primaryVariant: Color.fromRGBO(255, 255, 255, 1),
          secondaryVariant: Color.fromRGBO(255, 255, 255, 1),
          background: Color.fromRGBO(255, 255, 255, 1),
          surface: Color.fromRGBO(255, 255, 255, 1),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        textTheme: GoogleFonts.ptSansTextTheme(Theme.of(context).textTheme).copyWith(
          headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Color.fromRGBO(255, 255, 255, 1)),
          headline2: TextStyle(fontSize: 26, fontWeight: FontWeight.w300, color: Color.fromRGBO(255, 255, 255, 1)),
          headline3: TextStyle(fontSize: 21, fontWeight: FontWeight.w300, color: Color.fromRGBO(255, 255, 255, 1)),
          headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Color.fromRGBO(255, 255, 255, 1)),
          headline5: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Color.fromRGBO(255, 255, 255, 1)),
          headline6: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Color.fromRGBO(255, 255, 255, 1)),
          bodyText1: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Color.fromRGBO(255, 255, 255, 1)),
          bodyText2: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Color.fromRGBO(255, 255, 255, 1)),
          caption: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          subtitle1: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ).apply(
          bodyColor: Color.fromRGBO(255, 255, 255, 1),
          displayColor: Color.fromRGBO(255, 255, 255, 1),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
          onPrimary: Color.fromRGBO(255, 255, 255, 1),
          primary: Color.fromRGBO(2, 39, 53, 1),
         )
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          helperStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          floatingLabelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          hoverColor: Color.fromRGBO(255, 255, 255, 1),
          border: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 1))),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 1))),
        )
      ),
    );
  }
}
