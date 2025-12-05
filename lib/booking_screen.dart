import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  final String carName;
  final String pricePerDay;

  const BookingScreen({
    super.key,
    required this.carName,
    required this.pricePerDay,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _pickupDate;
  DateTime? _returnDate;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _pickDate({
    required bool isPickup,
  }) async {
    final now = DateTime.now();
    final initial = now;
    final newDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (newDate == null) return;

    setState(() {
      if (isPickup) {
        _pickupDate = newDate;
        if (_returnDate != null && _returnDate!.isBefore(newDate)) {
          _returnDate = null;
        }
      } else {
        _returnDate = newDate;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_pickupDate == null || _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select pickup and return dates')),
      );
      return;
    }

    // In the future: send this data to a server / database
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Booking Confirmed'),
        content: Text(
          'Car: ${widget.carName}\n'
          'Price: ${widget.pricePerDay}\n'
          'Name: ${_nameController.text}\n'
          'Phone: ${_phoneController.text}\n'
          'Pickup: ${_pickupDate!.toLocal().toString().split(' ')[0]}\n'
          'Return: ${_returnDate!.toLocal().toString().split(' ')[0]}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to details
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pickupText = _pickupDate == null
        ? 'Select pickup date'
        : _pickupDate!.toLocal().toString().split(' ')[0];

    final returnText = _returnDate == null
        ? 'Select return date'
        : _returnDate!.toLocal().toString().split(' ')[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.carName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Price: ${widget.pricePerDay}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),

              // Pickup date
              Text('Pickup date', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              OutlinedButton(
                onPressed: () => _pickDate(isPickup: true),
                child: Text(pickupText),
              ),
              const SizedBox(height: 12),

              // Return date
              Text('Return date', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              OutlinedButton(
                onPressed: () => _pickDate(isPickup: false),
                child: Text(returnText),
              ),
              const SizedBox(height: 20),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: _submit,
                child: const Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
