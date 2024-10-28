import 'package:flutter/material.dart';

class GridViewWidget extends StatelessWidget {
  final List<String> imagePaths;

  const GridViewWidget({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          child: Image.asset(
            imagePaths[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
