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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _getNavBar(context),
    );
  }

  _buildHome() {
    if (_selectedIndex == 0) return MyHomePage();
    if (_selectedIndex == 1) return CreditCardNames();
    if (_selectedIndex == 2) return DartTutorialHomePage();
  }

  _getNavBar(context) {
    BottomNavigationBarThemeData navBarTheme =
        Theme.of(context).bottomNavigationBarTheme;

    return Stack(children: [
      _buildHome(),
      Positioned(
        bottom: 0,
        child: ClipPath(
          clipper: NavBarClipper(),
          child: Container(
            color: navBarTheme.backgroundColor,
            height: 60,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
      Positioned(
        bottom: 45,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, _selectedIndex == 0, 0),
            SizedBox(width: 1),
            _buildNavItem(Icons.people, _selectedIndex == 1, 1),
            SizedBox(width: 1),
            _buildNavItem(Icons.settings, _selectedIndex == 2, 2),
          ],
        ),
      ),
      Positioned(
        bottom: 10,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            SizedBox(width: 40),
            Text(
              'Add Card',
              style: navBarTheme.selectedLabelStyle,
            ),
            SizedBox(width: 90),
            Text(
              'Users',
              style: navBarTheme.selectedLabelStyle,
            ),
            SizedBox(width: 90),
            Text(
              'Settings',
              style: navBarTheme.selectedLabelStyle,
            ),
          ],
        ),
      ),
    ]);
  }

  _buildNavItem(IconData icon, bool active, int index) {
    IconThemeData iconTheme = Theme.of(context).iconTheme;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: CircleAvatar(
        radius: 30,
        backgroundColor:iconTheme.color,
        child: CircleAvatar(
          radius: 25,
          backgroundColor:
              active ? Colors.white.withOpacity(0.9) : Colors.transparent,
          child: Icon(
            icon,
            color: active ? Colors.black : Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}

class NavBarClipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;
    path.cubicTo(sw / 12, 0, sw / 12, 2 * sh / 5, 2 * sw / 12, 2 * sh / 5);
    path.cubicTo(3 * sw / 12, 2 * sh / 5, 3 * sw / 12, 0, 4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.cubicTo(
        9 * sw / 12, 0, 9 * sw / 12, 2 * sh / 5, 10 * sw / 12, 2 * sh / 5);
    path.cubicTo(11 * sw / 12, 2 * sh / 5, 11 * sw / 12, 0, sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
