import 'package:flutter/material.dart';

class FormularioScreen extends StatefulWidget {
  final DateTime fechaSeleccionada;

  const FormularioScreen({super.key, required this.fechaSeleccionada});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();
  late DateTime _fecha;
  TimeOfDay _hora = TimeOfDay.now();
  String _categoria = 'General';
  bool _guardarComoPlantilla = false;
  String _antelacion = 'Al momento';
  String _tono = 'Predeterminado';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text("Nuevo Recordatorio", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _guardarTodo,
            child: const Text("Guardar", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _tituloController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hinText: "¿Qué quieres recordar?",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              validator: (v) => v!.isEmpty ? "Escribe un título" : null,
            ),
            const SizedBox(height: 15),
          ]
        )
      )
    )
  }
}