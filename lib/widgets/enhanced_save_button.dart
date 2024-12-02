import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class EnhancedSaveButton extends StatefulWidget {
  final bool isSaving;
  final VoidCallback? onPressed;

  const EnhancedSaveButton({
    Key? key,
    required this.isSaving,
    required this.onPressed,
  }) : super(key: key);

  @override
  _EnhancedSaveButtonState createState() => _EnhancedSaveButtonState();
}

class _EnhancedSaveButtonState extends State<EnhancedSaveButton> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playClickSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isSaving ? null : () async {
        await _playClickSound();
        widget.onPressed?.call();
      },
      child: AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  curve: Curves.easeOut,
  decoration: BoxDecoration(
    gradient: widget.isSaving
        ? const LinearGradient(
            colors: [Colors.blueGrey, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Colors.indigo, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: widget.isSaving
            ? Colors.grey.withOpacity(0.3)
            : Colors.black.withOpacity(0.3),
        offset: Offset(0, widget.isSaving ? 0 : 4),
        blurRadius: widget.isSaving ? 4 : 6,
      ),
    ],
  ),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: widget.isSaving
      ? const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3, 
        )
      : const Icon(
          Icons.save_outlined,
          color: Colors.white,
          size: 28,
        ),
)
    );
  }
}


  