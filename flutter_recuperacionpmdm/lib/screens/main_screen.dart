import 'package:flutter/material.dart';
import 'base_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Recuperación de PMDM'
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/Images/MartinCarpena.jpg', width: 100, height: 100),
          Text(
              'El Unicaja amplía su altar del Carpena',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          Text(
              'https://www.diariosur.es/unicaja/unicaja-amplia-altar-martin-carpena-trofeos-20250302130252-nt.html',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Image.asset('assets/Images/MartinCarpena.jpg', width: 100, height: 100),
          Text(
              'Fiesta de los campeones de Copa',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          Text(
              'https://www.laopiniondemalaga.es/fotos/2025/03/02/fiesta-campeones-copa-del-rey-114850543.html',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
           Image.asset('assets/Images/MartinCarpena.jpg', width: 100, height: 100),
          Text(
              'Velada de boxeo en el Martín Carpena',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          Text(
              'https://malaguear.com/eventos/velada-de-boxeo-en-el-martin-carpena/',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
