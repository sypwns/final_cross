import 'dart:async';
import 'package:flutter/material.dart';

class FocusView extends StatefulWidget {
  const FocusView({super.key});

  @override
  State<FocusView> createState() => _FocusViewState();
}

class _FocusViewState extends State<FocusView> {
  static const int focusMinutes = 25;
  static const int breakMinutes = 5;

  int secondsLeft = focusMinutes * 60;
  bool isRunning = false;
  bool isBreak = false;
  Timer? timer;

  String get timeText {
    final minutes = secondsLeft ~/ 60;
    final seconds = secondsLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        setState(() => secondsLeft--);
      } else {
        timer.cancel();
        setState(() {
          isRunning = false;
          isBreak = !isBreak;
          secondsLeft = isBreak ? breakMinutes * 60 : focusMinutes * 60;
        });
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      isBreak = false;
      secondsLeft = focusMinutes * 60;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = isBreak
        ? secondsLeft / (breakMinutes * 60)
        : secondsLeft / (focusMinutes * 60);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Timer'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isBreak ? Icons.coffee : Icons.school,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 18),

                  Text(
                    isBreak ? 'Break Time ☕' : 'Study Focus 📚',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: 230,
                    height: 230,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 230,
                          height: 230,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                          ),
                        ),
                        Text(
                          timeText,
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: isRunning ? pauseTimer : startTimer,
                          icon: Icon(
                            isRunning ? Icons.pause : Icons.play_arrow,
                          ),
                          label: Text(isRunning ? 'Pause' : 'Start'),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: resetTimer,
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Text(
                      isBreak
                          ? 'Take a short break and relax ☕'
                          : 'Stay focused and finish your study task 🎯',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}