import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../demo_data.dart';

class TimePage extends StatelessWidget {
  const TimePage(Repo repo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Stack(
        children: [
          Image.asset('images/clouds.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              colorBlendMode: BlendMode.screen,
              color: Colors.blue),
          Center(
            child: SizedBox(
              width: 250,
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("You're an\nearly bird!",
                      style: GoogleFonts.ptSerif(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
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
        ],
      ),
    );
  }
}
