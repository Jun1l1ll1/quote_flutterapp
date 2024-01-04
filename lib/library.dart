import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'global.dart' as global;
import 'main.dart';

// This is the library page

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final LocalStorage storage = LocalStorage('quoteem_data');

  void _refresh() {
    setState(() {
      storage.setItem('quotes', global.quotes);
      _onSort();
    });
  }

  String _sortValue = 'name';
  var sortedQuotes = global.quotes;

  void _onSort() {
    sortedQuotes = global.quotes;
    _sortValue == 'newest' ? sortedQuotes.sort((a, b) => (
        b[1].substring(6, 8)
            + b[1].substring(3, 5)
            + b[1].substring(0, 2)).compareTo(
        a[1].substring(6, 8)
            + a[1].substring(3, 5)
            + a[1].substring(0, 2)))
        : _sortValue == 'name' ? sortedQuotes.sort((a, b) => a[0].toLowerCase().compareTo(b[0].toLowerCase()))
        : sortedQuotes.sort((a, b) => (
        a[1].substring(6, 8)
            + a[1].substring(3, 5)
            + a[1].substring(0, 2)).compareTo(
        b[1].substring(6, 8)
            + b[1].substring(3, 5)
            + b[1].substring(0, 2)));
  }

  @override
  void initState() {
    super.initState();

    storage.getItem('quotes') == null ? storage.setItem('quotes', global.quotes) : global.quotes = [...storage.getItem('quotes')];
    _onSort(); // Sort quotes when page gets loaded (sorts after name)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        title: const Text('Show\'em quotes'),
        actions: [
          SettingsBtn(refreshParent: _refresh),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                underline: Container(),
                items: const [
                  DropdownMenuItem(value: 'name', child: Text('Name')),
                  DropdownMenuItem(value: 'oldest', child: Text('Oldest')),
                  DropdownMenuItem(value: 'newest', child: Text('Newest')),
                ],
                value: _sortValue,
                onChanged: (value) {
                  setState(() {
                    _sortValue = value!;
                    _onSort();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                if (sortedQuotes.isNotEmpty)
                  ...[for (int quoteNr in List.generate(sortedQuotes.length, (i) => i))
                    if (_sortValue == 'name' && quoteNr <= (sortedQuotes.length-2) && sortedQuotes[quoteNr][0] != sortedQuotes[quoteNr+1][0]) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                        child: LibraryQuoteItem(quote: sortedQuotes[quoteNr], refreshParent: _refresh),
                      )
                    ]
                    else if (_sortValue != 'name' && quoteNr <= (sortedQuotes.length-2) && sortedQuotes[quoteNr][1].substring(0, 8) != sortedQuotes[quoteNr+1][1].substring(0, 8)) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                        child: LibraryQuoteItem(quote: sortedQuotes[quoteNr], refreshParent: _refresh),
                      )
                    ]
                    else ...[
                      LibraryQuoteItem(quote: sortedQuotes[quoteNr], refreshParent: _refresh),
                    ]
                  ]
                else
                  ...[
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Start by writing a quote,'),
                        Text('and se all stored quotes here later.'),
                      ],
                    ),
                  ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(isOn: 1),
    );
  }
}





class LibraryQuoteItem extends StatefulWidget {
  const LibraryQuoteItem({super.key, required this.quote, required this.refreshParent});

  final List quote;
  final Function() refreshParent;

  @override
  State<LibraryQuoteItem> createState() => _LibraryQuoteItemState();
}

class _LibraryQuoteItemState extends State<LibraryQuoteItem> {
  final editQuotedController = TextEditingController();
  final editQuoteController = TextEditingController();

  // Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    editQuotedController.dispose();
    editQuoteController.dispose();
    super.dispose();
  }

  void _deleteAlert() {
    void delete() {
      global.quotes.remove(widget.quote);
      widget.refreshParent();
    }

    setState(() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Delete this quote?'),
          content: const Text('Are you sure you want to delete this quote? You may not get it back later if you do so.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                delete();
                Navigator.pop(context, 'Delete');
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    });
  }

  void _editAlert() {
    void confirmEdit() {
      widget.quote[0] = editQuotedController.text;
      widget.quote[2] = editQuoteController.text;
      widget.quote[1] = widget.quote[1].length > 8
          ? widget.quote[1].substring(0, 8) + ' :${DateTime.now().day}/${DateTime.now().month}-${DateTime.now().year.toString().substring(2)}'
          : widget.quote[1] + ' :${DateTime.now().day}/${DateTime.now().month}-${DateTime.now().year.toString().substring(2)}';
      widget.refreshParent();
    }

    editQuoteController.text = widget.quote[2];
    editQuotedController.text = widget.quote[0];

    setState(() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          //title: const Text('AlertDialog Title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: editQuoteController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    label: Text('Quote'),
                    floatingLabelBehavior:FloatingLabelBehavior.always,
                  ),
                ),
              ),
              const SizedBox( height: 10 ),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: editQuotedController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    label: Text('Quoted'),
                    floatingLabelBehavior:FloatingLabelBehavior.always,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Delete');
                _deleteAlert();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                confirmEdit();
                Navigator.pop(context, 'Apply');
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _editAlert,
      child: Padding(
        padding: const EdgeInsets.all(7.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(7.5)),
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text('"${widget.quote[2]}"'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.quote[1]),
                    Text('- ${widget.quote[0]}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





