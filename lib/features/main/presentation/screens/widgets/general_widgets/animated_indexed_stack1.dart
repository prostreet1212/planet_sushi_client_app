import 'package:flutter/material.dart';

/// Направление сдвига.
///
/// [rightToLeft] — новая страница появляется справа и уходит влево.
/// [leftToRight] — новая страница появляется слева и уходит вправо.
enum SlideShiftDirection {
  leftToRight,
  rightToLeft,
}

/// Аналог IndexedStack, который сохраняет состояние страниц
/// и анимирует переход между ними.
class AnimatedIndexedStack1 extends StatefulWidget {
  const AnimatedIndexedStack1({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,

    /// Насколько уходящая страница сдвигается перед исчезновением.
    /// 0.10 = 10% ширины.
    this.outgoingOffset = 0.05,

    /// Стартовое смещение входящей страницы.
    /// 0.90 = страница изначально сдвинута на 90%.
    this.incomingStartOffset = 0.95,

    /// С какого остатка пути входящая страница начинает становиться видимой.
    ///
    /// Если оставить 0.10, входящая страница будет полностью прозрачной,
    /// пока не останется последние 10% пути, и начнет появляться на них.
    ///
    /// Если передать null, входящая страница будет появляться
    /// на протяжении всей анимации.
    this.incomingFadeStartOffset = 0.05,

    /// Если null, направление определяется по изменению index:
    /// newIndex > oldIndex -> rightToLeft,
    /// newIndex < oldIndex -> leftToRight.
    this.direction,
  });

  final int index;
  final List<Widget> children;

  final Duration duration;
  final Curve curve;

  final double outgoingOffset;
  final double incomingStartOffset;
  final double? incomingFadeStartOffset;

  final SlideShiftDirection? direction;

  @override
  State<AnimatedIndexedStack1> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack1>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  int? _previousIndex;

  /// +1: новая страница движется справа налево.
  /// -1: новая страница движется слева направо.
  int _directionSign = 1;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.index;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void didUpdateWidget(covariant AnimatedIndexedStack1 oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.index == _currentIndex) {
      return;
    }

    final oldIndex = _currentIndex;
    final newIndex = widget.index;

    // Если длительность нулевая, просто переключаем без анимации.
    if (widget.duration == Duration.zero) {
      _currentIndex = newIndex;
      _previousIndex = null;
      _controller.reset();
      return;
    }

    _previousIndex = oldIndex;
    _currentIndex = newIndex;
    _directionSign = _resolveDirectionSign(oldIndex, newIndex);

    // Стартуем новую анимацию.
    //
    // Если переключение произошло во время предыдущей анимации,
    // предыдущий переход будет прерван и начнется новый.
    _controller.forward(from: 0.0);
  }

  int _resolveDirectionSign(int oldIndex, int newIndex) {
    switch (widget.direction) {
      case SlideShiftDirection.leftToRight:
        return -1;
      case SlideShiftDirection.rightToLeft:
        return 1;
      case null:
      // Автоматически определяем направление по смене индекса.
        return newIndex > oldIndex ? 1 : -1;
    }
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      setState(() {
        _previousIndex = null;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: List.generate(widget.children.length, (i) {
          final isCurrent = i == _currentIndex;
          final isPrevious = i == _previousIndex;

          // Во время анимации показываем текущую и предыдущую страницы.
          // Все остальные страницы остаются в дереве, но скрыты через Offstage.
          // Благодаря этому их состояние не теряется.
          final participatesInTransition = isCurrent || isPrevious;

          return Offstage(
            offstage: !participatesInTransition,
            child: AnimatedBuilder(
              animation: _controller,
              child: RepaintBoundary(
                child: widget.children[i],
              ),
              builder: (context, child) {
                final progress = widget.curve
                    .transform(_controller.value)
                    .clamp(0.0, 1.0)
                    .toDouble();

                double opacity;
                double dx;

                if (isPrevious) {
                  // Уходящая страница:
                  // сдвигается на 10% и постепенно исчезает.
                  opacity = (1.0 - progress).clamp(0.0, 1.0).toDouble();
                  dx = -_directionSign * widget.outgoingOffset * progress;
                } else if (isCurrent && _previousIndex != null) {
                  // Входящая страница.
                  //
                  // offset — текущее смещение в долях ширины.
                  // При progress = 0: offset = incomingStartOffset.
                  // При progress = 1: offset = 0.
                  final offset = widget.incomingStartOffset * (1.0 - progress);

                  dx = _directionSign * offset;

                  if (progress <= 0.0) {
                    opacity = 0.0;
                  } else {
                    final fadeStart = widget.incomingFadeStartOffset;

                    if (fadeStart == null || fadeStart <= 0.0) {
                      // Появляется на протяжении всей анимации.
                      opacity = progress;
                    } else {
                      // Становится видимой только когда осталось
                      // не больше fadeStart пути до финального положения.
                      opacity = ((fadeStart - offset) / fadeStart)
                          .clamp(0.0, 1.0)
                          .toDouble();
                    }
                  }
                } else {
                  // Состояние без анимации.
                  opacity = isCurrent ? 1.0 : 0.0;
                  dx = 0.0;
                }

                return IgnorePointer(
                  // Во время анимации блокируем нажатия,
                  // чтобы нельзя было взаимодействовать с полупрозрачными страницами.
                  ignoring: !isCurrent || _previousIndex != null,
                  child: Opacity(
                    opacity: opacity,
                    child: FractionalTranslation(
                      translation: Offset(dx, 0.0),
                      child: child,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}