import 'package:flutter/material.dart';
import 'car_details.dart';

void main() {
  runApp(const CarRentalApp());
}

class CarRentalApp extends StatelessWidget {
  const CarRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Car Rental',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CarListScreen(),
    );
  }
}

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cars = [
  {
    'name': 'Toyota Corolla',
    'price': '45 €/day',
    'imageUrl':
        'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg',
  },
  {
    'name': 'Volkswagen Golf',
    'price': '55 €/day',
    'imageUrl':
        'https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg',
  },
  {
    'name': 'BMW 3 Series',
    'price': '90 €/day',
    'imageUrl':
        'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg',
  },
];

    

    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cars'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cars.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final car = cars[index];

          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(car['name']!),
              subtitle: Text(car['price']!),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CarDetailsScreen(
                      name: car['name']!,
                      price: car['price']!,
                      imageUrl: car['imageUrl']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add Car'),
      ),
    );
  }
}
