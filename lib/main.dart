// lib/main.dart

import 'package:flutter/material.dart';
import 'car.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CarListScreen(),
    );
  }
}

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  // ---------- Demo data ----------
  List<Car> get cars => const [
        Car(
          name: 'Toyota Corolla',
          pricePerDay: 45,
          location: 'Düsseldorf, Germany',
          imagePath: 'assets/images/hyundai.jpg',
          fuelType: 'Petrol',
          transmission: 'Automatic',
          seats: 5,
          description:
              'Comfortable and reliable car, perfect for city trips and weekend getaways. '
              'Clean interior, air conditioning, Bluetooth, and modern safety features.',
        ),
        Car(
          name: 'Volkswagen Golf',
          pricePerDay: 55,
          location: 'Düsseldorf, Germany',
          imagePath: 'assets/images/kia.jpg',
          fuelType: 'Petrol',
          transmission: 'Automatic',
          seats: 5,
          description:
              'Popular hatchback with great handling, ideal for both city driving and longer trips. '
              'Good fuel economy and spacious interior.',
        ),
        Car(
          name: 'BMW 3 Series',
          pricePerDay: 90,
          location: 'Düsseldorf, Germany',
          imagePath: 'assets/images/mercedes.jpg',
          fuelType: 'Petrol',
          transmission: 'Automatic',
          seats: 5,
          description:
              'Premium sedan with powerful engine, high comfort and advanced driver-assistance systems '
              'for long journeys.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cars'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cars.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final car = cars[index];

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  car.imagePath,
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                car.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          car.location,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.local_gas_station, size: 16),
                      const SizedBox(width: 4),
                      Text(car.fuelType),
                      const SizedBox(width: 12),
                      const Icon(Icons.settings, size: 16),
                      const SizedBox(width: 4),
                      Text(car.transmission),
                      const SizedBox(width: 12),
                      const Icon(Icons.event_seat, size: 16),
                      const SizedBox(width: 4),
                      Text('${car.seats} seats'),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    car.formattedPricePerDay,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'per day',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CarDetailsScreen(car: car),
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
