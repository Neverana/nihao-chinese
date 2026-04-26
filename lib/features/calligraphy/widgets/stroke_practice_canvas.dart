// lib/features/calligraphy/widgets/stroke_practice_canvas.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../data/models/stroke_data.dart';

class StrokePracticeCanvas extends StatefulWidget {
  final HanziStrokeData strokeData;
  final int completedStrokes;
  final bool showHint;
  final VoidCallback? onStrokeCompleted;
  final VoidCallback? onCharacterCompleted;
  final Color strokeColor;
  final Color hintColor;
  final Color gridColor;

  const StrokePracticeCanvas({
    super.key,
    required this.strokeData,
    required this.completedStrokes,
    this.showHint = true,
    this.onStrokeCompleted,
    this.onCharacterCompleted,
    this.strokeColor = Colors.black,
    this.hintColor = const Color(0xFF5B8FFF),
    this.gridColor = const Color(0xFFCCCCCC),
  });

  @override
  State<StrokePracticeCanvas> createState() => _StrokePracticeCanvasState();
}

class _StrokePracticeCanvasState extends State<StrokePracticeCanvas>
    with SingleTickerProviderStateMixin {
  List<Offset> _currentStroke = [];
  bool _currentStrokePassed = false;
  Size _canvasSize = Size.zero;

  late AnimationController _animController;

  int get _currentStrokeIndex => widget.completedStrokes;
  bool get _isComplete =>
      widget.completedStrokes >= widget.strokeData.strokeCount;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void didUpdateWidget(StrokePracticeCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.completedStrokes != widget.completedStrokes) {
      _currentStrokePassed = false;
      _currentStroke = [];
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (_isComplete || _currentStrokePassed) return;
    setState(() {
      _currentStroke = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentStrokePassed) return;

    // Проверяем что точка внутри области рисования (с запасом 20px)
    final w = _canvasSize.width;
    final h = _canvasSize.height;
    final squareSize = math.min(w, h);
    final offsetX = (w - squareSize) / 2;
    final offsetY = (h - squareSize) / 2;

    final pos = details.localPosition;
    final margin = 20.0;
    final inBounds = pos.dx >= offsetX - margin &&
        pos.dx <= offsetX + squareSize + margin &&
        pos.dy >= offsetY - margin &&
        pos.dy <= offsetY + squareSize + margin;

    if (!inBounds) {
      // Ушли за пределы — отменяем текущую черту
      setState(() {
        _currentStroke = [];
      });
      return;
    }

    setState(() {
      _currentStroke.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentStrokePassed) return;
    setState(() {
      if (_currentStroke.length > 2) {
        _evaluateStroke();
      } else {
        _currentStroke = [];
      }
    });
  }

  void _evaluateStroke() {
    final w = _canvasSize.width;
    final h = _canvasSize.height;
    final squareSize = math.min(w, h);
    final padding = squareSize * 0.08;
    final drawArea = squareSize - padding * 2;
    final offsetX = (w - squareSize) / 2;
    final offsetY = (h - squareSize) / 2;

    final hintStroke = widget.strokeData.strokes[_currentStrokeIndex];
    final hintPoints = hintStroke.points
        .map((p) => _toCanvas(p.x, p.y, padding, drawArea, offsetX, offsetY))
        .toList();

    // Всегда проверяем все четыре условия
    final positionOk = _checkPosition(_currentStroke, hintPoints);
    final directionOk = _checkDirection(_currentStroke, hintPoints);
    final coverageOk = _checkCoverage(_currentStroke, hintPoints);
    final similarity = _calculateSimilarity(_currentStroke, hintPoints);

    debugPrint(
        'Stroke eval: pos=$positionOk dir=$directionOk cov=$coverageOk sim=${similarity.toStringAsFixed(2)} pts=${_currentStroke.length}');

    if (positionOk &&
        directionOk &&
        coverageOk &&
        similarity > 0.55 &&
        _currentStroke.length > 15) {
      _acceptStroke();
    } else {
      _currentStroke = [];
    }
  }

  /// Проверяет что черта нарисована примерно в том же месте, что и подсказка.
  bool _checkPosition(List<Offset> userPoints, List<Offset> hintPoints) {
    if (userPoints.length < 2 || hintPoints.length < 2) return false;

    // Bounding box пользователя
    double uMinX = userPoints[0].dx, uMaxX = userPoints[0].dx;
    double uMinY = userPoints[0].dy, uMaxY = userPoints[0].dy;
    for (final p in userPoints) {
      if (p.dx < uMinX) uMinX = p.dx;
      if (p.dx > uMaxX) uMaxX = p.dx;
      if (p.dy < uMinY) uMinY = p.dy;
      if (p.dy > uMaxY) uMaxY = p.dy;
    }

    // Bounding box подсказки
    double hMinX = hintPoints[0].dx, hMaxX = hintPoints[0].dx;
    double hMinY = hintPoints[0].dy, hMaxY = hintPoints[0].dy;
    for (final p in hintPoints) {
      if (p.dx < hMinX) hMinX = p.dx;
      if (p.dx > hMaxX) hMaxX = p.dx;
      if (p.dy < hMinY) hMinY = p.dy;
      if (p.dy > hMaxY) hMaxY = p.dy;
    }

    // Центры bounding box
    final uCenter = Offset((uMinX + uMaxX) / 2, (uMinY + uMaxY) / 2);
    final hCenter = Offset((hMinX + hMaxX) / 2, (hMinY + hMaxY) / 2);

    // Расстояние между центрами
    final centerDist = (uCenter - hCenter).distance;

    // Размер подсказки (диагональ bounding box)
    final hintSize =
        math.sqrt(math.pow(hMaxX - hMinX, 2) + math.pow(hMaxY - hMinY, 2));

    // Центры должны быть в пределах 35% размера подсказки
    return centerDist < hintSize * 0.35;
  }

  /// Проверяет что направление движения пользователя совпадает с подсказкой.
  bool _checkDirection(List<Offset> userPoints, List<Offset> hintPoints) {
    if (userPoints.length < 3 || hintPoints.length < 3) return false;

    // Сравниваем общий вектор движения
    final userStart = userPoints.first;
    final userEnd = userPoints.last;
    final userVector = userEnd - userStart;

    final hintStart = hintPoints.first;
    final hintEnd = hintPoints.last;
    final hintVector = hintEnd - hintStart;

    if (userVector.distance < 30 || hintVector.distance < 10) return false;

    // Косинус угла между векторами
    final dot = userVector.dx * hintVector.dx + userVector.dy * hintVector.dy;
    final cosAngle = dot / (userVector.distance * hintVector.distance);

    // cos > 0.85 → угол < 32° — направление должно быть точным
    return cosAngle > 0.85;
  }

  /// Проверяет что пользователь прошёл хотя бы 65% длины черты.
  bool _checkCoverage(List<Offset> userPoints, List<Offset> hintPoints) {
    if (userPoints.length < 2 || hintPoints.length < 2) return false;

    // Длина пути пользователя
    double userLength = 0;
    for (int i = 1; i < userPoints.length; i++) {
      userLength += (userPoints[i] - userPoints[i - 1]).distance;
    }

    // Длина подсказки
    double hintLength = 0;
    for (int i = 1; i < hintPoints.length; i++) {
      hintLength += (hintPoints[i] - hintPoints[i - 1]).distance;
    }

    if (hintLength < 1) return false;

    // Пользователь должен пройти хотя бы 65% длины подсказки
    final ratio = userLength / hintLength;
    return ratio >= 0.65;
  }

  Offset _toCanvas(double x, double y, double padding, double drawArea,
      double offsetX, double offsetY) {
    return Offset(
      offsetX + padding + (x / 1024.0) * drawArea,
      offsetY + padding + ((1024.0 - y) / 1024.0) * drawArea,
    );
  }

  double _calculateSimilarity(
      List<Offset> userPoints, List<Offset> hintPoints) {
    if (userPoints.isEmpty || hintPoints.isEmpty) return 0.0;

    final normalizedUser = _normalizePoints(userPoints);
    final normalizedHint = _normalizePoints(hintPoints);

    const sampleCount = 32;
    final sampledUser = _resamplePoints(normalizedUser, sampleCount);
    final sampledHint = _resamplePoints(normalizedHint, sampleCount);

    double totalDistance = 0;
    for (int i = 0; i < sampleCount; i++) {
      totalDistance += (sampledUser[i] - sampledHint[i]).distance;
    }
    final avgDistance = totalDistance / sampleCount;

    return math.max(0, 1.0 - avgDistance);
  }

  List<Offset> _normalizePoints(List<Offset> points) {
    if (points.isEmpty) return [];
    double minX = points[0].dx, maxX = points[0].dx;
    double minY = points[0].dy, maxY = points[0].dy;
    for (final p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }
    final rangeX = maxX - minX;
    final rangeY = maxY - minY;
    final range = math.max(rangeX, rangeY);
    if (range < 1) return points;

    return points
        .map((p) => Offset(
              (p.dx - minX) / range,
              (p.dy - minY) / range,
            ))
        .toList();
  }

  List<Offset> _resamplePoints(List<Offset> points, int count) {
    if (points.isEmpty) return List.filled(count, Offset.zero);
    if (points.length == 1) return List.filled(count, points[0]);

    final segmentLengths = <double>[];
    double totalLength = 0;
    for (int i = 1; i < points.length; i++) {
      final len = (points[i] - points[i - 1]).distance;
      segmentLengths.add(len);
      totalLength += len;
    }

    if (totalLength < 0.001) return List.filled(count, points[0]);

    final result = <Offset>[points[0]];
    final targetSegmentLength = totalLength / (count - 1);
    double currentLength = 0;
    int pointIndex = 0;

    for (int i = 1; i < count; i++) {
      final target = targetSegmentLength * i;
      while (pointIndex < segmentLengths.length &&
          currentLength + segmentLengths[pointIndex] < target) {
        currentLength += segmentLengths[pointIndex];
        pointIndex++;
      }
      if (pointIndex >= segmentLengths.length) {
        result.add(points.last);
      } else {
        final remaining = target - currentLength;
        final t = remaining / segmentLengths[pointIndex];
        result.add(Offset.lerp(
            points[pointIndex], points[pointIndex + 1], t.clamp(0.0, 1.0))!);
      }
    }

    while (result.length < count) {
      result.add(points.last);
    }
    return result.take(count).toList();
  }

  void _acceptStroke() {
    _currentStrokePassed = true;
    _currentStroke = [];
    widget.onStrokeCompleted?.call();

    if (widget.completedStrokes + 1 >= widget.strokeData.strokeCount) {
      widget.onCharacterCompleted?.call();
    }
  }

  void clearCurrentStroke() {
    setState(() {
      _currentStroke = [];
      _currentStrokePassed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size != _canvasSize) {
          _canvasSize = size;
        }

        return GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          behavior: HitTestBehavior.opaque,
          child: SizedBox.expand(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _StrokePracticePainter(
                    strokeData: widget.strokeData,
                    completedStrokes: widget.completedStrokes,
                    currentStroke: _currentStroke,
                    showHint: widget.showHint,
                    strokeColor: widget.strokeColor,
                    hintColor: widget.hintColor,
                    gridColor: widget.gridColor,
                    canvasSize: _canvasSize,
                    animProgress: _animController.value,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _StrokePracticePainter extends CustomPainter {
  final HanziStrokeData strokeData;
  final int completedStrokes;
  final List<Offset> currentStroke;
  final bool showHint;
  final Color strokeColor;
  final Color hintColor;
  final Color gridColor;
  final Size canvasSize;
  final double animProgress;

  const _StrokePracticePainter({
    required this.strokeData,
    required this.completedStrokes,
    required this.currentStroke,
    required this.showHint,
    required this.strokeColor,
    required this.hintColor,
    required this.gridColor,
    required this.canvasSize,
    required this.animProgress,
  });

  Offset _toCanvas(double x, double y, double padding, double drawArea,
      double offsetX, double offsetY) {
    return Offset(
      offsetX + padding + (x / 1024.0) * drawArea,
      offsetY + padding + ((1024.0 - y) / 1024.0) * drawArea,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = canvasSize.width;
    final h = canvasSize.height;
    if (w < 1 || h < 1) return;

    final squareSize = math.min(w, h);
    final padding = squareSize * 0.08;
    final drawArea = squareSize - padding * 2;
    final offsetX = (w - squareSize) / 2;
    final offsetY = (h - squareSize) / 2;

    // 1. Рисуем 米字格 сетку
    _drawGrid(canvas, offsetX, offsetY, squareSize);

    // 2. Рисуем полный иероглиф фоном (очень бледно)
    if (showHint) {
      _drawFullCharacter(canvas, offsetX, offsetY, padding, drawArea);
    }

    // 3. Рисуем пройденные черты
    for (int i = 0;
        i < completedStrokes && i < strokeData.strokes.length;
        i++) {
      _drawCalligraphyStroke(
        canvas,
        strokeData.strokes[i],
        offsetX,
        offsetY,
        padding,
        drawArea,
        strokeColor,
        baseWidth: 8,
        opacity: 1.0,
      );
    }

    // 4. Рисуем подсказку текущей черты с анимацией
    if (showHint && completedStrokes < strokeData.strokes.length) {
      _drawAnimatedHintStroke(
        canvas,
        strokeData.strokes[completedStrokes],
        offsetX,
        offsetY,
        padding,
        drawArea,
        hintColor,
        animProgress,
      );

      _drawStrokeNumber(
          canvas, completedStrokes + 1, strokeData.strokes.length);
    }

    // 5. Рисуем текущую черту пользователя
    if (currentStroke.length > 1) {
      _drawUserStroke(canvas, currentStroke);
    }
  }

  void _drawGrid(
      Canvas canvas, double offsetX, double offsetY, double squareSize) {
    final gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromLTWH(offsetX, offsetY, squareSize, squareSize),
      gridPaint,
    );

    final centerPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.15)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(offsetX, offsetY + squareSize / 2),
      Offset(offsetX + squareSize, offsetY + squareSize / 2),
      centerPaint,
    );
    canvas.drawLine(
      Offset(offsetX + squareSize / 2, offsetY),
      Offset(offsetX + squareSize / 2, offsetY + squareSize),
      centerPaint,
    );
    canvas.drawLine(
      Offset(offsetX, offsetY),
      Offset(offsetX + squareSize, offsetY + squareSize),
      centerPaint,
    );
    canvas.drawLine(
      Offset(offsetX + squareSize, offsetY),
      Offset(offsetX, offsetY + squareSize),
      centerPaint,
    );
  }

  void _drawFullCharacter(Canvas canvas, double offsetX, double offsetY,
      double padding, double drawArea) {
    for (final stroke in strokeData.strokes) {
      _drawCalligraphyStroke(
        canvas,
        stroke,
        offsetX,
        offsetY,
        padding,
        drawArea,
        strokeColor,
        baseWidth: 4,
        opacity: 0.06,
      );
    }
  }

  void _drawCalligraphyStroke(
    Canvas canvas,
    StrokePath strokePath,
    double offsetX,
    double offsetY,
    double padding,
    double drawArea,
    Color color, {
    double baseWidth = 8,
    double opacity = 1.0,
  }) {
    if (strokePath.points.length < 2) return;

    final points = strokePath.points
        .map((p) => _toCanvas(p.x, p.y, padding, drawArea, offsetX, offsetY))
        .toList();

    final totalPoints = points.length;
    for (int i = 0; i < totalPoints - 1; i++) {
      final t = i / (totalPoints - 1);

      double thicknessFactor;
      if (t < 0.15) {
        thicknessFactor = 0.7 + 0.3 * (t / 0.15);
      } else if (t > 0.85) {
        thicknessFactor = 1.0 - 0.3 * ((t - 0.85) / 0.15);
      } else {
        thicknessFactor = 1.0;
      }

      final width = baseWidth * thicknessFactor;
      final p1 = points[i];
      final p2 = points[i + 1];

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(p1, p2, paint);
    }

    final startPaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(points.first, baseWidth * 0.4, startPaint);
    canvas.drawCircle(points.last, baseWidth * 0.3, startPaint);
  }

  void _drawAnimatedHintStroke(
    Canvas canvas,
    StrokePath strokePath,
    double offsetX,
    double offsetY,
    double padding,
    double drawArea,
    Color color,
    double progress,
  ) {
    if (strokePath.points.length < 2) return;

    final points = strokePath.points
        .map((p) => _toCanvas(p.x, p.y, padding, drawArea, offsetX, offsetY))
        .toList();

    final totalPoints = points.length;
    final drawUpTo = (progress * (totalPoints - 1)).round();

    // Стрелка направления в начале
    if (progress < 0.3 && points.length > 1) {
      _drawDirectionArrow(canvas, points.first, points[1], color);
    }

    for (int i = 0; i < drawUpTo && i < totalPoints - 1; i++) {
      final t = i / (totalPoints - 1);
      double thicknessFactor;
      if (t < 0.15) {
        thicknessFactor = 0.7 + 0.3 * (t / 0.15);
      } else if (t > 0.85) {
        thicknessFactor = 1.0 - 0.3 * ((t - 0.85) / 0.15);
      } else {
        thicknessFactor = 1.0;
      }

      final width = 10.0 * thicknessFactor;
      final p1 = points[i];
      final p2 = points[i + 1];

      final paint = Paint()
        ..color = color.withValues(alpha: 0.5)
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(p1, p2, paint);
    }

    // Точка-индикатор текущей позиции
    if (drawUpTo < totalPoints) {
      final currentPoint = points[drawUpTo.clamp(0, totalPoints - 1)];
      final pulsePaint = Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPoint, 6, pulsePaint);

      final pulsePaint2 = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPoint, 10, pulsePaint2);
    }
  }

  void _drawDirectionArrow(Canvas canvas, Offset from, Offset to, Color color) {
    final direction = (to - from);
    if (direction.distance < 1) return;

    final angle = math.atan2(direction.dy, direction.dx);
    final arrowSize = 12.0;

    final arrowPaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(from.dx + arrowSize * math.cos(angle),
        from.dy + arrowSize * math.sin(angle));
    path.lineTo(from.dx + arrowSize * math.cos(angle - 2.5),
        from.dy + arrowSize * math.sin(angle - 2.5));
    path.lineTo(from.dx + arrowSize * math.cos(angle + 2.5),
        from.dy + arrowSize * math.sin(angle + 2.5));
    path.close();

    canvas.drawPath(path, arrowPaint);
  }

  void _drawUserStroke(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    if (points.length == 2) {
      path.lineTo(points[1].dx, points[1].dy);
    } else {
      for (int i = 1; i < points.length - 1; i++) {
        final midX = (points[i].dx + points[i + 1].dx) / 2;
        final midY = (points[i].dy + points[i + 1].dy) / 2;
        path.quadraticBezierTo(points[i].dx, points[i].dy, midX, midY);
      }
      path.lineTo(points.last.dx, points.last.dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = strokeColor.withValues(alpha: 0.8)
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawStrokeNumber(Canvas canvas, int current, int total) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$current/$total',
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, const Offset(8, 8));
  }

  @override
  bool shouldRepaint(_StrokePracticePainter old) =>
      old.completedStrokes != completedStrokes ||
      old.currentStroke != currentStroke ||
      old.showHint != showHint ||
      old.canvasSize != canvasSize ||
      (old.animProgress - animProgress).abs() > 0.01;
}
