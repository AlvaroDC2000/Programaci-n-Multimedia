import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../drawer/drawer.dart';

class ModifyScreen extends StatefulWidget {
  const ModifyScreen({Key? key, required String initialName, required List initialTasks}) : super(key: key);

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController taskTextController = TextEditingController();
  DateTime? selectedDate;

  final List<Map<String, dynamic>> tasks = [];

  void pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void addTask() {
    final text = taskTextController.text.trim();
    if (text.isNotEmpty && selectedDate != null) {
      setState(() {
        tasks.add({
          'descripcion': text,
          'fecha': selectedDate,
        });
        taskTextController.clear();
        selectedDate = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce descripción y fecha')),
      );
    }
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void saveList() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lista guardada')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

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

            // Botón Drawer
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
                  'Modificar Lista',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Formulario y lista
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
