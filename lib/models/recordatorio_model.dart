import 'package:flutter/material.dart';

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
}