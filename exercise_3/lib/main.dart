import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        home: AnimationExercise(),
      ),
    );

class AnimationExercise extends StatefulWidget {
  // What type of widget? (STEP 2)

  const AnimationExercise({super.key});

  @override
  State<AnimationExercise> createState() => _AnimationExerciseState();
}

class _AnimationExerciseState extends State<AnimationExercise>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _animation = ColorTween(
            begin: Color.fromRGBO(255, 0, 0, 1),
            end: Color.fromRGBO(0, 0, 255, 1))
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _forward() {
    setState(() {
      _controller.forward();
    });
  }

  void _reverse() {
    setState(() {
      _controller.reverse();
    });
  }

  void _stop() {
    setState(() {
      _controller.stop();
    });
  }

  void _reset() {
    setState(() {
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Exercise'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: _animation.value,
              borderRadius: BorderRadius.circular(20),
            ),
          )),
          const SizedBox(height: 30),
          Wrap(children: [
            ElevatedButton(onPressed: _forward, child: Text("Move Forward")),
            ElevatedButton(onPressed: _reverse, child: Text("Move Back")),
            ElevatedButton(onPressed: _stop, child: Text("Stop Move")),
            ElevatedButton(onPressed: _reset, child: Text("Reset")),
          ])
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
  }
}
