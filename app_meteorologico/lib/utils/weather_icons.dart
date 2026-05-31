import 'package:flutter/material.dart';
import 'dart:math' as math;

class WeatherIcons {
  // Retorna gradiente baseado na condição
  static List<Color> getBackgroundGradient(String? description) {
    final desc = description?.toLowerCase() ?? '';
    
    // ☀️ SOL / CLARO (Laranja/Amarelo)
    if (desc.contains('sol') || desc.contains('clear') || desc.contains('sunny') || desc.contains('céu limpo')) {
      return [Colors.orange.shade400, Colors.amber.shade600];
    }
    
    // 🌧️ CHUVA (Azul Escuro/Cinza)
    if (desc.contains('chuva') || desc.contains('rain') || desc.contains('drizzle') || desc.contains('shower')) {
      return [Colors.blueGrey.shade700, Colors.indigo.shade900];
    }
    
    // ⛈️ TEMPESTADE (Roxo Escuro)
    if (desc.contains('tempestade') || desc.contains('storm') || desc.contains('thunder')) {
      return [Colors.purple.shade800, Colors.indigo.shade900];
    }
    
    // ☁️ NUVENS (Cinza/Azul Claro)
    if (desc.contains('nuvem') || desc.contains('cloud') || desc.contains('nublado') || desc.contains('parcial')) {
      return [Colors.blueGrey.shade400, Colors.blueGrey.shade600];
    }
    
    // ❄️ FRIO/NEVE (Azul Claro/Branco)
    if (desc.contains('neve') || desc.contains('snow') || desc.contains('frio')) {
      return [Colors.lightBlue.shade200, Colors.blue.shade400];
    }
    
    // 🔥 QUENTE (Vermelho/Laranja)
    if (desc.contains('quente') || desc.contains('hot')) {
      return [Colors.red.shade400, Colors.orange.shade600];
    }
    
    // Padrão (Azul)
    return [Colors.blue.shade400, Colors.blue.shade700];
  }

  // Retorna a animação principal
  static Widget getWeatherAnimation(String? description, {double size = 120}) {
    final desc = description?.toLowerCase() ?? '';
    
    if (desc.contains('chuva') || desc.contains('rain') || desc.contains('drizzle')) {
      return RainAnimation(size: size);
    }
    if (desc.contains('sol') || desc.contains('clear') || desc.contains('sunny')) {
      return SunAnimation(size: size);
    }
    if (desc.contains('nuvem') || desc.contains('cloud') || desc.contains('overcast')) {
      return CloudAnimation(size: size);
    }
    if (desc.contains('tempestade') || desc.contains('storm')) {
      return ThunderAnimation(size: size);
    }
    
    return DefaultIcon(size: size);
  }
}

// ☀️ Sol com brilho pulsante
class SunAnimation extends StatefulWidget {
  final double size;
  const SunAnimation({super.key, required this.size});

  @override
  State<SunAnimation> createState() => _SunAnimationState();
}

class _SunAnimationState extends State<SunAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat();
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size * 1.4,
              height: widget.size * 1.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.4 * _scaleAnimation.value),
                    blurRadius: 30 * _scaleAnimation.value,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            Icon(Icons.wb_sunny, size: widget.size, color: Colors.amber.shade300),
          ],
        );
      },
    );
  }
}

// 🌧️ Chuva com múltiplas gotas
class RainAnimation extends StatefulWidget {
  final double size;
  const RainAnimation({super.key, required this.size});

  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this)..repeat();
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.9,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Icon(Icons.cloud, size: widget.size * 0.7, color: Colors.grey.shade300),
          ),
          CustomPaint(painter: RainPainter(progress: _controller.value)),
        ],
      ),
    );
  }
}

class RainPainter extends CustomPainter {
  final double progress;
  RainPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.lightBlueAccent.withOpacity(0.8);
    
    for (int i = 0; i < 5; i++) {
      final x = (i * size.width / 5) + (size.width / 10);
      final y = ((progress + i * 0.2) % 1.2) * size.height;
      if (y < size.height) {
        canvas.drawCircle(Offset(x, y), 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RainPainter oldDelegate) => progress != oldDelegate.progress;
}

// ☁️ Nuvem flutuante
class CloudAnimation extends StatefulWidget {
  final double size;
  const CloudAnimation({super.key, required this.size});

  @override
  State<CloudAnimation> createState() => _CloudAnimationState();
}

class _CloudAnimationState extends State<CloudAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat(reverse: true);
    _offsetAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: Icon(Icons.cloud, size: widget.size, color: Colors.grey.shade200),
        );
      },
    );
  }
}

// ⚡ Tempestade
class ThunderAnimation extends StatelessWidget {
  final double size;
  const ThunderAnimation({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.cloud, size: size, color: Colors.grey.shade400),
        Positioned(
          bottom: size * 0.1,
          child: Icon(Icons.bolt, size: size * 0.5, color: Colors.yellow.shade600),
        ),
      ],
    );
  }
}

class DefaultIcon extends StatelessWidget {
  final double size;
  const DefaultIcon({super.key, required this.size});
  @override
  Widget build(BuildContext context) => Icon(Icons.wb_cloudy, size: size, color: Colors.white);
}