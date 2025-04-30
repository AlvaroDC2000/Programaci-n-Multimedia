import 'package:flutter/material.dart';
import 'package:googleapis/tasks/v1.dart' as gt;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../drawer/drawer.dart';
import '../../providers/auth_client_provider.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({Key? key, required authClient}) : super(key: key);

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  List<Map<String, String>> tareas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final isGoogleUser =
        user.providerData.any((info) => info.providerId == 'google.com');

    try {
      if (isGoogleUser) {
        final authClient =
            Provider.of<AuthClientProvider>(context, listen: false).authClient;
        final api = gt.TasksApi(authClient);
        final result = await api.tasks.list('@default');

        setState(() {
          tareas = result.items?.map((t) {
                return {
                  'titulo': t.title ?? '(Sin título)',
                  'descripcion': t.notes ?? '',
                };
              }).toList() ??
              [];
          loading = false;
        });
      } else {
        final snapshot = await FirebaseFirestore.instance
            .collection('tasks')
            .where('uid', isEqualTo: user.uid)
            .orderBy('fecha', descending: false)
            .get();

        setState(() {
          tareas = snapshot.docs.map<Map<String, String>>((doc) {
            // ignore: unnecessary_cast
            final data = doc.data() as Map<String, dynamic>;
            return {
              'titulo': data['titulo'] ?? '(Sin título)',
              'descripcion': data['descripcion'] ?? '',
            };
          }).toList();
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar tareas: $e')),
        );
      }
    }
  }

  Future<void> completarTarea(Map<String, String> tarea) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final titulo = tarea['titulo'] ?? '';
  final descripcion = tarea['descripcion'] ?? '';

  final isGoogleUser =
      user.providerData.any((info) => info.providerId == 'google.com');

  try {
    if (isGoogleUser) {
      final authClient =
          Provider.of<AuthClientProvider>(context, listen: false).authClient;
      final api = gt.TasksApi(authClient);

      // Buscar la tarea en Google Tasks para obtener el ID
      final result = await api.tasks.list('@default');
      final taskToComplete = result.items?.firstWhere(
        (t) =>
            (t.title ?? '') == titulo && (t.notes ?? '') == descripcion,
        orElse: () => gt.Task(),
      );

      if (taskToComplete != null && taskToComplete.id != null) {
        final completedTask = gt.Task()
          ..status = 'completed'
          ..completed = DateTime.now().toUtc().toIso8601String();

        await api.tasks.patch(completedTask, '@default', taskToComplete.id!);
      }
    } else {
      // Guardar en finished_tasks
      await FirebaseFirestore.instance.collection('finished_tasks').add({
        'uid': user.uid,
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': DateTime.now(),
      });

      // Eliminar de tasks
      final snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('uid', isEqualTo: user.uid)
          .where('titulo', isEqualTo: titulo)
          .where('descripcion', isEqualTo: descripcion)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }

    loadTasks();
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al completar tarea: $e')),
    );
  }
}


  Future<void> eliminarTarea(Map<String, String> tarea) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final titulo = tarea['titulo'] ?? '';
    final descripcion = tarea['descripcion'] ?? '';

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('uid', isEqualTo: user.uid)
          .where('titulo', isEqualTo: titulo)
          .where('descripcion', isEqualTo: descripcion)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }

      loadTasks();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar tarea: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
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

            // Drawer botón
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ],
            ),

            // Título
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(
                  'Mis Listas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Contenido
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : tareas.isEmpty
                      ? const Center(child: Text('No hay tareas guardadas'))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: tareas.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = tareas[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: ListTile(
                                leading: IconButton(
                                  icon: const Icon(Icons.check_circle_outline,
                                      color: Colors.green),
                                  onPressed: () => completarTarea(item),
                                ),
                                title: Text(item['titulo'] ?? ''),
                                subtitle: Text(item['descripcion'] ?? ''),
                                trailing: IconButton(
                                  icon:
                                      const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => eliminarTarea(item),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

