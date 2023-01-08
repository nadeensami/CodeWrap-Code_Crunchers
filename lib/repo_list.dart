import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'demo_data.dart';
import 'stories/main_controller.dart';

class RepoList extends StatefulWidget {
  final List<Repo> repos;
  final Function onChange;

  const RepoList({super.key, required this.repos, required this.onChange});

  @override
  RepoListState createState() => RepoListState();
}

class RepoCard extends StatelessWidget {
  final Repo repo;
  final double width = 290;
  final double height = 250;
  final double rotation = 0;
  final double opacity = 1;

  const RepoCard({required this.repo});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: rotation,
        child: Opacity(
            opacity: opacity,
            child: OpenContainer(
              openBuilder: ((context, action) => StoryMainPage(
                    repo: repo,
                    action: action,
                  )),
              openColor: repo.isNight
                  ? const Color.fromARGB(255, 13, 28, 81)
                  : const Color.fromARGB(255, 240, 102, 16),
              closedColor: repo.isNight
                  ? const Color.fromARGB(255, 13, 28, 81)
                  : const Color.fromARGB(255, 240, 102, 16),
              closedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(31))),
              closedBuilder: (context, openContainer) => Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 72, 105, 126)
                              .withAlpha(100),
                          blurRadius: 15.0,
                          spreadRadius: 0.0,
                          offset: const Offset(
                            0.0,
                            3.0,
                          ),
                        )
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: repo.isNight
                              ? [
                                  const Color.fromARGB(255, 13, 28, 81),
                                  const Color.fromARGB(255, 40, 51, 204)
                                ]
                              : [
                                  const Color.fromARGB(255, 240, 102, 16),
                                  const Color.fromARGB(255, 226, 131, 75)
                                ]),
                      borderRadius: BorderRadius.circular(30)),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${repo.user} /",
                                style: GoogleFonts.ibmPlexMono(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w300))),
                            // const SizedBox(height: 10),
                            Text(
                              repo.name,
                              style: GoogleFonts.ptSerif(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold)),
                            )
                          ]),
                    ),
                  )),
            )));
  }
}

class RepoListState extends State<RepoList>
    with SingleTickerProviderStateMixin {
  final double _maxRotation = 20;

  late PageController _pageController;

  double _cardWidth = 160;
  double _cardHeight = 200;
  double _normalizedOffset = 0;
  double _prevScrollX = 0;
  bool _isScrolling = false;
  //int _focusedIndex = 0;

  late AnimationController _tweenController;
  late Tween<double> _tween;
  late Animation<double> _tweenAnim;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _cardHeight = (size.height * .48).clamp(300.0, 400.0);
    _cardWidth = _cardHeight * .8;
    //Calculate the viewPort fraction for this aspect ratio, since PageController does not accept pixel based size values
    _pageController = PageController(
        initialPage: 1, viewportFraction: _cardWidth / size.width);

    //Create our main list
    Widget listContent = SizedBox(
        //Wrap list in a container to control height and padding
        height: _cardHeight + 100,
        //Use a ListView.builder, calls buildItemRenderer() lazily, whenever it need to display a listItem
        child: CarouselSlider(
          options: CarouselOptions(height: 500.0),
          items: widget.repos.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return RepoCard(repo: i);
              },
            );
          }).toList(),
        ));

    //Wrap our list content in a Listener to detect PointerUp events, and a NotificationListener to detect ScrollStart and ScrollUpdate
    //We have to use both, because NotificationListener does not inform us when the user has lifted their finger.
    //We can not use GestureDetector like we normally would, ListView suppresses it while scrolling.
    return listContent;
  }

  //Create a renderer for each list item
  Widget _buildItemRenderer(int itemIndex) {
    return Container(
        width: _cardWidth,
        height: _cardHeight,
        color: Colors.red,
        child: Text(widget.repos[itemIndex % widget.repos.length].name));
  }

  //Check the notifications bubbling up from the ListView, use them to update our currentOffset and isScrolling state
  bool _handleScrollNotifications(Notification notification) {
    //Scroll Update, add to our current offset, but clamp to -1 and 1
    if (notification is ScrollUpdateNotification) {
      if (_isScrolling) {
        double dx = notification.metrics.pixels - _prevScrollX;
        double scrollFactor = .01;
        double newOffset = (_normalizedOffset + dx * scrollFactor);
        _setOffset(newOffset.clamp(-1.0, 1.0));
      }
      _prevScrollX = notification.metrics.pixels;
      //Calculate the index closest to middle
      //_focusedIndex = (_prevScrollX / (_itemWidth + _listItemPadding)).round();
      widget.onChange(widget.repos
          .elementAt(_pageController.page!.round() % widget.repos.length));
    }
    //Scroll Start
    else if (notification is ScrollStartNotification) {
      _isScrolling = true;
      _prevScrollX = notification.metrics.pixels;
      _tweenController.stop();
    }
    return true;
  }

  //Helper function, any time we change the offset, we want to rebuild the widget tree, so all the renderers get the new value.
  void _setOffset(double value) {
    setState(() {
      _normalizedOffset = value;
    });
  }
}
