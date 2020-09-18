import 'package:bank/theme.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'bloc/theme_change_bloc.dart';
import 'bloc/theme_change_state.dart';
import 'creditCardPage.dart';
import 'credit_card_names_page.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = await HydratedBlocDelegate.build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeChangeBloc>(
      create: (_) => ThemeChangeBloc(),
      child: BlocBuilder<ThemeChangeBloc, ThemeChangeState>(
          builder: (context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: state.themeState.themeMode,
          darkTheme: darkTheme,
          theme: lightTheme,
          home: SplashScreen(
            'assets/splash.flr',
            (contxt) => MyApp1(),
            startAnimation: 'intro',
            backgroundColor: Color(0xff181818),
            until: () {
              return Future.delayed(Duration(seconds: 4));
            },
          ),
        );
      }),
    );
  }
}

class MyApp1 extends StatefulWidget {
  @override
  _MyApp1State createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  int _selectedIndex;
  TextStyle optionStyle;
  List<Widget> _widgetOptions;

  @override
  void initState() {
    _selectedIndex = 0;
    optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    _widgetOptions = <Widget>[
      MyHomePage(),
      CreditCardNames(),
      DartTutorialHomePage(),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Users'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
