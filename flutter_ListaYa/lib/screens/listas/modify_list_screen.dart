// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../drawer/drawer.dart';
import '../../providers/auth_client_provider.dart';
import '../../../services/google_tasks_service.dart';

class ModifyScreen extends StatefulWidget {
  const ModifyScreen({Key? key, required initialName, required initialDescription, required initialDate, required taskId, required isGoogleTask, required taskListId, required List initialTasks}) : super(key: key);

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  late TextEditingController listNameController;
  late TextEditingController descriptionController;
  DateTime? selectedDate;
  GoogleTasksService? googleService;
  String? taskId;
  String? taskListId;
  bool isGoogleTask = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    listNameController = TextEditingController(text: args['initialName'] ?? '');
    descriptionController = TextEditingController(text: args['initialDescription'] ?? '');
    selectedDate = args['initialDate'];
    isGoogleTask = args['isGoogleTask'] ?? false;
    taskListId = args['taskListId'];
    taskId = args['taskId'];

    if (isGoogleTask) {
      final client = Provider.of<AuthClientProvider>(context, listen: false).authClient;
      googleService = GoogleTasksService(client);
    }
  }

  void pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate ?? now),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> saveList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final title = listNameController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título y fecha son obligatorios')),
      );
      return;
    }

    try {
      if (isGoogleTask && googleService != null) {
        if (taskId != null) {
          await googleService!.actualizarTarea(
            taskListId: taskListId ?? '@default',
            taskId: taskId!,
            titulo: title,
            notas: description,
            fechaHora: selectedDate,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarea modificada (Google Tasks)')),
          );
        } else {
          await googleService!.crearTarea(
            taskListId: taskListId ?? '@default',
            titulo: title,
            notas: description,
            fechaHora: selectedDate,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarea creada (Google Tasks)')),
          );
        }
      } else {
        final taskData = {
          'uid': user.uid,
          'titulo': title,
          'descripcion': description,
          'fecha': selectedDate,
        };

        if (taskId != null) {
          await FirebaseFirestore.instance
              .collection('tasks')
              .doc(taskId)
              .update(taskData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarea modificada (Firestore)')),
          );
        } else {
          await FirebaseFirestore.instance.collection('tasks').add(taskData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarea creada (Firestore)')),
          );
        }
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar cambios: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy – HH:mm');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              child: Image.asset(
                'assets/Images/ListaYaLogo.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Modificar Lista',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: listNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la lista',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: pickDate,
                            child: Text(selectedDate == null
                                ? 'Seleccionar fecha'
                                : dateFormat.format(selectedDate!)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: saveList,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Guardar cambios'),
                    ),
                    const SizedBox(height: 20),
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
