import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../../providers/auth_client_provider.dart';
import '../../routes/app_routes.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool rememberMe = false;

  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('keep_logged_in', true);
      }

      // ignore: use_build_context_synchronously
      final appSettings = Provider.of<AppSettings>(context, listen: false);
      await loadUserSettings(appSettings);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, AppRoutes.lists);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No se encontró ningún usuario con ese correo.';
          break;
        case 'wrong-password':
          message = 'La contraseña es incorrecta.';
          break;
        case 'invalid-email':
          message = 'El correo no es válido.';
          break;
        case 'user-disabled':
          message = 'Este usuario ha sido deshabilitado.';
          break;
        default:
          message = 'Error al iniciar sesión: ${e.message}';
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/tasks'],
      ).signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final doc = await firestore.collection('usuarios').doc(user.uid).get();

        if (!doc.exists) {
          await firestore.collection('usuarios').doc(user.uid).set({
            'email': user.email,
            'fechaRegistro': FieldValue.serverTimestamp(),
            'autenticadoCon': 'Google',
          });
        }

        // Guardar preferencia si desea mantener sesión
        if (rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('keep_logged_in', true);
        }

        // Cargar configuración del usuario desde Firestore
        // ignore: use_build_context_synchronously
        final appSettings = Provider.of<AppSettings>(context, listen: false);
        await loadUserSettings(appSettings);

        // Crear authClient para Google Tasks API
        final authClient = authenticatedClient(
          http.Client(),
          AccessCredentials(
            AccessToken(
              'Bearer',
              googleAuth!.accessToken!,
              DateTime.now().toUtc().add(const Duration(hours: 1))
            ),
            null,
            ['https://www.googleapis.com/auth/tasks'],
          ),
        );

        // ignore: use_build_context_synchronously
        Provider.of<AuthClientProvider>(context, listen: false)
            .setAuthClient(authClient);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRoutes.lists);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error con Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF26C485);
    final fixedTheme = ThemeData(
      scaffoldBackgroundColor: primary,
      primaryColor: primary,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: GoogleFonts.poppins(
          fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        bodyMedium: const TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.white70),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(Colors.white),
        checkColor: WidgetStateProperty.all(primary),
      ),
    );

    return Theme(
      data: fixedTheme,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 180,
                  child: Image.asset(
                    'assets/Images/ListaYaLogo.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Iniciar Sesión',
                  textAlign: TextAlign.center,
                  style: fixedTheme.textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration:
                      const InputDecoration(labelText: 'Correo electrónico'),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (v) => setState(() => rememberMe = v ?? false),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Guardar sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: login,
                  child: const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.register),
                  child: const Text('Registrar nuevo usuario'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: loginWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/Images/Google.png',
                          height: 24, width: 24),
                      const SizedBox(width: 12),
                      const Text('Continuar con Google'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    emailController.text = 'usuario@gmail.com';
                    passwordController.text = '123456';
                    await login();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Acceder como usuario de prueba'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}