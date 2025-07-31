import 'dart:ui';

import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom:mediaQuery.size.height*0.02),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.pinkAccent[100],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imageUrl,
                  width: mediaQuery.size.width*0.5,
                  height: mediaQuery.size.height*0.15,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical:mediaQuery.size.height*0.05,
                  horizontal: mediaQuery.size.width*0.05),
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
