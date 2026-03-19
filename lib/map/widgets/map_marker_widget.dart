import 'package:flutter/material.dart';

class MapMarkerWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  const MapMarkerWidget({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),

      padding: const EdgeInsets.all(8),

      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
