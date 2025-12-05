import 'package:flutter/material.dart';
import 'booking_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final String name;
  final String price;

  const CarDetailsScreen({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Icon(Icons.directions_car, size: 100),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),

            // --- CORRECT BUTTON ---
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      carName: name,
                      pricePerDay: price,
                    ),
                  ),
                );
              },
              child: const Text('Book Now'),
            ),
            // -----------------------

          ],
        ),
      ),
    );
  }
}
