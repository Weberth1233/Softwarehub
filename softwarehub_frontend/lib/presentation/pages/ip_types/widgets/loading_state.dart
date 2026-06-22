import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  static const Color _backgroundColor = Color(0xFF004294);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: _backgroundColor,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Carregando categorias...",
            style: TextStyle(
              color: _backgroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}