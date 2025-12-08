// lib/car.dart

class Car {
  final String name;
  final double pricePerDay; // numeric
  final String imagePath;

  final String location;
  final String fuelType;
  final String transmission;
  final int seats;
  final String description;

  const Car({
    required this.name,
    required this.pricePerDay,
    required this.imagePath,
    required this.location,
    required this.fuelType,
    required this.transmission,
    required this.seats,
    required this.description,
  });

  String get formattedPricePerDay => '${pricePerDay.toStringAsFixed(0)} €/day';
}
