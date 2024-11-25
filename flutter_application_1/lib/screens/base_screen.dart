import 'package:flutter/material.dart';
import '../drawer/drawer.dart'; 

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();  // Usamos Scaffold.of(context) dentro de Builder
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: body,
    );
  }
}
