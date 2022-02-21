import 'package:flutter/material.dart';
import 'package:pinterest_app/pages/control_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);
  static const String id = "intro_page";

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;


  /// Animation Control
  void animationStatus(){
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animation = Tween<Offset>(
      begin: Offset(0, 5),
      end: Offset(0, 0),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn));
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed(ControlPage.id);
      }
    });
  }


  @override
  void initState() {
    super.initState();
    animationStatus();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: _animation,
        child: Center(
          child: Text("Pinterest",style: TextStyle(fontFamily: "Billabong",fontSize: 50),),
        ),
      ),
    );
  }
}
