import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../demo_data.dart';

class MovingBackground extends AnimatedWidget {
  const MovingBackground({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: animation.value,
          child: child,
        ),
        Positioned(
          left: animation.value - 600,
          child: child,
        ),
      ],
    );
  }
}

class TimePage extends StatefulWidget {
  const TimePage(Repo repo, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> with TickerProviderStateMixin {
  late AnimationController _cloudController;
  bool loaded = false;
  bool loadedSun = false;

  void loadSun() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      loadedSun = true;
    });
  }

  void loadText() async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _cloudController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      loadText();
      loadSun();
    });
  }

  @override
  void dispose() {
    _cloudController.dispose();
    loaded = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Stack(
        alignment: Alignment.center,
        children: [
          MovingBackground(
            animation: Tween<double>(begin: 0, end: 600).animate(
              CurvedAnimation(
                parent: _cloudController..repeat(),
                curve: const Interval(0, 1, curve: Curves.linear),
              ),
            ),
            child: Image.asset('images/clouds.jpg',
                fit: BoxFit.cover,
                height: 1000,
                width: 700,
                alignment: Alignment.center,
                colorBlendMode: BlendMode.screen,
                color: const Color.fromARGB(255, 33, 187, 243)),
          ),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 2700),
              curve: Curves.easeOutCubic,
              right: loadedSun ? 70 : 30,
              top: loadedSun ? 160 : 120,
              width: 150,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.orange[300]),
              )),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeOutCubic,
            width: 250,
            top: loaded ? 250 : 140,
            left: 80,
            height: 200,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1200),
              opacity: loaded ? 1 : 0,
              child: SizedBox(
                width: 250,
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("You're an\nearly bird.",
                        style: GoogleFonts.ptSerif(
                            textStyle: TextStyle(
                          color: Colors.white.withOpacity(loaded ? 1 : 0),
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ))),
                    const SizedBox(height: 10),
                    Text(
                      "74% of your commits were between the hours of 9AM and 9PM.",
                      style: GoogleFonts.ibmPlexMono(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
