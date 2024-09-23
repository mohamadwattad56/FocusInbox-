
import 'ui/base/fi_base_state.dart';
import 'ui/base/fi_base_widget.dart';
import 'utils/fi_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'models/main/fi_main_model.dart';
import 'utils/fi_resources.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(const FocusInboxApp());
}

class FocusInboxApp extends StatelessWidget {
  const FocusInboxApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff131621),
      statusBarColor:  Color(0xff131621),
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness:  Brightness.light,
    ));

    return MaterialApp(
     // debugShowCheckedModeBanner: false, //TODO:RETURN IT
      navigatorKey: resources.navigatorKey,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate
      ],
      theme: ThemeData(
          fontFamily: "Poppins",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: MaterialStateProperty.all<bool>(true),
            trackColor:MaterialStateProperty.all<Color>(const Color(0xFFFFFF6B).withOpacity(0.4)),

          )
      ),
      home: const FocusInboxPage(),
    );

  }
}

class FocusInboxPage extends FiBaseWidget {
  const FocusInboxPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  FocusInboxPageState createState() => FocusInboxPageState();
}

class FocusInboxPageState extends FiBaseState {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    applicationModel.setState(this);
  }

  @override
  void dispose() {
    applicationModel.setState(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    display.init(context);
    return WillPopScope(
        child: GestureDetector(
          onTap: (){
            FocusScopeNode focus = FocusScope.of(context);
            focus.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body:  applicationModel.currentPage,
          ),
        ),
        onWillPop: () => applicationModel.currentPage.onWillPop);
  }
}