import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../demo_data.dart';

class RevertPage extends StatefulWidget {
  const RevertPage(Repo repo, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RevertPageState();
}

class _RevertPageState extends State<RevertPage> with TickerProviderStateMixin {
  late AnimationController animationController;

  bool loaded = false;
  bool loadedEmoji = false;

  void loadEmoji() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      loadedEmoji = true;
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

    animationController = AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );

    animationController.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      loadText();
      loadEmoji();
    });
  }

  @override
  void dispose() {
    loaded = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 243, 0, 235),
                  Color.fromARGB(255, 130, 6, 134),
                ]),
            )
          ),
          
          Center(
            child: SizedBox(
              width: 250,
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            Text("Oopsies.",
                                style: GoogleFonts.ptSerif(
                                    textStyle: TextStyle(
                                  color: Colors.white.withOpacity(loaded ? 1 : 0),
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                ))),
                            const SizedBox(height: 10),
                            Text(
                              "You reverted 12 of your commits this year...",
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
            ),
          ),
          Positioned(
            left: 40,
            top: 95,
            width: 200,
            height: 150,
            child: Transform.rotate(
              angle: 3.14 / 8,
              child: RotationTransition(
                turns: Tween(begin: 0.75, end: 1.1).animate(animationController),
                child: Image.asset(
                  'images/crying.png',
                  width: 200,
                )),
            )
          )
        ],
      ),
    );
  }
}
