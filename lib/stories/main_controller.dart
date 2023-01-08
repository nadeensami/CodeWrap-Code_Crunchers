import 'package:codewrap/stories/time_page.dart';
import 'package:flutter/material.dart';

import '../demo_data.dart';

class StoryMainPage extends StatefulWidget {
  const StoryMainPage({
    Key? key,
    required this.repo,
    required this.action,
  }) : super(key: key);

  @override
  _StoryMainPageState createState() => _StoryMainPageState();

  final Repo repo;
  final Function action;
}

class _StoryMainPageState extends State<StoryMainPage> {
  final PageController _controller = PageController(initialPage: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      children: [
        MainStory(widget.repo, widget.action),
        const Center(
          child: Text("data"),
        ),
        TimePage(widget.repo)
      ],
    );
  }
}

class MainStory extends StatelessWidget {
  const MainStory(this.repo, this.action);

  final Repo repo;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: repo.isNight
                  ? [
                      const Color.fromARGB(255, 13, 28, 81),
                      const Color.fromARGB(255, 40, 51, 204)
                    ]
                  : [
                      const Color(0xFFe88b74),
                      const Color(0xFF29053A),
                    ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("data"),
            const FlutterLogo(),
            TextButton(
                onPressed: () {
                  action();
                },
                child: const Text("Back"))
          ],
        ));
  }
}
