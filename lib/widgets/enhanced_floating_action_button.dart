import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class EnhancedFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;

  const EnhancedFloatingActionButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  _EnhancedFloatingActionButtonState createState() =>
      _EnhancedFloatingActionButtonState();
}

class _EnhancedFloatingActionButtonState
    extends State<EnhancedFloatingActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.9,
      upperBound: 1.0,
    );
    _controller.value = 1.0;
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playClickSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.mp3')); 
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.reverse();
        _playClickSound();
      },
      onTapUp: (_) {
        _controller.forward();
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: null,
            child: const Icon(Icons.add, size: 30, color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
