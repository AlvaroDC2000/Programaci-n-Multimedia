import 'package:flutter/material.dart';

class Formulario2Screen extends StatefulWidget {
  const Formulario2Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Formulario2ScreenState createState() => _Formulario2ScreenState();
}

class _Formulario2ScreenState extends State<Formulario2Screen> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _correo = '';
  String _password = '';

  final List<String> _optTipoContrato = [
    'Pack completo',
    'Pack intermedio',
    'Pack básico'
  ];
  String _tipoContrato = 'Pack completo';

  bool _isSwitched = false;
  String? _selectedOption = 'Opción 1';
  bool _packTv = false;
  double _sliderValor = 18.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _crearNombre(),
              const SizedBox(height: 20),
              _crearEmail(),
              const SizedBox(height: 20),
              _crearPassword(),
              const SizedBox(height: 20),
              _crearDesplegable(),
              const SizedBox(height: 20),
              _crearCheckBox(),
              const SizedBox(height: 20),
              _crearSwitch(),
              const SizedBox(height: 20),
              _crearRadio(),
              const SizedBox(height: 20),
              _crearSlider(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarFormulario,
                child: const Text('Guardar'),
              ),
              const SizedBox(height: 20),
              _visualizarDatos(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      onChanged: (valor) => _nombre = valor,
      validator: (value) =>
          value == null || value.isEmpty ? 'Por favor ingresa tu nombre' : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintText: 'Nombre del cliente',
        labelText: 'Nombre',
        helperText: 'Ingrese su nombre completo',
        suffixIcon: const Icon(Icons.person),
        icon: const Icon(Icons.accessibility),
      ),
    );
  }

  Widget _crearEmail() {
    return TextFormField(
      onChanged: (valor) => _correo = valor,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa un correo válido';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Formato de correo inválido';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintText: 'correo@correo.es',
        labelText: 'Email',
        suffixIcon: const Icon(Icons.email),
      ),
    );
  }

  Widget _crearPassword() {
    return TextFormField(
      onChanged: (valor) => _password = valor,
      validator: (value) => value == null || value.length < 6
          ? 'La contraseña debe tener al menos 6 caracteres'
          : null,
      obscureText: true,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintText: 'Contraseña de entrada',
        labelText: 'Contraseña',
        suffixIcon: const Icon(Icons.lock),
      ),
    );
  }

  Widget _crearDesplegable() {
    return DropdownButtonFormField<String>(
      value: _tipoContrato,
      items: _optTipoContrato
          .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
          .toList(),
      onChanged: (valor) {
        setState(() {
          _tipoContrato = valor!;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Tipo de contrato',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _crearCheckBox() {
    return CheckboxListTile(
      title: const Text('Pack TV'),
      value: _packTv,
      onChanged: (nuevoValor) {
        setState(() {
          _packTv = nuevoValor!;
        });
      },
    );
  }

  Widget _crearSwitch() {
    return SwitchListTile(
      title: const Text('Activar Switch'),
      value: _isSwitched,
      onChanged: (value) {
        setState(() {
          _isSwitched = value;
        });
      },
    );
  }

  Widget _crearRadio() {
    return Column(
      children: ['Oferta individual', 'Oferta general', 'Oferta local']
          .map((opcion) => RadioListTile<String>(
                title: Text(opcion),
                value: opcion,
                groupValue: _selectedOption,
                onChanged: (valor) {
                  setState(() {
                    _selectedOption = valor;
                  });
                },
              ))
          .toList(),
    );
  }

  Widget _crearSlider() {
    return Column(
      children: [
        Text('Edad: ${_sliderValor.toInt()}'),
        Slider(
          value: _sliderValor,
          min: 18,
          max: 99,
          divisions: 81,
          label: _sliderValor.toStringAsFixed(0),
          onChanged: (valor) {
            setState(() {
              _sliderValor = valor;
            });
          },
        ),
      ],
    );
  }

  Widget _visualizarDatos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nombre: $_nombre'),
        Text('Correo: $_correo'),
        Text('Contraseña: $_password'),
        Text('Tipo de contrato: $_tipoContrato'),
        Text('Pack TV: ${_packTv ? 'Sí' : 'No'}'),
        Text('Switch: $_isSwitched'),
        Text('Opción Radio: $_selectedOption'),
        Text('Edad: ${_sliderValor.toInt()}'),
      ],
    );
  }

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulario válido')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulario inválido')),
      );
    }
  }
}
