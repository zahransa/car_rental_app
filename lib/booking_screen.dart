// lib/booking_screen.dart

import 'package:flutter/material.dart';
import 'car.dart';

class BookingScreen extends StatefulWidget {
  final Car car;

  const BookingScreen({super.key, required this.car});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  DateTime? _pickupDate;
  DateTime? _returnDate;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isPickup}) async {
    final initialDate = DateTime.now().add(const Duration(days: 1));
    final firstDate = DateTime.now();
    final lastDate = DateTime.now().add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = picked;
          if (_returnDate != null && _returnDate!.isBefore(_pickupDate!)) {
            _returnDate = _pickupDate;
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _showConfirmationDialog() {
    if (_pickupDate == null || _returnDate == null) return;

    final days =
        _returnDate!.difference(_pickupDate!).inDays.clamp(1, 365); // ≥ 1

    final dailyPrice = widget.car.pricePerDay;
    final totalPrice = dailyPrice * days;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Car: ${widget.car.name}'),
            Text('Name: ${_nameController.text}'),
            Text('Phone: ${_phoneController.text}'),
            Text('Pick-up: ${_pickupDate!.toLocal().toString().split(' ').first}'),
            Text('Return: ${_returnDate!.toLocal().toString().split(' ').first}'),
            Text('Days: $days'),
            Text('Total price: ${totalPrice.toStringAsFixed(2)} €'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking confirmed (demo only).'),
                ),
              );
              Navigator.pop(context); // back to details
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _pickupDate == null ||
        _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select dates.'),
        ),
      );
      return;
    }
    _showConfirmationDialog();
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book this car'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              car.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Price: ${car.formattedPricePerDay}'),
            const SizedBox(height: 24),
            const Text('Your Name'),
            const SizedBox(height: 4),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Phone Number'),
            const SizedBox(height: 4),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(isPickup: true),
                    child: Text(
                      _pickupDate == null
                          ? 'Select pick-up date'
                          : 'Pick-up: ${_pickupDate!.toLocal().toString().split(' ').first}',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(isPickup: false),
                    child: Text(
                      _returnDate == null
                          ? 'Select return date'
                          : 'Return: ${_returnDate!.toLocal().toString().split(' ').first}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
