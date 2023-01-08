import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../demo_data.dart';

class BlabberMouthPage extends StatefulWidget {
  const BlabberMouthPage(Repo repo, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlabberMouthPageState();
}

class _BlabberMouthPageState extends State<BlabberMouthPage>
    with TickerProviderStateMixin {
  late AnimationController _lipsController;
  bool loaded = false;
  bool loadedSun = false;

  void loadSun() async {
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
      loadSun();
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
      child: Stack(
        alignment: Alignment.center,
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
                      Color.fromARGB(255, 255, 162, 179),
                      Color.fromARGB(255, 178, 77, 95),
                    ]),
              )),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeOutCubic,
            width: 320,
            top: 270,
            left: loaded ? 50 : -20,
            height: 400,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1200),
              opacity: loaded ? 1 : 0,
              child: SizedBox(
                width: 320,
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Blabbermouth",
                        style: GoogleFonts.ptSerif(
                            textStyle: TextStyle(
                          color: Colors.white.withOpacity(loaded ? 1 : 0),
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ))),
                    const SizedBox(height: 10),
                    Text(
                      "You mean well but you comment waaaaay too much.\n\n66.7% of your code is comments, with the average amount of spacing between comments being 15 lines.",
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
          Positioned(
              left: 40,
              top: 95,
              width: 200,
              height: 150,
              child: Transform.rotate(
                angle: -3.14 / 8,
                child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_lipsController),
                    child: Image.asset(
                      'images/lips.png',
                      width: 200,
                    )),
              )),
          Positioned(
            bottom: 0,
            height: 400,
            width: 400,
            left: 0,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemCount: 36,
                itemBuilder: ((context, index) {
                  var offset = ((index % 6) + ((index / 6).round())) / 14;
                  return Opacity(
                      opacity: 0.5,
                      child: RotationTransition(
                          turns: Tween(begin: 0.0 + offset, end: 1.0 + offset)
                              .animate(_lipsController),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "images/lips.png",
                              width: 10,
                              height: 10,
                            ),
                          )));
                })),
          )
        ],
      ),
    );
  }
}
