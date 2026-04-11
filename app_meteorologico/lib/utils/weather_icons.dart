import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getIcon(String? description) {
    if (description == null) return Icons.cloud_outlined;
    
    final desc = description.toLowerCase();
    
    if (desc.contains('sol') || desc.contains('claro') || desc.contains('céu')) {
      return Icons.wb_sunny;
    }
    if (desc.contains('nuvem') || desc.contains('nublado') || desc.contains('parcial')) {
      return Icons.cloud;
    }
    if (desc.contains('chuva') || desc.contains('garoa') || desc.contains('precipitação')) {
      return Icons.umbrella;
    }
    if (desc.contains('tempestade') || desc.contains('trovoada') || desc.contains('raio')) {
      return Icons.thunderstorm;
    }
    if (desc.contains('neve') || desc.contains('frio extremo')) {
      return Icons.ac_unit;
    }
    if (desc.contains('neblina') || desc.contains('névoa')) {
      return Icons.foggy;
    }
    
    return Icons.cloud_outlined;
  }

  static List<Color> getBackgroundGradient(String? description) {
    if (description == null) return [Colors.blue.shade400, Colors.blue.shade700];
    
    final desc = description.toLowerCase();
    
    if (desc.contains('sol') || desc.contains('claro')) {
      return [Colors.orange.shade300, Colors.yellow.shade600];
    }
    if (desc.contains('nuvem') || desc.contains('nublado')) {
      return [Colors.grey.shade400, Colors.blueGrey.shade700];
    }
    if (desc.contains('chuva') || desc.contains('tempestade')) {
      return [Colors.blueGrey.shade600, Colors.indigo.shade900];
    }
    if (desc.contains('neve')) {
      return [Colors.lightBlue.shade100, Colors.blue.shade300];
    }
    
    return [Colors.blue.shade400, Colors.blue.shade700];
  }

  static Widget? getWeatherAnimation(String? description, {double size = 100}) {
    final desc = description?.toLowerCase() ?? '';
    
    if (desc.contains('chuva')) {
      return _RainAnimation(size: size);
    }
    if (desc.contains('sol') || desc.contains('claro')) {
      return _SunAnimation(size: size);
    }
    return null;
  }
}

class _RainAnimation extends StatefulWidget {
  final double size;
  const _RainAnimation({required this.size});

  @override
  State<_RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<_RainAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size * 0.6),
          painter: _RainPainter(progress: _controller.value),
        );
      },
    );
  }
}

class _RainPainter extends CustomPainter {
  final double progress;
  _RainPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 5; i++) {
      final x = (i * size.width / 5) + (size.width / 10);
      final startY = (progress * 1.2 + i * 0.2) % 1.2 * size.height;
      final endY = startY + 20;
      
      if (startY < size.height) {
        canvas.drawLine(
          Offset(x, startY),
          Offset(x + 5, endY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class _SunAnimation extends StatefulWidget {
  final double size;
  const _SunAnimation({required this.size});

  @override
  State<_SunAnimation> createState() => _SunAnimationState();
}

class _SunAnimationState extends State<_SunAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        Icons.wb_sunny,
        size: widget.size,
        color: Colors.yellow.shade300,
      ),
    );
  }
}