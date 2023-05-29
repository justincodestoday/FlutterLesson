import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomCanvas extends StatefulWidget {
  const CustomCanvas({Key? key}) : super(key: key);

  @override
  State<CustomCanvas> createState() => _CustomCanvasState();
}

class _CustomCanvasState extends State<CustomCanvas> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  var _state = 0.0;
  var _path = Path();
  var _widgetKey = GlobalKey();
  Color selectedColor = Colors.red; // Initial color


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animationController.addListener(() {
      setState(() {
        _state = animationController.value;
      });
    });
  }

  void _start() {
    animationController.reset();
    animationController.forward();
  }

  void _reset() {
    _path.reset();
  }

  void _begin(PointerDownEvent event) {
    final referenceBox = _widgetKey.currentContext?.findRenderObject() as RenderBox;
    final offset = referenceBox.globalToLocal(event.position);
    setState(() {
      _path.moveTo(offset.dx, offset.dy);
    });
  }

  void _draw(PointerMoveEvent event) {
    final referenceBox = _widgetKey.currentContext?.findRenderObject() as RenderBox;
    final offset = referenceBox.globalToLocal(event.position);
    setState(() {
      _path.lineTo(offset.dx, offset.dy);
    });
  }

  void showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8, // Adjust the size of the color picker area
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Do something with the selected color
                debugPrint(selectedColor.toString());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Canvas"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Listener(
              onPointerDown: (event) => {
                _begin(event)
              },
              onPointerMove: (event) => {
                _draw(event),
                debugPrint(event.position.toString())
              },
              child: ClipRRect(
                child: Stack(
                  children: [
                    Container(
                      key: _widgetKey,
                      width: 300,
                      height: 400,
                      color: Colors.black,
                      child: CustomPaint(
                        painter: MyPainter(
                          scale: _state,
                          path: _path,
                          currentColor: selectedColor
                        ),
                      )
                    ),
                  ]
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => _start(),
                child: const Text("Start")
            ),
            ElevatedButton(
                onPressed: () => _reset(),
                child: const Text("Reset Canvas")
            ),
            ElevatedButton(
              child: const Text('Open Color Picker'),
              onPressed: () {
                showColorPickerDialog(context);
              },
            )
          ],
        )
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({required this.scale, required this.path, required this.currentColor});
  final double scale;
  final Path path;
  final Color currentColor;

  @override
  void paint(Canvas canvas, Size size) {
    var center = size/2;
    var paint = Paint()..color = Colors.blue;
    // canvas.drawCircle(Offset(center.width, center.height), 40.0, paint);
    canvas.drawCircle(Offset(center.width, center.height), 40.0*scale, paint);

    paint = Paint()..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..color = currentColor..colorFilter;

    // var arcAngle = 180.0;
    var arcAngle = 2*pi*scale;

    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(center.width, center.height), radius: 50.0),
        0, arcAngle, false, paint
    );

    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(center.width, center.height), radius: 120.0),
        0, arcAngle, false, paint
    );

    // var path = Path();
    // path.moveTo(100, 100);
    // path.lineTo(120, 110);
    // path.lineTo(140, 170);
    // path.lineTo(100, 160);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
