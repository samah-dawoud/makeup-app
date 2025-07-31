class Product {
  final String name;
  final String brand;
  final double price;
  final double rating;
  final String imageLink;
  final List<String> colors;
  final String description;
  final String selectedColor;

  Product({
    required this.name,
    required this.brand,
    required this.price,
    required this.rating,
    required this.imageLink,
    required this.colors,
    required this.description,
    this.selectedColor = 'none',
  });

  factory Product.fromJson(Map<String, dynamic> json, {String selectedColor = 'none'}) {
    return Product(
      name: json['name'] ?? 'Unknown',
      brand: json['brand'] ?? 'Unknown',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) ?? 0.0 : 0.0,
      imageLink: json['image_link'] ?? '',
      colors: json['product_colors'] != null ? (json['product_colors'] as List).map((color) => color['colour_name'] as String).toList() : [],
      description: json['description'] ?? 'No description available',
      selectedColor: selectedColor,
    );
  }
   Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'price': price.toString(),
      'image_link': imageLink,
      'description': description,
      'rating': rating.toString(),
      'colors': colors,
    };
  }
  Product copyWith({String? selectedColor}) {
    return Product(
      name: name,
      brand: brand,
      price: price,
      rating: rating,
      imageLink: imageLink,
      colors: colors,
      description: description,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
