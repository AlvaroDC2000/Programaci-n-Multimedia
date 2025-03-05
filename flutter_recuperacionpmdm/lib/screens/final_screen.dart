import 'package:flutter/material.dart';
import 'base_screen.dart';

class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Recuperación de PMDM',
      body: 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Autor: Álvaro Díaz Casaño',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          Text(
              'Dirección: Calle Abacete N17, Málaga',
              style: Theme.of(context).textTheme.bodyMedium,
              ),
          Text(
              'Telefono: Telefono:949492992',
              style: Theme.of(context).textTheme.bodyMedium,
              ),
          Text(
              'Correo: alvaroestepona00@gmail.com',
              style: Theme.of(context).textTheme.bodyMedium,
              ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () { },
              child: const Text('TextButton'),
            )
        ],
      ),
      
    );
  }
}
