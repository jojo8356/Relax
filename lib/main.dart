import 'package:flutter/material.dart';

void main() {
  runApp(const RelaxApp());
}

class RelaxApp extends StatelessWidget {
  const RelaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relax & Breathe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const BreathingScreen(),
    );
  }
}

enum BreathingPhase {
  inhale,
  holdIn,
  exhale,
  holdOut,
}

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _pulseController;
  late Animation<double> _breathAnimation;
  late Animation<double> _pulseAnimation;

  BreathingPhase _currentPhase = BreathingPhase.inhale;
  bool _isRunning = false;

  // Durées en secondes
  final int _inhaleDuration = 4;
  final int _holdInDuration = 4;
  final int _exhaleDuration = 4;
  final int _holdOutDuration = 4;

  int _remainingSeconds = 4;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _breathController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _inhaleDuration),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _breathController.addStatusListener(_onAnimationStatus);
    _breathController.addListener(_updateTimer);
  }

  void _updateTimer() {
    int totalDuration;
    switch (_currentPhase) {
      case BreathingPhase.inhale:
        totalDuration = _inhaleDuration;
        break;
      case BreathingPhase.holdIn:
        totalDuration = _holdInDuration;
        break;
      case BreathingPhase.exhale:
        totalDuration = _exhaleDuration;
        break;
      case BreathingPhase.holdOut:
        totalDuration = _holdOutDuration;
        break;
    }

    final newRemaining =
        (totalDuration * (1 - _breathController.value)).ceil();
    if (newRemaining != _remainingSeconds) {
      setState(() {
        _remainingSeconds = newRemaining;
      });
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _nextPhase();
    }
  }

  void _nextPhase() {
    setState(() {
      switch (_currentPhase) {
        case BreathingPhase.inhale:
          _currentPhase = BreathingPhase.holdIn;
          _breathController.duration = Duration(seconds: _holdInDuration);
          break;
        case BreathingPhase.holdIn:
          _currentPhase = BreathingPhase.exhale;
          _breathController.duration = Duration(seconds: _exhaleDuration);
          _breathAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
            CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
          );
          break;
        case BreathingPhase.exhale:
          _currentPhase = BreathingPhase.holdOut;
          _breathController.duration = Duration(seconds: _holdOutDuration);
          break;
        case BreathingPhase.holdOut:
          _currentPhase = BreathingPhase.inhale;
          _breathController.duration = Duration(seconds: _inhaleDuration);
          _breathAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
          );
          break;
      }
    });

    _breathController.reset();
    if (_isRunning) {
      _breathController.forward();
    }
  }

  void _toggleBreathing() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      _breathController.forward();
    } else {
      _breathController.stop();
    }
  }

  void _reset() {
    _breathController.stop();
    _breathController.reset();
    setState(() {
      _isRunning = false;
      _currentPhase = BreathingPhase.inhale;
      _remainingSeconds = _inhaleDuration;
      _breathAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
      );
      _breathController.duration = Duration(seconds: _inhaleDuration);
    });
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case BreathingPhase.inhale:
        return 'INSPIREZ';
      case BreathingPhase.holdIn:
        return 'RETENEZ';
      case BreathingPhase.exhale:
        return 'EXPIREZ';
      case BreathingPhase.holdOut:
        return 'RETENEZ';
    }
  }

  Color _getPhaseColor() {
    switch (_currentPhase) {
      case BreathingPhase.inhale:
        return const Color(0xFF4ECDC4);
      case BreathingPhase.holdIn:
        return const Color(0xFF95E1D3);
      case BreathingPhase.exhale:
        return const Color(0xFF6B5B95);
      case BreathingPhase.holdOut:
        return const Color(0xFF88B04B);
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              const Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Respiration Profonde',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Concentrez-vous sur le cercle',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.5),
                  letterSpacing: 1,
                ),
              ),
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _breathAnimation,
                      _pulseAnimation,
                    ]),
                    builder: (context, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Cercles de fond animés
                              ...List.generate(3, (index) {
                                return Transform.scale(
                                  scale: _breathAnimation.value *
                                      (1.3 + index * 0.15) *
                                      _pulseAnimation.value,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _getPhaseColor()
                                            .withValues(alpha: 0.1 - index * 0.03),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              // Cercle principal avec gradient
                              Transform.scale(
                                scale: _breathAnimation.value,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        _getPhaseColor().withValues(alpha: 0.8),
                                        _getPhaseColor().withValues(alpha: 0.4),
                                        _getPhaseColor().withValues(alpha: 0.1),
                                      ],
                                      stops: const [0.0, 0.6, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _getPhaseColor().withValues(alpha: 0.4),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _getPhaseText(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 3,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '$_remainingSeconds',
                                          style: const TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w200,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          // Indicateur de phase
                          _buildPhaseIndicator(),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Boutons de contrôle
              Padding(
                padding: const EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton(
                      icon: _isRunning ? Icons.pause : Icons.play_arrow,
                      label: _isRunning ? 'Pause' : 'Démarrer',
                      onPressed: _toggleBreathing,
                      isPrimary: true,
                    ),
                    const SizedBox(width: 20),
                    _buildControlButton(
                      icon: Icons.refresh,
                      label: 'Réinitialiser',
                      onPressed: _reset,
                      isPrimary: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPhaseChip('Inspirez', BreathingPhase.inhale),
        _buildPhaseLine(BreathingPhase.inhale),
        _buildPhaseChip('Retenez', BreathingPhase.holdIn),
        _buildPhaseLine(BreathingPhase.holdIn),
        _buildPhaseChip('Expirez', BreathingPhase.exhale),
        _buildPhaseLine(BreathingPhase.exhale),
        _buildPhaseChip('Retenez', BreathingPhase.holdOut),
      ],
    );
  }

  Widget _buildPhaseChip(String label, BreathingPhase phase) {
    final isActive = _currentPhase == phase;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? _getPhaseColor().withValues(alpha: 0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? _getPhaseColor() : Colors.white.withValues(alpha: 0.2),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPhaseLine(BreathingPhase phase) {
    final isActive = _currentPhase == phase;
    return Container(
      width: 20,
      height: 2,
      color: isActive ? _getPhaseColor() : Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary
              ? _getPhaseColor().withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isPrimary ? _getPhaseColor() : Colors.white.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: _getPhaseColor().withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
