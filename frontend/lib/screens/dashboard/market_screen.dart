import 'package:flutter/material.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'name': 'Laptop',
        'price': 1200,
        'image': 'https://via.placeholder.com/200'
      },
      {
        'name': 'Bike',
        'price': 300,
        'image': 'https://via.placeholder.com/200'
      },
      {
        'name': 'Guitar',
        'price': 150,
        'image': 'https://via.placeholder.com/200'
      },
      {
        'name': 'Chair',
        'price': 50,
        'image': 'https://via.placeholder.com/200'
      },
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Ink.image(
                  image: NetworkImage(item['image'] as String),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('\$${item['price']}'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Покупка недоступна')),
                        );
                      },
                      child: const Text('Купить'),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
