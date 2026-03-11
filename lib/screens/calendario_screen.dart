import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/post_it_widget.dart';
import 'package:intl/intl.dart';
import 'formulario_screen.dart';
import '../models/recordatorio_model.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime _diaEnfocado = DateTime.now();
  DateTime _diaSeleccionado = DateTime.now();
  Map<DateTime, List<Recordatorio>> _notasPorDia = {};

  DateTime _normalizarFecha(DateTime date) {
    //Función para que coincida los días y no las horas
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> _abrirFormulario() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FormularioScreen(fechaSeleccionada: _diaSeleccionado),
      ),
    );

    if (resultado != null && resultado is Recordatorio) {
      setState(() {
        DateTime fechaKey = _normalizarFecha(resultado.fecha);
        final listaExistence = _notasPorDia[fechaKey] ?? [];
        if (_notasPorDia[fechaKey] == null) {
          _notasPorDia[fechaKey] = [];
        }

        bool yaExiste = _notasPorDia[fechaKey]!.any(
          (r) => r.id == resultado.id,
        );

        if (!yaExiste) {
          _notasPorDia[fechaKey]!.add(resultado);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double tamanoTexto = 20.0;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 20),
          child: Text(
            "Mis Pins",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TableCalendar(
              //EL CUERPO DEL CALENDARIO
              locale: 'es_ES', // Idioma español
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _diaEnfocado,
              startingDayOfWeek: StartingDayOfWeek.monday, // Empieza en Lunes
              rowHeight: 60, //Un poco de espacio entre las filas
              //Cabecera del mes
              headerStyle: const HeaderStyle(
                formatButtonVisible: false, // Esto quita lo de "2 weeks"
                titleCentered: true, // Centra el mes (ej: "febrero 2026")
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              //Estilo de los nombres de los días
              daysOfWeekHeight: 40,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                weekendStyle: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              calendarStyle: CalendarStyle(
                outsideDaysVisible: true, //Para ver los dias de otros meses
                //Unificación tamaño números
                defaultTextStyle: const TextStyle(
                  fontSize: tamanoTexto,
                  fontWeight: FontWeight.w400,
                ),
                weekendTextStyle: const TextStyle(
                  fontSize: tamanoTexto,
                  color: Colors.redAccent,
                ),
                outsideTextStyle: const TextStyle(
                  fontSize: tamanoTexto,
                  color: Colors.black26,
                ), // Días de otros meses más tenues
                //Modelo día seleccionado
                selectedDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  fontSize: tamanoTexto,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                //Modelo día "hoy"
                todayDecoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 1.5),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: const TextStyle(
                  fontSize: tamanoTexto,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 4. Marcadores (Los puntitos de colores)
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  //Primero se comprueba si hay notas para el día que está seleccionado
                  final notasDeEseDia =
                      _notasPorDia[_normalizarFecha(date)] ?? [];

                  if (notasDeEseDia.isNotEmpty) {
                    return Positioned(
                      bottom: 5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...notasDeEseDia.take(3).map((nota) {
                            //Máximo 3 bolitas
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white, // El brillo central
                                    nota.color, // El amarillo (Gold)
                                  ],
                                  center: Alignment(
                                    0.4,
                                    -0.4,
                                  ), // Posición del reflejo
                                  radius: 0.6,
                                  stops: [0.1, 0.9],
                                ),
                              ),
                            );
                          }).toList(),
                          if (notasDeEseDia.length > 3)
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                "+${notasDeEseDia.length - 3}",
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  height: 1.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                  return null;
                },
              ),

              selectedDayPredicate: (day) => isSameDay(_diaSeleccionado, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _diaSeleccionado = selectedDay;
                  _diaEnfocado = focusedDay;
                });
              },
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notas del ${_diaSeleccionado.day} de ${DateFormat('MMMM', 'es_ES').format(_diaSeleccionado)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child:
                        _notasPorDia[_normalizarFecha(_diaSeleccionado)] ==
                                null ||
                            _notasPorDia[_normalizarFecha(_diaSeleccionado)]!
                                .isEmpty
                        ? const Center(
                            child: Text("No hay notas para este día"),
                          )
                        : ListView.builder(
                            itemCount:
                                _notasPorDia[_normalizarFecha(_diaSeleccionado)]
                                    ?.length ??
                                0,
                            itemBuilder: (context, index) {
                              final lista =
                                  _notasPorDia[_normalizarFecha(
                                    _diaSeleccionado,
                                  )]!;
                              final recordatorio = lista[index];
                              return GestureDetector(
                                onTap: () {
                                  _mostrarDetallesNota(context, recordatorio);
                                },
                                child: Card(
                                  color: recordatorio.color.withOpacity(0.4),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    title: Text(
                                      recordatorio.titulo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${recordatorio.categoria} • ${recordatorio.hora.format(context)}",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ); // Cerramos el gesture detector
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        //Botón de crear recordatorio
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.add, color: Colors.blue),
                    title: const Text(
                      "Nuevo recordatorio",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      //Esto hace que espere
                      Navigator.pop(context);
                      _abrirFormulario(); //Cierra el menú
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.copy, color: Colors.orange),
                    title: const Text(
                      'Utilizar plantilla guardada',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  void _mostrarDetallesNota(BuildContext context, Recordatorio nota) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: nota.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          nota.titulo,
          style: TextStyle(
            color: nota.color.computeLuminance() < 0.5
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 5),
                Text(nota.hora.format(context)),
              ],
            ),
            const SizedBox(height: 10),
            Text("Categoría: ${nota.categoria}"),
            const Divider(height: 25),
            Text(nota.notas.isEmpty ? "Sin notas adicionales" : nota.notas),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }
}
