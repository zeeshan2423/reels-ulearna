import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;

  const LoadingIndicator({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 40,
      height: size ?? 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
      ),
    );
  }
}
