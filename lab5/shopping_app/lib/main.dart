import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesModel()),
        ChangeNotifierProvider(create: (_) => CategoriesModel()),
      ],
      child: const MyApp(),
    ),
  );
}

enum ShapeType { circle, square, triangle }

class Category {
  final Color color;
  final ShapeType shape;

  Category({required this.color, required this.shape});
}

// Model for managing the dynamic categories mapping.
class CategoriesModel extends ChangeNotifier {
  Map<String, Category> categories = {
    'Beverages': Category(color: Colors.green, shape: ShapeType.circle),
    'Vegetables': Category(color: Colors.orange, shape: ShapeType.square),
    'Sweets': Category(color: Colors.blue, shape: ShapeType.triangle),
  };

  Timer? _timer;

  CategoriesModel() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      updateCategoryColors();
    });
  }

  void updateCategoryColors() {
    final random = Random();
    categories.updateAll((key, category) {
      return Category(
        color: Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        ),
        shape: category.shape,
      );
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// A unified data model for a shopping item including its category.
class ShoppingItem {
  final String name;
  String? category; // Should hold one of the keys from the categories map

  ShoppingItem({required this.name, this.category});
}

// FavoritesModel now stores ShoppingItem objects.
class FavoritesModel extends ChangeNotifier {
  final List<ShoppingItem> _favorites = [];

  List<ShoppingItem> get favorites => _favorites;

  bool isFavorite(ShoppingItem item) {
    return _favorites.contains(item);
  }

  void toggleFavorite(ShoppingItem item) {
    if (_favorites.contains(item)) {
      _favorites.remove(item);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }

  // Called when an item is deleted from the shopping list.
  void removeFavorite(ShoppingItem item) {
    if (_favorites.contains(item)) {
      _favorites.remove(item);
      notifyListeners();
    }
  }
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
  // Use a list of ShoppingItem objects.
  final List<ShoppingItem> _shoppingItems = [];
  final TextEditingController _textController = TextEditingController();
  int? _deleteIndex;
    
  void _addItem(String itemName) {
    if (itemName.isNotEmpty) {
      setState(() {
        _shoppingItems.add(ShoppingItem(name: itemName));
      });
      _textController.clear();
    }
  }
    
  void _deleteSelectedItem() {
    if (_deleteIndex != null) {
      setState(() {
        ShoppingItem removedItem = _shoppingItems[_deleteIndex!];
        _shoppingItems.removeAt(_deleteIndex!);
        // Also remove it from favorites if it exists.
        Provider.of<FavoritesModel>(context, listen: false).removeFavorite(removedItem);
        _deleteIndex = null;
      });
    }
  }
    
  @override
  Widget build(BuildContext context) {
    // Get the CategoriesModel (with up-to-date colors and shapes).
    final categoriesModel = Provider.of<CategoriesModel>(context);
    final categories = categoriesModel.categories;
      
    return Scaffold(
      // Favorites icon moved to the top left.
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesListPage()),
            );
          },
        ),
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
              children: List.generate(_shoppingItems.length, (index) {
                final bool isSelected = _deleteIndex == index;
                final ShoppingItem item = _shoppingItems[index];
                  
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
                        // Display item text and the category icon if assigned.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            if (item.category != null && categories.containsKey(item.category!))
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: RepaintBoundary(
                                  child: CustomPaint(
                                    size: const Size(24, 24),
                                    painter: CategoryCustomPainter(
                                      color: categories[item.category!]!.color,
                                      shape: categories[item.category!]!.shape,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // Star button for toggling favorites.
                        Consumer<FavoritesModel>(
                          builder: (context, favoritesModel, child) {
                            bool isFav = favoritesModel.isFavorite(item);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                              ),
                              onPressed: () {
                                favoritesModel.toggleFavorite(item);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        // Popup menu for choosing a category.
                        PopupMenuButton<String>(
                          onSelected: (String value) {
                            setState(() {
                              item.category = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return categories.keys.map((String category) {
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
          // Button to delete the selected item.
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
    
// FavoritesListPage now displays favorites in a grid with both the item name and its category icon.
class FavoritesListPage extends StatelessWidget {
  const FavoritesListPage({Key? key}) : super(key: key);
    
  @override
  Widget build(BuildContext context) {
    // Get the current categories from the provider.
    final categories = Provider.of<CategoriesModel>(context).categories;
      
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<FavoritesModel>(
        builder: (context, favoritesModel, child) {
          if (favoritesModel.favorites.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          } else {
            return GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 4,
              children: List.generate(favoritesModel.favorites.length, (index) {
                final ShoppingItem item = favoritesModel.favorites[index];
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length].shade200,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display the item text and its category icon if available.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          if (item.category != null && categories.containsKey(item.category!))
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: RepaintBoundary(
                                child: CustomPaint(
                                  size: const Size(24, 24),
                                  painter: CategoryCustomPainter(
                                    color: categories[item.category!]!.color,
                                    shape: categories[item.category!]!.shape,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            );
          }
        },
      ),
    );
  }
}