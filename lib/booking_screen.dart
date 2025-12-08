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

  Future<void> _selectPickupDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickupDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _pickupDate = picked;
        // if return date is before pickup, reset it
        if (_returnDate != null && _returnDate!.isBefore(_pickupDate!)) {
          _returnDate = null;
        }
      });
    }
  }

  Future<void> _selectReturnDate() async {
    if (_pickupDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a pick-up date first')),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate ?? _pickupDate!.add(const Duration(days: 1)),
      firstDate: _pickupDate!,
      lastDate: _pickupDate!.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _returnDate = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_pickupDate == null || _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both dates')),
      );
      return;
    }

    final days = _returnDate!.difference(_pickupDate!).inDays.clamp(1, 365);
    // pricePerDay is a string like "45 €/day" -> take first number
    final priceNumber = double.tryParse(
          widget.pricePerDay.split(' ').first.replaceAll('€', ''),
        ) ??
        0;
    final totalPrice = priceNumber * days;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Car: ${widget.carName}'),
            Text('Name: ${_nameController.text}'),
            Text('Phone: ${_phoneController.text}'),
            const SizedBox(height: 8),
            Text('Pick-up: ${_formatDate(_pickupDate!)}'),
            Text('Return: ${_formatDate(_returnDate!)}'),
            Text('Days: $days'),
            const SizedBox(height: 8),
            Text('Total price: ${totalPrice.toStringAsFixed(2)} €'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking confirmed!')),
              );
              Navigator.pop(context); // go back to details screen
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book this car'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car info
              Text(
                widget.carName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Price: ${widget.pricePerDay}',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
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
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 6) {
                    return 'Phone number seems too short';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Dates
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _selectPickupDate,
                      child: Text(
                        _pickupDate == null
                            ? 'Select pick-up date'
                            : 'Pick-up: ${_formatDate(_pickupDate!)}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _selectReturnDate,
                      child: Text(
                        _returnDate == null
                            ? 'Select return date'
                            : 'Return: ${_formatDate(_returnDate!)}',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Submit Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
