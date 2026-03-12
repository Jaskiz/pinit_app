import 'package:flutter/material.dart';

class PostItWidget extends StatelessWidget {
    final String titulo;
    final Color color;
    final bool tieneChincheta;
    final bool esCumplido;
    final bool esPasado;
    final VoidCallback onTap;

    const PostItWidget({
        super.key,
        required this.titulo,
        required this.color,
        this.tieneChincheta = false,
        this.esCumplido = false,
        this.esPasado = false,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: onTap,
            child: Stack(
                clipBehavior: Clip.none,
                children: [ //Cuerpo del postit
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white, //Fondo blanco del postit
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: color, width: 1.5), //Borde fino del color elegido
                            boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                ),
                            ],
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                    titulo,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.black87,
                                    ),
                                ),
                                const SizedBox(height: 4),
                                if (esCumplido)
                                const Icon(Icons.check_circle, color: Colors.green, size: 20)
                                else if(esPasado)
                                const Icon(Icons.priority_high, color: Colors.red, size: 20),
                            ],
                        ),
                    ),
                    if (tieneChincheta)
                        Positioned(
                            top: -10,
                            left: 0,
                            right: 0,
                            child: Icon(
                                Icons.push_pin,
                                color: Colors.red[900],
                                size: 24,
                            ),
                        ),
                ],
            ),
        );
    }
}