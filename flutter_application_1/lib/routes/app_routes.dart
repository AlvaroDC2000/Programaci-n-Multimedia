import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  AppRoutes({required this.isDarkMode, required this.toggleTheme});

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
  static const String sieteYMedia = '/siete_y_media';
  static const String formSelection = '/form_selection';
  static const String formulario1 = '/formulario1';
  static const String formulario2 = '/formulario2';
  static const String formulario3 = '/formulario3';

  Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.home: (context) => HomeScreen(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
      ),
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
      sieteYMedia: (context) => const SieteYMediaScreen(),
      formSelection: (context) => const FormSelectionScreen(),
      formulario1: (context) => const Formulario1Screen(),
      formulario2: (context) =>  const Formulario2Screen(),
      formulario3: (context) =>  const Formulario3Screen(),
    };
  }
}
