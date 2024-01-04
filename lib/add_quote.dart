import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'global.dart' as global;
import 'main.dart';

// This is the home/add page

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalStorage storage = LocalStorage('quoteem_data');

  final quotedController = TextEditingController();
  final quoteController = TextEditingController();

  // Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    quotedController.dispose();
    quoteController.dispose();
    super.dispose();
  }

  void _addQuote() {
    setState(() {
      global.quotes.add([
        quotedController.text,
        '${DateTime.now().day}/${DateTime.now().month}-${DateTime.now().year.toString().substring(2)}',
        quoteController.text
      ]);

      storage.setItem('quotes', global.quotes);

      quotedController.text = '';
      quoteController.text = '';
    });
  }

  @override
  void initState() {
    super.initState();

    storage.getItem('quotes') == null ? storage.setItem('quotes', global.quotes) : global.quotes = [...storage.getItem('quotes')];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        title: const Text('Quote\'em down'),
        actions: [
          SettingsBtn(refreshParent: (){}),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: quotedController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Quoted\'s name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                //expands: true,
                controller: quoteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintText: 'Write quote',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuote,
        tooltip: 'Add to library',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavBar(isOn: 0,),
    );
  }
}
