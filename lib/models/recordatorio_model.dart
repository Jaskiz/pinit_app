import 'package:flutter/material.dart';

class Recordatorio {
  final String id;
  final String titulo;
  final String notas;
  final DateTime fecha;
  final TimeOfDay hora;
  final String categoria;
  final bool esPlantilla;
  final String antelacion;
  final String tono;
  final Color color;

  Recordatorio({
    required this.id,
    required this.titulo,
    required this.notas,
    required this.fecha,
    required this.hora,
    required this.categoria,
    this.esPlantilla = false,
    required this.antelacion,
    required this.tono,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'notas': notas,
      'fecha': fecha.toIso8601String(), // Guardamos fecha como String
      'hora': '${hora.hour}:${hora.minute}', // Guardamos hora como String "HH:mm"
      'categoria': categoria,
      'esPlantilla': esPlantilla ? 1 : 0,
      'antelacion': antelacion,
      'tono': tono,
      'color': color.value, // Guardamos el valor entero del color
    };
  }

  factory Recordatorio.fromMap(Map<String, dynamic> map) {
    final horaParts = (map['hora'] as String).split(':');
    return Recordatorio(
      id: map['id'],
      titulo: map['titulo'],
      notas: map['notas'],
      fecha: DateTime.parse(map['fecha']),
      hora: TimeOfDay(
        hour: int.parse(horaParts[0]),
        minute: int.parse(horaParts[1]),
      ),
      categoria: map['categoria'],
      esPlantilla: map['esPlantilla'] == 1,
      antelacion: map['antelacion'],
      tono: map['tono'],
      color: Color(map['color']),
    );
  }
}