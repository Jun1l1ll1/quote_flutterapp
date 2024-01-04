import 'package:flutter/material.dart';
import 'package:quote/settings.dart';
import 'add_quote.dart';
import 'library.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote\'em',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}


// Here ill place widgets to be used with all or more pages

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.isOn});

  final int isOn;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _goTo(index) {

    setState(() {
      if (index == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MyHomePage()));
      } else if (index == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LibraryPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.add_comment), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
      ],
      currentIndex: widget.isOn,
      onTap: _goTo,
      unselectedItemColor: Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}




class SettingsBtn extends StatefulWidget {
  const SettingsBtn({super.key, required this.refreshParent});

  final Function() refreshParent;

  @override
  State<SettingsBtn> createState() => _SettingsBtnState();
}

class _SettingsBtnState extends State<SettingsBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: IconButton(
        icon: const Icon(Icons.help_outline),
        iconSize: 30.0,
        onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())).then((_) {
          // This block runs when you have returned back to the 1st Page from 2nd.
          widget.refreshParent();
        });},
      ),
    );
  }
}

