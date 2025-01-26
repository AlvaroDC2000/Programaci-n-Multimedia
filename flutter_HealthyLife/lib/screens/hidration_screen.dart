import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../drawer/drawer.dart';
import '../main.dart';

class HydrationScreen extends StatelessWidget {
  const HydrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidratación'),
        backgroundColor: const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummerWarning(context),
              const SizedBox(height: 20),
              const Text(
                'Registra tus vasos de agua diarios:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.water_drop, color: Colors.blue),
                    title: Text('Vaso ${index + 1}'),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Lógica para un nuevo vaso
                },
                child: const Text('Registrar vaso de agua'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummerWarning(BuildContext context) {
    final currentMonth = DateTime.now().month;
    final isSummer = [6, 7, 8].contains(currentMonth);

    if (!isSummer) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow[700]!),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Es verano. ¡Recuerda beber más agua para mantenerte hidratado!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
