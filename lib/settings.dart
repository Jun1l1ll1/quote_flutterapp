import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'global.dart' as global;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LocalStorage storage = LocalStorage('quoteem_data');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  // Q&A
                  InformerBox(
                    title: 'Q&A',
                    subtitle: '',
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding( // edit quotes
                          padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('How do I edit quotes?', style: TextStyle(fontSize: 20)),
                            Text('By double tapping a quote a popup will appear. There you can edit the quoted\'s name, the quote, and delete if desired.'),
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('How can I copy a quote?', style: TextStyle(fontSize: 20)),
                            Text('Double tap on a quote to enter edit-mode, there you can copy text as you want.'),
                          ]),
                        ),
                      ],
                    ),
                  ),

                  // About
                  InformerBox(
                    title: 'About Quote\'em',
                    subtitle: '',
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                          child: Text('Quote\'em is a free note app designed for logging quotes. You can easily sort, edit and add quotes with both name and date.'),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                          child: Text('This app is developed by Juni, as a student at Elvebakken VGS.'),
                        ),

                        InformerBox(
                          title: '',
                          subtitle: 'Privacy & Info gathering',
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                                child: Text('Data gets stored on your phone and is protected by the phones security system. No quote data is sent over any other connection and we do not need any personal information from you.'),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                                child: Text('Any personal information given is at your own risk.'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contact
                  InformerBox(
                    title: 'Help & Contact',
                    subtitle: '',
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                          child: Text('If you have any problems, please make sure you have read the Q&A.'),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                          child: Text('With bugs or strange experiences on the app try to restart the app and/or phone completely.'),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                          child: Text('For additional support send an email to juni@grottenveien.no. I will try to answer as fast as possible, but please expect unpredictable response time.'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Delete all quotes? (${global.quotes.length})'),
                      content: const Text('Are you sure you want to delete all your quotes? You may not get them back later if you do so, and it is not reversable.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Delete Request');

                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('You have ${global.quotes.length} quotes'),
                                content: const Text('Press \"Confirm Delete\" to confirm the deletion of all quotes.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Never-mind'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      global.quotes = [];
                                      storage.setItem('quotes', global.quotes);
                                      Navigator.pop(context, 'Confirm Delete');
                                    },
                                    child: const Text('Confirm Delete'),
                                  ),
                                ],
                              ),
                            );

                          },
                          child: const Text('Delete All'),
                        ),
                      ],
                    ),
                  );

                });
              },
              child: Text('Delete All Quotes', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        ),
      ),
    );
  }
}


class InformerBox extends StatefulWidget {
  const InformerBox({super.key, required this.title, required this.subtitle, required this.body,});

  final String title;
  final String subtitle;
  final Widget body;

  @override
  State<InformerBox> createState() => _InformerBoxState();
}

class _InformerBoxState extends State<InformerBox> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      textColor: Theme.of(context).colorScheme.primary,

      title: Text(widget.title, style: const TextStyle(fontSize: 20)),
      subtitle: Text(widget.subtitle),
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10.0),
          child: widget.body,
        ),
      ],
    );
  }
}

