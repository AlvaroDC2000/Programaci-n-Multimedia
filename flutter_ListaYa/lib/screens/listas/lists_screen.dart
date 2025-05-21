import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/app_routes.dart';
import 'package:googleapis/tasks/v1.dart' as gt;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../drawer/drawer.dart';
import '../../providers/auth_client_provider.dart';

import '../../../services/google_tasks_service.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({Key? key, required authClient}) : super(key: key);

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  List<Map<String, dynamic>> tareas = [];
  bool loading = true;

  late bool esGoogleUser;
  GoogleTasksService? googleService;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    esGoogleUser =
        user?.providerData.any((info) => info.providerId == 'google.com') ??
            false;
    if (esGoogleUser) {
      final client =
          Provider.of<AuthClientProvider>(context, listen: false).authClient;
      googleService = GoogleTasksService(client);
    }
    loadTasks();
  }

  Future<void> loadTasks() async {
    setState(() => loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    esGoogleUser = user.providerData
        .any((info) => info.providerId == 'google.com');

    try {
      final tmp = <Map<String, dynamic>>[];

      if (esGoogleUser && googleService != null) {
        final listas = await googleService!.obtenerListas();
        for (final lista in listas) {
          // Pasamos el parámetro obligatorio `showCompleted: false`
          final tareasLista = await googleService!.obtenerTareas(
            lista.id!,
            showCompleted: false,
          );
          // Filtramos igualmente por si acaso
          final incompletas =
              tareasLista.where((t) => t.status != 'completed');
          for (final t in incompletas) {
            DateTime? fechaLocal;
            if (t.due != null) {
              final dt = DateTime.parse(t.due!);
              // Construye fecha local a medianoche (ignora offset UTC)
              fechaLocal = DateTime(dt.year, dt.month, dt.day);
            }
            tmp.add({
              'id': t.id,
              'titulo': t.title ?? '(Sin título)',
              'descripcion': t.notes ?? '',
              'fecha': fechaLocal,
              'listaId': lista.id,
              'isGoogle': true,
            });
          }
        }
      } else {
        final snap = await FirebaseFirestore.instance
            .collection('tasks')
            .where('uid', isEqualTo: user.uid)
            .orderBy('fecha')
            .get();
        for (final doc in snap.docs) {
          final d = doc.data();
          final ts = d['fecha'] as Timestamp?;
          final fechaLocal = ts?.toDate().toLocal();
          tmp.add({
            'id': doc.id,
            'titulo': d['titulo'] ?? '(Sin título)',
            'descripcion': d['descripcion'] ?? '',
            'fecha': fechaLocal,
            'isGoogle': false,
          });
        }
      }

      setState(() {
        tareas = tmp;
        loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar tareas: $e')),
        );
      }
    }
  }

  Future<void> completarTarea(Map<String, dynamic> tarea) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      if (tarea['isGoogle'] == true &&
          tarea['id'] != null &&
          tarea['listaId'] != null &&
          googleService != null) {
        final completed = gt.Task()
          ..status = 'completed'
          ..completed = DateTime.now()
              .toUtc()
              .toIso8601String();
        await googleService!.completarTarea(
          tarea['listaId'],
          tarea['id'],
          completed,
        );
      }

      await FirebaseFirestore.instance
          .collection('finished_tasks')
          .add({
        'uid': user.uid,
        'titulo': tarea['titulo'],
        'descripcion': tarea['descripcion'],
        'fecha': DateTime.now().toLocal(),
      });

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(tarea['id'])
          .delete();

      await loadTasks();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
          // ignore: use_build_context_synchronously
          context, AppRoutes.finished);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al completar: $e')),
      );
    }
  }

  Future<void> eliminarTarea(Map<String, dynamic> tarea) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      if (tarea['isGoogle'] == true &&
          tarea['id'] != null &&
          tarea['listaId'] != null &&
          googleService != null) {
        await googleService!
            .eliminarTarea(tarea['listaId'], tarea['id']);
      } else {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(tarea['id'])
            .delete();
      }

      await loadTasks();
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
                            final titulo = item['titulo'] ?? '';
                            final descripcion = item['descripcion'] ?? '';

                            final theme = Theme.of(context);
                            final isDark = theme.brightness == Brightness.dark;
                            final cardColor = theme.cardColor;
                            final textColor =
                                theme.textTheme.bodyLarge?.color ??
                                    Colors.black;
                            final shadowColor =
                                isDark ? Colors.transparent : Colors.black12;

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: shadowColor,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Título
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            titulo,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (item['fecha'] != null)
                                          Text(
                                            DateFormat('dd/MM/yyyy – HH:mm')
                                                .format(item['fecha']),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textColor.withAlpha(
                                                  (0.65 * 255).toInt()),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Descripción
                                  if (descripcion.isNotEmpty)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Text(
                                        descripcion,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: textColor
                                              .withAlpha((0.85 * 255).toInt()),
                                        ),
                                      ),
                                    ),
                                  // Botones
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.check_circle,
                                            color: Colors.green.shade400),
                                        onPressed: () => completarTarea(item),
                                        tooltip: 'Marcar como completada',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blueAccent),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/modify',
                                            arguments: {
                                              'initialName': item['titulo'],
                                              'initialDescription':
                                                  item['descripcion'],
                                              'initialDate': item['fecha'],
                                              'taskId': item['id'],
                                              'isGoogleTask':
                                                  item['isGoogle'] ?? false,
                                              'taskListId': item['listaId'],
                                            },
                                          ).then((_) => loadTasks());
                                        },
                                        tooltip: 'Editar lista',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () => eliminarTarea(item),
                                        tooltip: 'Eliminar lista',
                                      ),
                                    ],
                                  ),
                                ],
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
