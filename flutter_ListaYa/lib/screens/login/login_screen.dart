import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

//Guardado login
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
    Navigator.pushReplacementNamed(context, AppRoutes.lists);
  } on FirebaseAuthException catch (e) {
    String message;

// Mensajes de error
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


//Login con google
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
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
    return Scaffold(
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
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('Guardar sesión'),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.register),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
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
                    Image.asset(
                      'assets/Images/Google.png',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text('Continuar con Google'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
