import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './body.dart'; // Add this import statement
import './tip.dart'; // Add this import

void main() => runApp(const MainApp());

class AppBarText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(32),
        child: Row(children: [Text("Test Test"), Text("__Test__Test")]));
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isDarkMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    const String title = "AppTitle";
    return MaterialApp(
      title: title,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => _buildHomeScaffold(context),
        '/tip': (context) => const TipPage(),
      },
    );
  }

  Widget _buildHomeScaffold(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          "Gradual DST CLock",
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.purple[100],
        foregroundColor: _isDarkMode ? Colors.white : Colors.purple[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.grey[800] : Colors.purple[200],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.purple[800],
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text('Tip'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/tip');
              },
            ),
          ],
        ),
      ),
      body: const Body(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    var baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        brightness: brightness,
      ),
    );

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.purple[100],
        foregroundColor:
            brightness == Brightness.dark ? Colors.white : Colors.purple[800],
        elevation: 0,
      ),
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.lato(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.lato(
          fontSize: 30,
        ),
        displaySmall: GoogleFonts.pacifico(),
      ),
    );
  }
}
