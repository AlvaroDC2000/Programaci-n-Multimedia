import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/personal_info_screen.dart';
import 'screens/row_images_screen.dart';
import 'screens/column_images_screen.dart';
import 'screens/icons_screen.dart';
import 'screens/helicopter_landing_screen.dart';
import 'screens/complex_layout_screen.dart';
import 'screens/counter_screen.dart';
import 'screens/instagram_screen.dart';
import 'screens/nested_rows_columns.dart';

void main() {
  runApp(const Principal());
}

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/personal_info': (context) => const PersonalInfoScreen(),
        '/row_images': (context) => const RowImagesScreen(),
        '/column_images': (context) => const ColumnImagesScreen(),
        '/icons': (context) => const IconsScreen(),
        '/helicopters': (context) => const HelicopterLandingScreen(),
        '/complex_layout': (context) => const ComplexLayoutScreen(),
        '/counter': (context) => const CounterScreen(),
        '/instagram': (context) => const InstagramScreen(),
        '/nested_rows_columns': (context) => const NestedRowsColumnsScreen(),
      },
    );
  }
}

