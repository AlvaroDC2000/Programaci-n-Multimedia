import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      indicatorColor: Colors.black,
      labelColor: Color.fromARGB(255, 88, 88, 88),
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(icon: Icon(Icons.grid_on)),
        Tab(icon: Icon(Icons.person_pin)),
      ],
    );
  }
}
