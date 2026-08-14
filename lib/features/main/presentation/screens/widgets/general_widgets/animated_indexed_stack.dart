import 'package:flutter/material.dart';

/// IndexedStack, который сохраняет состояние всех страниц
/// и при этом анимирует смену страниц горизонтальным сдвигом.
class AnimatedIndexedStack extends StatefulWidget {
  const AnimatedIndexedStack({
    super.key,
    required this.index,
    required this.previousIndex,
    required this.reverse,
    required this.children,
    this.duration = const Duration(milliseconds: 500),
  });

  final int index;
  final int previousIndex;
  final bool reverse;
  final List<Widget> children;
  final Duration duration;

  @override
  State<AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < widget.children.length; i++)
          _AnimatedPage(
            key: ValueKey('animated_page_$i'), // стабильный ключ — state страниц сохраняется
            isCurrent: i == widget.index,
            isPrevious: i == widget.previousIndex,
            reverse: widget.reverse,
            duration: widget.duration,
            child: widget.children[i],
          ),
      ],
    );
  }
}

class _AnimatedPage extends StatefulWidget {
  const _AnimatedPage({
    super.key,
    required this.isCurrent,
    required this.isPrevious,
    required this.reverse,
    required this.duration,
    required this.child,
  });

  final bool isCurrent;
  final bool isPrevious;
  final bool reverse;
  final Duration duration;
  final Widget child;

  @override
  State<_AnimatedPage> createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<_AnimatedPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: widget.isCurrent ? 1.0 : 0.0,
  );

  late Animation<Offset> _slide;
  late Animation<double> _opacityIn;
  late Animation<double> _opacityOut;

  @override
  void initState() {
    super.initState();
    _slide = _buildSlide(Offset.zero, Offset.zero);
    _opacityIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _opacityOut = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  Animation<Offset> _buildSlide(Offset begin, Offset end) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_AnimatedPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Страница стала текущей — въезжает со стороны перехода
    if (widget.isCurrent && !oldWidget.isCurrent) {
      final from = widget.reverse ? const Offset(-1, 0) : const Offset(1, 0);
      _slide = _buildSlide(from, Offset.zero);
      _controller.forward(from: 0.0);
      return;
    }
    // Страница стала «предыдущей» — уезжает в противоположную сторону
    if (widget.isPrevious && !oldWidget.isPrevious && !widget.isCurrent) {
      final to = widget.reverse ? const Offset(1, 0) : const Offset(-1, 0);
      _slide = _buildSlide(Offset.zero, to);
      _controller.forward(from: 0.0);
      return;
    }
    // Страница скрыта и не участвует в переходе — сбрасываем без анимации
    if (!widget.isCurrent && !widget.isPrevious) {
      _controller.value = 0.0;
      _slide = _buildSlide(Offset.zero, Offset.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isCurrent,
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          return FractionalTranslation(
            translation: _slide.value,
            child: Opacity(
              opacity: widget.isCurrent
                  ? _opacityIn.value
                  : widget.isPrevious
                  ? _opacityOut.value
                  : 0.0,
              child: child,
            ),
          );
        },
      ),
    );
  }
}