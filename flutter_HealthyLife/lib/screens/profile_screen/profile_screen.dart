import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../routes/app_routes.dart';

// Clase de la pantalla perfil, donde podemos cambiar la contraseña y salir de la sesión
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _passwordController = TextEditingController();

// Cambiar la contraseña
  void _changePassword() async {
    if (user != null && _passwordController.text.isNotEmpty) {
      try {
        await user!.updatePassword(_passwordController.text);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña actualizada exitosamente.')),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar la contraseña.')),
        );
      }
    }
  }

//Salir de la sesión
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Correo: ${user?.email ?? "Correo no disponible"}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Nueva contraseña', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Cambiar Contraseña', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
              ),
            ),
            const Spacer(),
            const Center(
              child: Text(
                'Aplicación HealthyLife hecha por Álvaro Díaz Casaño',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
