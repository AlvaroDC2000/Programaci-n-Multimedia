import 'package:flutter/material.dart';
import 'screens.dart';

class AppRoutes {
  static const String home = '/';
  static const String personalInfo = '/personal_info';
  static const String rowImages = '/row_images';
  static const String columnImages = '/column_images';
  static const String icons = '/icons';
  static const String helicopters = '/helicopters';
  static const String complexLayout = '/complex_layout';
  static const String counter = '/counter';
  static const String instagram = '/instagram';
  static const String nestedRowsColumns = '/nested_rows_columns';
  static const String game = '/game_screen';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      personalInfo: (context) => const PersonalInfoScreen(),
      rowImages: (context) => const RowImagesScreen(),
      columnImages: (context) => const ColumnImagesScreen(),
      icons: (context) => const IconsScreen(),
      helicopters: (context) => const HelicopterLandingScreen(),
      complexLayout: (context) => const ComplexLayoutScreen(),
      counter: (context) => const CounterScreen(),
      instagram: (context) => const InstagramScreen(),
      nestedRowsColumns: (context) => const NestedRowsColumnsScreen(),
      game: (context) => const GameScreen(),
    };
  }
}
