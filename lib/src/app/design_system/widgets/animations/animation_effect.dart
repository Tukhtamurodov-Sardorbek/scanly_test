import 'package:flutter/cupertino.dart';

class AnimationButtonEffect extends StatefulWidget {
  final bool disabled;
  final Function() onTap;
  final bool isGrey;
  final bool isLoading;
  final bool isPositioned;
  final Widget child;

  const AnimationButtonEffect({
    super.key,
    this.disabled = false,
    required this.onTap,
    this.isGrey = false,
    this.isLoading = false,
    required this.child,
    this.isPositioned = false,
  });

  @override
  State<AnimationButtonEffect> createState() => _AnimationButtonEffectState();
}

class _AnimationButtonEffectState extends State<AnimationButtonEffect>
    with TickerProviderStateMixin {
  late AnimationController? _controllerA;

  double squareScaleA = 0.97;

  @override
  void initState() {
    _controllerA = AnimationController(
      vsync: this,
      lowerBound: 0.97,
      duration: const Duration(milliseconds: 80),
    );
    _controllerA!.addListener(() {
      setState(() {
        squareScaleA = _controllerA!.value;
      });
    });

    _controllerA!.forward(from: 0.0);
    super.initState();
  }

  @override
  void dispose() {
    _controllerA!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.isPositioned
          ? HitTestBehavior.translucent
          : HitTestBehavior.deferToChild,
      onTap: () {
        if (!widget.disabled) {
          final FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          widget.onTap();
        }
      },
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (_) {
          _controllerA!.reverse();
        },
        onPointerUp: (_) {
          _controllerA!.forward(from: 1.0);
        },
        child: Transform.scale(
          scale: squareScaleA,
          child: Stack(
            children: [
              widget.child,
              if (widget.isLoading)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 5,
                  child: CupertinoActivityIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
