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
  TimeOfDay _horaSeleccionada = TimeOfDay.now();
  String _categoria = 'General';
  bool _guardarComoPlantilla = false;
  String _antelacion = 'Al momento';
  String _tono = 'Predeterminado';
  String _categoriaSeleccionada = 'General';
  String _antelacionSeleccionada = '5 minutos';
  String _tonoSeleccionado = 'Predeterminado';
  Color _colorSeleccionado = const Color(0xFFFFD700);
  int _antelacionMinutos = 0;
  String _textoAntelacion = 'Al momento';

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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                        if (val.length == 2 &&
                            !_horaController.text.contains(':')) {
                          _horaController.text = "$val:";
                          _horaController
                              .selection = TextSelection.fromPosition(
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
                              _horaSeleccionada = TimeOfDay(hour: h, minute: m);
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            //Ajustes avanzados
            const SizedBox(height: 25),
            const Text(
              "Ajustes avanzados",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                      value:
                          _categoriaSeleccionada, // Asegúrate de que esta variable sea la que usas
                      items: ['Trabajo', 'Personal', 'Salud', 'General'].map((
                        String valor,
                      ) {
                        return DropdownMenuItem<String>(
                          value: valor,
                          child: Text(valor),
                        );
                      }).toList(),
                      onChanged: (nuevoValor) {
                        setState(() {
                          _categoriaSeleccionada =
                              nuevoValor!; // Actualiza el estado
                        });
                      },
                    ),
                  ),
                  ListTile(
                    // Antelación
                    title: const Text("Avisar con antelación"),
                    trailing: DropdownButton<String>(
                      value: ['Al momento', '15 min antes', '1 hora antes', '1 día antes'].contains(_textoAntelacion) 
                             ? _textoAntelacion : 'Personalizar',
                      underline: Container(),
                      items: [
                        'Al momento', 
                        '15 min antes', 
                        '1 hora antes', 
                        '1 día antes', 
                        'Personalizar'
                      ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) {
                        if (val == 'Personalizar') {
                          _mostrarDialogoPersonalizarAntelacion();
                        } else {
                          setState(() {
                            _textoAntelacion = val!;
                            _antelacion = val; 
                            if (val == 'Al momento') _antelacionMinutos = 0;
                            if (val == '15 min antes') _antelacionMinutos = 15;
                            if (val == '1 hora antes') _antelacionMinutos = 60;
                            if (val == '1 día antes') _antelacionMinutos = 1440;
                          });
                        }
                      },
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
                  const Divider(), // Una línea fina para separar
                  ListTile(
                    title: const Text("Color de la nota"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _colorSeleccionado,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    onTap: _abrirPaletaColores, // Llama a la paleta
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
      builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.black,       // Color de la cabecera y del día seleccionado
            onPrimary: Colors.white,     // Color del texto sobre el primary
            surface: Colors.white,       // Fondo del calendario
            onSurface: Colors.black,     // Color del texto de los días
          ),
          dialogBackgroundColor: Colors.white, // Fondo del diálogo
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // Color de los botones "Aceptar/Cancelar"
            ),
          ),
        ),
        child: child!,
      );
    },
    );
    if (pick != null) setState(() => _fecha = pick);
  }

  void _seleccionarHora() async {
    TimeOfDay? pick = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada,
    );
    if (pick != null) {
      setState(() {
        _horaSeleccionada = pick;
        _horaController.text = pick.format(context);
      });
    }
  }

  void _guardarTodo() {
    if (_formKey.currentState!.validate()) {
      //Creamos el objeto con los datos del formulario
      final nuevoRecordatorio = Recordatorio(
        id: DateTime.now().toIso8601String(), //Id único basado en el tiempo
        titulo: _tituloController.text,
        notas: _notasController.text,
        fecha: _fecha,
        hora: _horaSeleccionada,
        categoria: _categoriaSeleccionada,
        esPlantilla: false,
        antelacion: _textoAntelacion,
        antelacionMinutos: _antelacionMinutos,
        tono: _tonoSeleccionado,
        color: _colorSeleccionado,
      );
      Navigator.pop(context, nuevoRecordatorio);
    }
  }

  void _abrirPaletaColores() {
    // Lista de colores
    final List<Color> misColores = [
      const Color.fromARGB(255, 228, 0, 0), // Rojo fuerte
      Colors.pink, // Rosa
      Colors.purple, // Morado
      Colors.deepPurple, // Violeta oscuro
      Colors.indigo, // Añil
      Colors.blue, // Azul real
      Colors.lightBlue, // Azul cielo
      Colors.cyan, // Cian
      Colors.teal, // Verde azulado
      Colors.green, // Verde bosque
      Colors.lightGreen, // Verde lima
      Colors.lime, // Lima
      Colors.yellow, // Amarillo puro
      Colors.amber, // Ámbar
      const Color(0xFFFFD700), // Oro/Post-it
      Colors.orange, // Naranja
      Colors.deepOrange, // Naranja fuerte
      Colors.brown, // Marrón
      Colors.grey, // Gris
      Colors.black, // Negro
    ];

    Widget _buildColorOption(Color color) {
      return GestureDetector(
        onTap: () => setState(() => _colorSeleccionado = color),
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: _colorSeleccionado == color
                  ? Colors.black
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Elige un color"),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 5 por fila para que quepan los 20
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: misColores.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() => _colorSeleccionado = misColores[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: misColores[index],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoPersonalizarAntelacion() {
    int d = 0, h = 0, m = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text("Antelación personalizada"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Con cuánto tiempo de antelación quieres recibir el recordatorio?"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSelectorTiempo("Días", 31, (v) => d = v),
                _buildSelectorTiempo("Horas", 24, (v) => h = v),
                _buildSelectorTiempo("Min", 60, (v) => m = v),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _antelacionMinutos = (d * 1440) + (h * 60) + m;
                _textoAntelacion = "${d}d ${h}h ${m}m antes";
              });
              Navigator.pop(context);
            },
            child: const Text("Aceptar", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorTiempo(String etiqueta, int max, Function(int) onChange) {
    return Column(
      children: [
        Text(etiqueta, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        SizedBox(
          height: 100,
          width: 50,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 30,
            perspective: 0.0005,
            diameterRatio: 1.2,
            onSelectedItemChanged: onChange,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: max,
              builder: (context, index) => Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: const TextStyle(fontSize: 18, 
                  fontWeight: FontWeight.normal, 
                  color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
