import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../demo_data.dart';

class SentencePage extends StatefulWidget {
  const SentencePage(Repo repo, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SentencePageState();
}

class _SentencePageState extends State<SentencePage>
    with TickerProviderStateMixin {
  late AnimationController _lipsController;
  bool loaded = false;

  void loadAnim() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _lipsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15));

    _lipsController.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      loadAnim();
    });
  }

  @override
  void dispose() {
    _lipsController.dispose();
    loaded = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xffD76F82),
        child: Stack(alignment: Alignment.center, children: [
          // background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 24, 22, 57),
                    Color.fromARGB(255, 7, 45, 111),
                  ]),
            ),
          ),
          Positioned(
            top: 120,
            child: SizedBox(
              width: 250,
              child: DefaultTextStyle(
                  style: GoogleFonts.ibmPlexMono(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: AnimatedTextKit(animatedTexts: [
                    TypewriterAnimatedText(
                      "I circle to draw An outlined graph for the current user Input strings from the customer list Stored in temp, to process and compute The flag tracks progress, the result stores the output Counter counts, average finds the mean The output shows the final result seen.",
                      textAlign: TextAlign.left,
                    ),
                  ])),
            ),
          ),

          Positioned(
            bottom: 70,
            child: SizedBox(
              width: 220,
              child: Text(
                "This sentence was formed with your most commonly used variable names.",
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexMono(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
              minimum: const EdgeInsets.all(30),
              child: Container(
                  decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(30),
              ))),
        ]));
  }
}
