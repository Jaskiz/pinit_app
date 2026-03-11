import 'package:flutter/material.dart';
import '../models/recordatorio_model.dart';

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
  final TextEditingController _horaController = TextEditingController();
  DateTime _fecha = DateTime.now();
  TimeOfDay _hora = TimeOfDay.now();
  String _categoria = 'General';
  bool _guardarComoPlantilla = false;
  String _antelacion = 'Al momento';
  String _tono = 'Predeterminado';
  TimeOfDay _horaSeleccionada = TimeOfDay.now();
  String _categoriaSeleccionada = 'Trabajo';
  String _antelacionSeleccionada = '5 minutos';
  String _tonoSeleccionado = 'Predeterminado';

  @override
  void initState() {
    super.initState();
    _fecha = widget.fechaSeleccionada;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          "Nuevo Recordatorio",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _guardarTodo,
            child: const Text(
              "Guardar",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
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
                hintText: "¿Qué quieres recordar?",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => v!.isEmpty ? "Escribe un título" : null,
            ),
            const SizedBox(height: 15),

            TextFormField(
              //Campo de las notas
              controller: _notasController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Notas adicionales...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            //Fecha y hora
            const Text(
              "Seleccionar fecha y hora",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  //Recuadro de fecha
                  child: GestureDetector(
                    onTap: _seleccionarFecha,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, size: 20),
                          const SizedBox(width: 8),
                          Text("${_fecha.day}/${_fecha.month}/${_fecha.year}"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  //Recuadro de hora
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: _horaController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 5,
                      decoration: const InputDecoration(
                        hintText: "00:00",
                        counterText: "",
                        border: InputBorder.none,
                        icon: Icon(Icons.access_time, size: 20),
                      ),
                      onChanged: (val) {
                        //Lógica para que se pone el : en medio
                        if (val.length == 2 && !_horaController.text.contains(':')) {
                          _horaController.text = "$val:";
                          _horaController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _horaController.text.length),
                          );
                        }

                        //Actualiza la variable cuando se rellena la hora
                        if (val.length == 5) {
                          final partes = val.split(':');
                          final h = int.tryParse(partes[0]);
                          final m = int.tryParse(partes[1]);
                          if (h != null && m != null && h < 24 && m < 60) {
                            setState(() {
                              _hora = TimeOfDay(hour: h, minute: m);
                            });
                          }
                        }
                      }
                    )
                  )
                ),
              ],
            ),

            //Ajustes avanzados
            const Text(
              "Ajustes avanzados",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.settings, color: Colors.black),
                title: const Text("Configurar notificaciones y más"),
                shape: const Border(),
                children: [
                  ListTile(
                    title: const Text("Categoría"),
                    trailing: DropdownButton<String>(
                      value: _categoria,
                      underline: Container(),
                      items: ['General', 'Salud', 'Trabajo', 'Compras']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _categoria = val!),
                    ),
                  ),
                  ListTile(
                    //Antelación
                    title: const Text("Avisar con antelación"),
                    trailing: DropdownButton<String>(
                      value: _antelacion,
                      underline: Container(),
                      items:
                          [
                                'Al momento',
                                '15 min antes',
                                '1 hora antes',
                                '1 día antes',
                              ]
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => _antelacion = val!),
                    ),
                  ),
                  ListTile(
                    //Tono
                    title: const Text("Tono de notificación"),
                    trailing: DropdownButton<String>(
                      value: _tono,
                      underline: Container(),
                      items: ['Predeterminado', 'Suave', 'Alerta', 'Papel']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _tono = val!),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _seleccionarFecha() async {
    DateTime? pick = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pick != null) setState(() => _fecha = pick);
  }

  void _seleccionarHora() async {
    TimeOfDay? pick = await showTimePicker(
      context: context,
      initialTime: _hora,
    );
    if (pick != null) setState(() => _hora = pick);
  }

  void _guardarTodo() {
    if (_formKey.currentState!.validate()) {
      //Creamos el objeto con los datos del formulario
     final nuevoRecordatorio = Recordatorio(
      titulo: _tituloController.text,
      notas: _notasController.text,
      fecha: widget.fechaSeleccionada,
      hora: _horaSeleccionada,
      categoria: _categoriaSeleccionada,
      esPlantilla: false,
      antelacion: _antelacionSeleccionada,
      tono: _tonoSeleccionado,
     );
     Navigator.pop(context, nuevoRecordatorio);
      }
    }
  }
