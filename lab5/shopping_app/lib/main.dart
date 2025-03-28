import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      theme: ThemeData.dark(),
      home: const HomePage(title: 'Shopping List Home Page'),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  final List<String> _shoppingCartItems = [];
  final TextEditingController _textController = TextEditingController();
  int? _deleteIndex; //track the index of the item selected to be deleted. 
  //this could also be a list to delete multiple elements at once

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  // void _incrementCounter() {
  //   setState(() {
  //     _shoppingCartItems.add("item $_counter");
  //     _counter++;
  //   });
  // }

  void _addItem(String item) {
    if (item.isNotEmpty) {
      setState(() {
        _shoppingCartItems.add(item);
      });
      _textController.clear();
    }
  }

  void _deleteSelectedItem() {
    if (_deleteIndex != null) {
      setState(() {
        _shoppingCartItems.removeAt(_deleteIndex!);
        _deleteIndex = null; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Display items with selection functionality
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 4,
              children: List.generate(_shoppingCartItems.length, (index) {
                final bool isSelected = _deleteIndex == index;
                //https://api.flutter.dev/flutter/widgets/GestureDetector-class.html
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if(_deleteIndex == index){
                        _deleteIndex = null;
                      }else{
                        _deleteIndex = index;
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.red  //color a selected item in red otherwise rainbow :)
                          : Colors.primaries[index % Colors.primaries.length].shade200,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _shoppingCartItems[index],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Input field for new items
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Add item. Press enter to add to list',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _addItem,
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: _deleteIndex != null ? _deleteSelectedItem : null,
              child: const Text('Delete Selected Item'),
            ),
          ),
          // Dedicated delete button that only activates if an item is selected
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _addItem(_textController.text),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
