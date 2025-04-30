import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../drawer/drawer.dart';

class FinishedScreen extends StatefulWidget {
  const FinishedScreen({super.key});

  @override
  State<FinishedScreen> createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  List<Map<String, dynamic>> listasFinalizadas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFinishedTasks();
  }

  Future<void> loadFinishedTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('finished_tasks')
          .where('uid', isEqualTo: user.uid)
          .orderBy('fecha', descending: true)
          .get();

      setState(() {
        listasFinalizadas = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'titulo': data['titulo'] ?? '',
            'fecha': (data['fecha'] as Timestamp).toDate(),
          };
        }).toList();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar finalizadas: $e')),
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
      body: Column(
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
                'Listas Completadas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : listasFinalizadas.isEmpty
                    ? const Center(child: Text('No hay listas completadas'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: listasFinalizadas.length,
                        itemBuilder: (context, index) {
                          final lista = listasFinalizadas[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
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
                              leading: const Icon(Icons.check_circle, color: Colors.green),
                              title: Text(lista['titulo'] ?? ''),
                              subtitle: Text(
                                'Finalizada el ${lista['fecha'].day}/${lista['fecha'].month}/${lista['fecha'].year}',
                              ),
                              trailing: const Icon(Icons.check),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
