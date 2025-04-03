import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum ShapeType { circle, square, triangle }

class Category {
  final Color color;
  final ShapeType shape;

  Category({required this.color, required this.shape});
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData.dark(),
      home: const HomePage(title: 'Shopping List Home Page'),
    );
  }
}

class CategoryCustomPainter extends CustomPainter {
  final Color color;
  final ShapeType shape;

  CategoryCustomPainter({required this.color, required this.shape});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    switch (shape) {
      case ShapeType.circle:
        canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
        break;
      case ShapeType.square:
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
        break;
      case ShapeType.triangle:
        final path = Path();
        path.moveTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.close();
        canvas.drawPath(path, paint);
        break;
    }
  }
  
  @override
  bool shouldRepaint(covariant CategoryCustomPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.shape != shape;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _shoppingCartItems = [];
  final List<String?> _itemCategories = [];
  
  final TextEditingController _textController = TextEditingController();
  int? _deleteIndex;
  Timer? _timer;
  
  // Map of categories to their associated color and shape.
  final Map<String, Category> _categories = {
    'Fruits': Category(color: Colors.green, shape: ShapeType.circle),
    'Vegetables': Category(color: Colors.orange, shape: ShapeType.square),
    'Dairy': Category(color: Colors.blue, shape: ShapeType.triangle),
  };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      _updateCategoryColors();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }
  
  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
  
  void _updateCategoryColors() {
    setState(() {
      _categories.updateAll((key, category) {
        return Category(color: _getRandomColor(), shape: category.shape);
      });
    });
  }

  void _addItem(String item) {
    if (item.isNotEmpty) {
      setState(() {
        _shoppingCartItems.add(item);
        _itemCategories.add(null);
      });
      _textController.clear();
    }
  }

  void _deleteSelectedItem() {
    if (_deleteIndex != null) {
      setState(() {
        _shoppingCartItems.removeAt(_deleteIndex!);
        _itemCategories.removeAt(_deleteIndex!);
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
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 4,
              children: List.generate(_shoppingCartItems.length, (index) {
                final bool isSelected = _deleteIndex == index;
                
                Color containerColor;
                if (isSelected) {
                  containerColor = Colors.red;
                } else {
                  containerColor = Colors.primaries[index % Colors.primaries.length].shade200;
                }
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _deleteIndex = (_deleteIndex == index) ? null : index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: containerColor,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _shoppingCartItems[index],
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            if (_itemCategories[index] != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: RepaintBoundary(
                                  child: CustomPaint(
                                    size: const Size(24, 24),
                                    painter: CategoryCustomPainter(
                                      color: _categories[_itemCategories[index]]!.color,
                                      shape: _categories[_itemCategories[index]]!.shape,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        PopupMenuButton<String>(
                          onSelected: (String value) {
                            setState(() {
                              _itemCategories[index] = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return _categories.keys.map((String category) {
                              return PopupMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList();
                          },
                          icon: const Icon(Icons.menu, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          // TextField for adding new items.
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
          // Button to delete selected item.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _deleteIndex != null ? _deleteSelectedItem : null,
              child: const Text('Delete Selected Item'),
            ),
          ),
        ],
      ),
    );
  }
}
