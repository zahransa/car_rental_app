import 'package:flutter/material.dart';
import 'booking_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  const CarDetailsScreen({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
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
            // ---------- CAR IMAGE ----------
            Container(
              height: 200,
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.directions_car, size: 80),
              ),
            ),
            // --------------------------------

            const SizedBox(height: 20),

            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              price,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 30),

            // ---------- BOOK NOW BUTTON ----------
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
            // ---------------------------------------
          ],
        ),
      ),
    );
  }
}
