import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../drawer/drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  void guardarCambios() async {
    final nueva = newPasswordController.text.trim();
    final repetir = repeatPasswordController.text.trim();

    if (nueva.isEmpty || repetir.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor rellena ambos campos')),
      );
      return;
    }

    if (nueva != repetir) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    try {
      await user?.updatePassword(nueva);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada correctamente')),
      );
      newPasswordController.clear();
      repeatPasswordController.clear();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  Future<void> eliminarCuenta() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Estás seguro?'),
        content: const Text(
          'Esta acción eliminará tu cuenta y todos tus datos de forma permanente. ¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Eliminar documento de Firestore
        await firestore.collection('usuarios').doc(user!.uid).delete();
        // Eliminar usuario de Auth
        await user?.delete();
        // Navegar fuera
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar cuenta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26C485),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            SizedBox(
              height: 180,
              child: Image.asset(
                'assets/Images/ListaYaLogo.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),

            // Botón drawer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),

            // Título
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Perfil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Correo electrónico',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(user?.email ?? 'correo@ejemplo.com',
                        style: const TextStyle(color: Colors.white)),

                    const SizedBox(height: 24),

                    const Text('Nueva contraseña',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Introduce una nueva contraseña',
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text('Repite la contraseña',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: repeatPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Repite la nueva contraseña',
                      ),
                    ),

                    //Guardar cambio contraseña
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: guardarCambios,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Guardar cambios'),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Cerrar sesión
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('keep_logged_in', false);

                            await FirebaseAuth.instance.signOut();

                            if (!mounted) return;
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (route) => false);
                          } catch (e) {
                            if (mounted) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Error al cerrar sesión: $e')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC8E6C9),
                          foregroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Cerrar sesión',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Eliminar cuenta
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: eliminarCuenta,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Eliminar cuenta',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        ' ListaYa 2025 - App creada por: Álvaro Díaz Casaño ',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
