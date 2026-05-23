import 'package:flutter/material.dart';
/*
class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      child: const Center(
        child: Text('home'),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';




class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<CategoryData> categories = [
    CategoryData(name: 'Роллы', icon: Icons.food_bank),
    CategoryData(name: 'Суши', icon: Icons.set_meal),
    CategoryData(name: 'Сашими', icon: Icons.filter_sharp),
    CategoryData(name: 'Нигири', icon: Icons.circle),
    CategoryData(name: 'Гунканы', icon: Icons.bolt),
    CategoryData(name: 'Темпура', icon: Icons.local_fire_department),
    CategoryData(name: 'Рамен', icon: Icons.ramen_dining),
    CategoryData(name: 'Удон', icon: Icons.no_accounts),
    CategoryData(name: 'Донбури', icon: Icons.book_online),
    CategoryData(name: 'Мисо суп', icon: Icons.soup_kitchen),
  ];

  late Map<String, List<MenuItem>> menuItems;

  @override
  void initState() {
    super.initState();
    _generateMenuItems();
    _scrollController.addListener(_onScroll);
  }

  void _generateMenuItems() {
    menuItems = {
      'Роллы': [
        MenuItem(name: 'Калифорния', price: 450, description: 'С крабом, авокадо, огурцом', imageColor: Colors.orange),
        MenuItem(name: 'Филадельфия', price: 520, description: 'С лососем и сливочным сыром', imageColor: Colors.pink),
        MenuItem(name: 'Дракон', price: 580, description: 'С угрем и авокадо', imageColor: Colors.green),
        MenuItem(name: 'Темпура ролл', price: 490, description: 'С креветкой в кляре', imageColor: Colors.brown),
      ],
      'Суши': [
        MenuItem(name: 'Суши с лососем', price: 120, description: 'Свежий лосось', imageColor: Colors.orange),
        MenuItem(name: 'Суши с тунцом', price: 140, description: 'Нежный тунец', imageColor: Colors.red),
        MenuItem(name: 'Суши с угрем', price: 160, description: 'Копченый угорь', imageColor: Colors.brown),
      ],
      'Сашими': [
        MenuItem(name: 'Сашими из лосося', price: 350, description: '4 кусочка', imageColor: Colors.orange),
        MenuItem(name: 'Сашими сет', price: 650, description: 'Ассорти из 6 видов рыбы', imageColor: Colors.blue),
      ],
      'Нигири': [
        MenuItem(name: 'Нигири с лососем', price: 130, description: 'Рис с лососем', imageColor: Colors.orange),
        MenuItem(name: 'Нигири с креветкой', price: 150, description: 'Крупная креветка', imageColor: Colors.pink),
      ],
      'Гунканы': [
        MenuItem(name: 'Гункан с лососем', price: 140, description: 'С лососем и рисом', imageColor: Colors.orange),
        MenuItem(name: 'Гункан с тобико', price: 160, description: 'С икрой летучей рыбы', imageColor: Colors.red),
      ],
      'Темпура': [
        MenuItem(name: 'Темпура с креветкой', price: 320, description: '4 креветки', imageColor: Colors.amber),
        MenuItem(name: 'Овощная темпура', price: 280, description: 'Ассорти овощей', imageColor: Colors.green),
      ],
      'Рамен': [
        MenuItem(name: 'Свиной рамен', price: 420, description: 'С свининой, яйцом, нори', imageColor: Colors.brown),
        MenuItem(name: 'Куриный рамен', price: 380, description: 'С курицей и овощами', imageColor: Colors.orange),
      ],
      'Удон': [
        MenuItem(name: 'Удон с темпурой', price: 390, description: 'Лапша с креветкой', imageColor: Colors.amber),
        MenuItem(name: 'Карри удон', price: 350, description: 'С острым соусом карри', imageColor: Colors.yellow),
      ],
      'Донбури': [
        MenuItem(name: 'Кацу дон', price: 430, description: 'Рис с котлетой и яйцом', imageColor: Colors.brown),
        MenuItem(name: 'Гюдон', price: 450, description: 'Рис с говядиной', imageColor: Colors.red),
      ],
      'Мисо суп': [
        MenuItem(name: 'Мисо суп', price: 120, description: 'С тофу и водорослями', imageColor: Colors.grey),
        MenuItem(name: 'Мисо с морепродуктами', price: 220, description: 'С креветками и мидиями', imageColor: Colors.blue),
      ],
    };
  }

  void _onScroll() {
    _updateSelectedCategory();
  }

  void _updateSelectedCategory() {
    if (_scrollController.hasClients) {
      final double offset = _scrollController.position.pixels;

      // Находим текущую видимую категорию
      for (int i = 0; i < categories.length; i++) {
        final key = categories[i].name;
        final RenderBox? box = _categoryKeys[key]?.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          final double itemTop = box.localToGlobal(Offset.zero).dy;
          final double screenCenter = MediaQuery.of(context).size.height / 2;

          // Если элемент в центре экрана
          if (itemTop < screenCenter && itemTop + box.size.height > screenCenter) {
            if (_selectedCategoryIndex != i) {
              setState(() {
                _selectedCategoryIndex = i;
              });
            }
            break;
          }
        }
      }
    }
  }

  final Map<String, GlobalKey> _categoryKeys = {};
  int _selectedCategoryIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });

    final String categoryName = categories[index].name;
    final GlobalKey? key = _categoryKeys[categoryName];

    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.2, // Прокручиваем так, чтобы заголовок был немного сверху
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Инициализируем ключи для категорий
    for (var category in categories) {
      _categoryKeys.putIfAbsent(category.name, () => GlobalKey());
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя панель с категориями (горизонтальный скролл)
            Container(
              height: 80,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () => _scrollToCategory(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.red[600] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected ? Colors.red[600]! : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            categories[index].icon,
                            size: 20,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            categories[index].name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Список с товарами
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final categoryName = categories[index].name;
                  final items = menuItems[categoryName] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок категории
                      Container(
                        key: _categoryKeys[categoryName],
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        color: Colors.grey[50],
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      // Карточки товаров
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: items.map((item) {
                            return _buildMenuItemCard(item);
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            // Обработка нажатия на товар
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Добавлено: ${item.name}')),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Иконка товара (заглушка)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: item.imageColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: item.imageColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),

                // Информация о товаре
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${item.price} ₽',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),

                // Кнопка добавления
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add_shopping_cart, color: Colors.red[700], size: 24),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.name} добавлен в корзину')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Модели данных
class CategoryData {
  final String name;
  final IconData icon;

  CategoryData({
    required this.name,
    required this.icon,
  });
}

class MenuItem {
  final String name;
  final int price;
  final String description;
  final Color imageColor;

  MenuItem({
    required this.name,
    required this.price,
    required this.description,
    required this.imageColor,
  });
}
