import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TriangleTooltip extends StatelessWidget {
  final List<TooltipOption> options;
  final Color backgroundColor;

  const TriangleTooltip(
      {super.key, required this.options, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12.0),
          width: 140,
          child: Card(
            color: backgroundColor, // Match Card color with triangle color
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options
                    .map(
                      (option) => InkWell(
                        onTap: option.onPressed,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                option.icon,
                                height: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(option.label),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 2,
          child: Container(
            margin: const EdgeInsets.only(bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                ),
                Container(
                  child: CustomPaint(
                    size: const Size(30, 15), // Size of your triangle
                    painter:
                        TrianglePainter(color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TooltipOption {
  final String icon;
  final String label;
  final void Function() onPressed; // Specify the function type correctly

  TooltipOption({
    required this.icon,
    required this.onPressed, // Corrected function definition
    required this.label,
  });
}
