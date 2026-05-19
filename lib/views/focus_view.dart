import 'dart:async';
import 'package:flutter/material.dart';

class FocusView extends StatefulWidget {
  const FocusView({super.key});

  @override
  State<FocusView> createState() => _FocusViewState();
}

class _FocusViewState extends State<FocusView> {
  int selectedMinutes = 25;
  static const int breakMinutes = 5;

  late int secondsLeft = selectedMinutes * 60;

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

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsLeft > 0) {
          setState(() {
            secondsLeft--;
          });
        } else {
          timer.cancel();

          setState(() {
            isRunning = false;

            isBreak = !isBreak;

            secondsLeft =
                isBreak
                    ? breakMinutes * 60
                    : selectedMinutes * 60;
          });
        }
      },
    );
  }

  void pauseTimer() {
    timer?.cancel();

    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();

    setState(() {
      isRunning = false;
      isBreak = false;
      secondsLeft = selectedMinutes * 60;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        isBreak
            ? secondsLeft / (breakMinutes * 60)
            : secondsLeft / (selectedMinutes * 60);

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
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),

              child: Column(
                children: [

                  Icon(
                    isBreak
                        ? Icons.coffee
                        : Icons.school,

                    size: 80,

                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                  ),

                  const SizedBox(height: 18),

                  Text(
                    isBreak
                        ? 'Break Time ☕'
                        : 'Study Focus 📚',

                    style:
                        Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                  ),

                  const SizedBox(height: 30),

                  Wrap(
                    spacing: 10,

                    children:
                        [15, 25, 45, 60].map((m) {
                      return ChoiceChip(
                        label:
                            Text('$m min'),

                        selected:
                            selectedMinutes ==
                                m,

                        onSelected:
                            isRunning
                                ? null
                                : (_) {
                                    setState(() {
                                      selectedMinutes =
                                          m;

                                      secondsLeft =
                                          m *
                                              60;

                                      isBreak =
                                          false;
                                    });
                                  },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: 240,
                    height: 240,

                    child: Stack(
                      alignment:
                          Alignment.center,

                      children: [

                        SizedBox(
                          width: 240,
                          height: 240,

                          child:
                              CircularProgressIndicator(
                            value:
                                progress,

                            strokeWidth:
                                12,
                          ),
                        ),

                        Text(
                          timeText,

                          style:
                              const TextStyle(
                                fontSize:
                                    46,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [

                      SizedBox(
                        width: 150,
                        height: 50,

                        child:
                            FilledButton.icon(
                          onPressed:
                              isRunning
                                  ? pauseTimer
                                  : startTimer,

                          icon: Icon(
                            isRunning
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),

                          label: Text(
                            isRunning
                                ? 'Pause'
                                : 'Start',
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      SizedBox(
                        width: 150,
                        height: 50,

                        child:
                            OutlinedButton.icon(
                          onPressed:
                              resetTimer,

                          icon:
                              const Icon(
                                Icons.restart_alt,
                              ),

                          label:
                              const Text(
                                'Reset',
                              ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                          18,
                        ),

                    decoration:
                        BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                                24,
                              ),

                          color:
                              Theme.of(
                                context,
                              )
                                  .colorScheme
                                  .surface,
                        ),

                    child: Text(
                      isBreak
                          ? 'Take a short break and relax ☕'
                          : 'Stay focused and finish your study task 🎯',

                      textAlign:
                          TextAlign.center,
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