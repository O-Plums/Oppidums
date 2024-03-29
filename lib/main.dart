import 'package:oppidums/app_config.dart';
import 'package:oppidums/router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oppidums/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:io';
import 'package:intl/intl.dart'; //for date format
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:oppidums/models/city_model.dart';
import 'package:oppidums/analytics.dart';

// flutter format . -l 120
void main(List<String> args, {String env}) async {
//Remove this method to stop OneSignal Debugging
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: NamespaceFileTranslationLoader(
      namespaces: ['common'],
      useCountryCode: false,
      fallbackDir: 'en',
      basePath: 'assets/i18n',
    ),
    missingTranslationHandler: (key, locale) {
      print('--- Missing Key: $key, languageCode: ${locale.languageCode}');
    },
  );
  Intl.defaultLocale = Platform.localeName;

  await AppConfig.load(env);

  // Add this here to initialize the routes
  AppRouter.setupRouter();
  OppidumsAnalytics.setup();
  await SentryFlutter.init(
    (options) => options.dsn = AppConfig.sentryDns,
    appRunner: () => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => CityModel()),
      ],
      child: MyApp(flutterI18nDelegate),
    )),
  );
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;
  MyApp(this.flutterI18nDelegate);
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: <NavigatorObserver>[observer],
        color: Color.fromARGB(255, 255, 255, 255),
        title: 'Oppidums',
        initialRoute: 'splash',
        theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
        // GoogleFonts.barlowTextTheme(Theme.of(context).textTheme)),
        // GoogleFonts.ptSansTextTheme(Theme.of(context).textTheme)),
        // GoogleFonts.gorditasTextTheme(Theme.of(context).textTheme)),
        // GoogleFonts.robotoCondensedTextTheme(Theme.of(context).textTheme)),
        localizationsDelegates: [
          flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('fr'),
        ],
        onGenerateRoute: AppRouter.router.generator);
  }
}
