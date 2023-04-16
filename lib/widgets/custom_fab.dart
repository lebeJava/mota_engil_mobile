import 'package:flutter/material.dart';

class CustomFab extends StatefulWidget {
  @override
  _CustomFabState createState() => _CustomFabState();
}

class _CustomFabState extends State<CustomFab>
    with SingleTickerProviderStateMixin {
  static const fabSize = 60.0;
  AnimationController? _animationController;
  Animation<double>? _translateAnimation;
  Animation<double>? _rotationAnimation;

  Animation<double>? _iconRotation;

  bool _isExpanded = false;

  void animate() {
    if (!_isExpanded) {
      _animationController!.forward();
    } else {
      _animationController!.reverse();
    }

    _isExpanded = !_isExpanded;
  }

  Widget fab1() {
    return Container(
      height: fabSize,
      width: fabSize,
      child: FittedBox(
        child: FloatingActionButton(
          heroTag: "btn3",
          child: Transform.rotate(
            angle: _iconRotation!.value,
            child: Icon(
              Icons.message,
              color: _isExpanded ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: _isExpanded ? Colors.black : Colors.white,
          elevation: _isExpanded ? 8 : 0,
          onPressed: () {
            print("pressed");
          },
        ),
      ),
    );
  }

  Widget fab2() {
    return Container(
      height: fabSize,
      width: fabSize,
      child: FittedBox(
        child: FloatingActionButton(
          heroTag: "btn4",
          child: Transform.rotate(
            angle: _iconRotation!.value,
            child: Icon(
              Icons.local_shipping,
              color: _isExpanded ? Colors.white : Colors.black,
            ),
          ),
          elevation: _isExpanded ? 8 : 0,
          backgroundColor: _isExpanded ? Colors.black : Colors.white,
          onPressed: () {
            print("Pressed");
          },
        ),
      ),
    );
  }

  Widget fab3() {
    return Container(
      height: fabSize,
      width: fabSize,
      child: FittedBox(
        child: FloatingActionButton(
          heroTag: "btn5",
          child: Transform.rotate(
            angle: _rotationAnimation!.value,
            child: Icon(
              Icons.dashboard,
              color: _isExpanded ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: _isExpanded ? Colors.black : Colors.white,
          onPressed: () async {
            animate();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400))
          ..addListener(() {
            setState(() {});
          });
    _translateAnimation = Tween<double>(begin: 0, end: 80)
        .chain(
          CurveTween(
            curve: _isExpanded ? Curves.fastOutSlowIn : Curves.bounceOut,
          ),
        )
        .animate(_animationController!);

    _iconRotation = Tween<double>(begin: 3.14 / 2, end: 0)
        .chain(
          CurveTween(curve: Curves.bounceInOut),
        )
        .animate(_animationController!);
    _rotationAnimation = Tween<double>(begin: 0, end: 3 * 3.14 / 4)
        .chain(
          CurveTween(
            curve: Curves.bounceInOut,
          ),
        )
        .animate(_animationController!);
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Transform(
          transform:
              Matrix4.translationValues(0, -_translateAnimation!.value, 0),
          child: fab1(),
        ),
        Transform(
          transform:
              Matrix4.translationValues(-_translateAnimation!.value, 0, 0),
          child: fab2(),
        ),
        fab3(),
      ],
    );
  }
}
