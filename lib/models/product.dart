/// Urun modeli - Katalog uygulamasinin temel veri yapisini temsil eder.
/// JSON serializasyon (fromJson/toJson) ve copyWith destegi icerir.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imagePath;
  final double rating;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imagePath,
    this.rating = 0.0,
    this.isFavorite = false,
  });

  /// JSON Map'ten Product nesnesi olusturur (deserialization).
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imagePath: json['imagePath'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  /// Product nesnesini JSON Map'e donusturur (serialization).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imagePath': imagePath,
      'rating': rating,
      'isFavorite': isFavorite,
    };
  }

  /// Mevcut urunu kopyalayarak belirli alanlari degistirir.
  /// Favori durumu degistirme gibi islemlerde kullanilir.
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imagePath,
    double? rating,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
