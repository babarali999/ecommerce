import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String tagline;
  // int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.tagline,
    // this.quantity = 1,
  });

  // Existing fromJson method (for dummy JSON data)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '', // Convert to string safely
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _parseDouble(json['price']), // Safe double parsing
      imageUrl: json['imageUrl']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      tagline: json['tagline']?.toString() ?? '',
    );
  }

  // Helper method for safe double parsing
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Convert Product to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'tagline': tagline,
      // 'quantity': quantity,
    };
  }

  // Create Product from Map (for Firestore data) - FIXED
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: _parseDouble(map['price']),
      imageUrl: map['imageUrl']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      tagline: map['tagline']?.toString() ?? '',
      // quantity: map['quantity'] ?? 1,
    );
  }

  // Create Product from Firestore DocumentSnapshot
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      tagline: data['tagline'] ?? '',
      // quantity: data['quantity'] ?? 1,
    );
  }

  // Convert to JSON (useful for debugging)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'tagline': tagline,
    };
  }

  // Override == operator for proper comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  // Override hashCode
  @override
  int get hashCode => id.hashCode;
}