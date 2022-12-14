import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkit/firebase_options.dart';
import 'package:parkit/screens/add_money.dart';
import 'package:parkit/screens/splash_screen.dart';
import 'package:parkit/utils/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (defaultTargetPlatform == TargetPlatform.android) {
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyTheme theme = MyTheme();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDynamicLinks();
  }

  initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AddMoneyScreen()));
    }).onError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyTheme(),
      child: Consumer<MyTheme>(
        builder: (context, MyTheme theme, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: theme.isDark == true ? ThemeMode.dark : ThemeMode.light,
            theme: MyTheme.lightTheme(context),
            darkTheme: MyTheme.darkTheme(context),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
