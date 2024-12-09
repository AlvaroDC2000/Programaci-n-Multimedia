import 'package:flutter/material.dart';

class Formulario1Screen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textEditingControllers = [];
  final List<Widget> _widgets = [];
  final TextEditingController _dateController = TextEditingController();

  Formulario1Screen({super.key}) {
    List<String> fieldNames = [
      "Nombre",
      "Apellidos",
      "Dirección",
      "Dirección 2",
      "Ciudad",
      "Provincia",
      "Código Postal"
    ];
    for (int i = 0; i < fieldNames.length; i++) {
      String fieldName = fieldNames[i];
      TextEditingController textEditingController =
          TextEditingController(text: "");
      _textEditingControllers.add(textEditingController);
      _widgets.add(Padding(
        padding: const EdgeInsets.all(7.0),
        child: _createTextFormField(fieldName, textEditingController),
      ));
    }

    // Añadir el campo de fecha
    _widgets.add(Padding(
      padding: const EdgeInsets.all(7.0),
      child: _createDateField(),
    ));

    _widgets.add(ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() == true) {
          // Procesar datos
          _formKey.currentState?.save();
          ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Formulario enviado correctamente')),
          );
        }
      },
      child: const Text('Guardar'),
    ));
  }

  TextFormField _createTextFormField(
      String fieldName, TextEditingController controller) {
    return TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Por favor, introduzca $fieldName.';
          }
          return null;
        },
        decoration: InputDecoration(
            icon: const Icon(Icons.person),
            hintText: fieldName,
            labelText: 'Introduzca $fieldName'),
        controller: controller);
  }

  Widget _createDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: "Fecha de nacimiento",
        labelText: "Seleccione una fecha",
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: _formKey.currentContext!,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          _dateController.text =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor, seleccione una fecha.';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ejemplo de formularios"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: _widgets,
                ))));
  }
}
