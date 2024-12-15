import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formulario4Screen extends StatefulWidget {
  const Formulario4Screen({super.key});

  @override
  _Formulario4ScreenState createState() => _Formulario4ScreenState();
}

class _Formulario4ScreenState extends State<Formulario4Screen> {
  bool _isLeftForm = true; // Controla el Switch entre los formularios.
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  // Controladores de los campos de formulario 1
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final List<TextEditingController> _edadHijosControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  int _numeroHijos = 0; // Variable para controlar el número de hijos

  // Controladores de los campos de formulario 2
  DateTime? _fechaNacimiento;
  String? _ciudad;
  final List<String> _aficiones = [];
  String? _sexo;

  // Lista de ciudades de Andalucía
  final List<String> _ciudadesAndalucia = [
    "Sevilla",
    "Granada",
    "Córdoba",
    "Málaga",
    "Jaén",
    "Huelva",
    "Almería",
    "Cádiz"
  ];

  // Expresiones regulares para la validación
  final RegExp _nombreRegex = RegExp(r'^[a-zA-Z\s]+$');
  final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp _telefonoRegex = RegExp(r'^\+?\d{9,15}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario 4ND"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              value: _isLeftForm,
              onChanged: (bool value) {
                setState(() {
                  _isLeftForm = value;
                });
              },
            ),
            Expanded(
              child: _isLeftForm ? _buildFormulario2() : _buildFormulario1(),
            ),
          ],
        ),
      ),
    );
  }

  // Formulario 1: Campos de contacto y niños
  Widget _buildFormulario1() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nombreController,
            decoration: const InputDecoration(labelText: 'Nombre completo'),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !_nombreRegex.hasMatch(value)) {
                return 'Por favor, ingrese un nombre válido';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !_emailRegex.hasMatch(value)) {
                return 'Por favor, ingrese un correo válido';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _telefonoController,
            decoration: const InputDecoration(labelText: 'Teléfono'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !_telefonoRegex.hasMatch(value)) {
                return 'Por favor, ingrese un teléfono válido';
              }
              return null;
            },
          ),
          SwitchListTile(
            title: const Text("¿Tiene hijos?"),
            value: _numeroHijos > 0,
            onChanged: (bool value) {
              setState(() {
                _numeroHijos = value ? 1 : 0; // Resetea el número de hijos
              });
            },
          ),
          if (_numeroHijos > 0) ...[
            const SizedBox(height: 16),
            const Text("¿Cuántos hijos tiene?"),
            DropdownButtonFormField<int>(
              value: _numeroHijos,
              onChanged: (int? newValue) {
                setState(() {
                  _numeroHijos = newValue!;
                });
              },
              items: [1, 2, 3].map((int numero) {
                return DropdownMenuItem<int>(
                  value: numero,
                  child: Text('$numero'),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Número de hijos'),
            ),
            const SizedBox(height: 16),
            const Text("Edad de los hijos"),
            for (int i = 0; i < _numeroHijos; i++) ...[
              TextFormField(
                controller: _edadHijosControllers[i],
                decoration: InputDecoration(labelText: 'Edad hijo ${i + 1}'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Por favor, ingrese una edad válida';
                  }
                  if (int.tryParse(value)! < 0) {
                    return 'La edad no puede ser menor a 0';
                  }
                  return null;
                },
              ),
            ]
          ],
          ElevatedButton(
            onPressed: () {
              if (_formKey1.currentState?.validate() ?? false) {
                // Lógica después de validar el formulario 1
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Formulario 1 válido')));
              }
            },
            child: const Text("Enviar"),
          ),
        ],
      ),
    );
  }

  // Formulario 2: Campos de fecha, ciudad, aficiones y sexo
  Widget _buildFormulario2() {
    return Form(
        key: _formKey2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Fecha de nacimiento'),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _fechaNacimiento = picked;
                    });
                  }
                },
                controller: TextEditingController(
                  text: _fechaNacimiento == null
                      ? ''
                      : DateFormat('dd/MM/yyyy').format(_fechaNacimiento!),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _ciudad,
                onChanged: (String? newValue) {
                  setState(() {
                    _ciudad = newValue;
                  });
                },
                decoration:
                    const InputDecoration(labelText: 'Ciudad de Andalucía'),
                items: _ciudadesAndalucia.map((String ciudad) {
                  return DropdownMenuItem<String>(
                    value: ciudad,
                    child: Text(ciudad),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, seleccione una ciudad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text("Seleccione sus aficiones"),
              ..._buildCheckboxList(),
              const SizedBox(height: 16),
              const Text("Sexo"),
              ..._buildSexoRadios(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey2.currentState?.validate() ?? false) {
                    // Lógica después de validar el formulario 2
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Formulario 2 válido')));
                  }
                },
                child: const Text("Enviar"),
              ),
            ],
          ),
        ));
  }

  List<Widget> _buildCheckboxList() {
    List<String> aficionesList = [
      "Deportes",
      "Música",
      "Cine",
      "Viajes",
      "Lectura"
    ];
    return aficionesList.map((aficion) {
      return CheckboxListTile(
        title: Text(aficion),
        value: _aficiones.contains(aficion),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _aficiones.add(aficion);
            } else {
              _aficiones.remove(aficion);
            }
          });
        },
      );
    }).toList();
  }

  List<Widget> _buildSexoRadios() {
    return [
      RadioListTile<String>(
        title: const Text("Hombre"),
        value: "Hombre",
        groupValue: _sexo,
        onChanged: (String? value) {
          setState(() {
            _sexo = value;
          });
        },
      ),
      RadioListTile<String>(
        title: const Text("Mujer"),
        value: "Mujer",
        groupValue: _sexo,
        onChanged: (String? value) {
          setState(() {
            _sexo = value;
          });
        },
      ),
      RadioListTile<String>(
        title: const Text("Prefiero no contestar"),
        value: "PNC",
        groupValue: _sexo,
        onChanged: (String? value) {
          setState(() {
            _sexo = value;
          });
        },
      ),
    ];
  }
}
