import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'demo_data.dart';

class RepoList extends StatefulWidget {
  final List<Repo> repos;
  final Function onChange;

  const RepoList({required this.repos, required this.onChange}) : super();

  @override
  RepoListState createState() => RepoListState();
}

class RepoCard extends StatelessWidget {
  final Repo repo;
  final double width = 280;
  final double height = 200;
  final double rotation = 0;
  final double opacity = 1;

  const RepoCard({required this.repo});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: rotation,
        child: Opacity(
            opacity: opacity,
            child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 40, 40, 40),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(repo.user,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(repo.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                      const SizedBox(height: 10),
                      Text(repo.isNight ? "Night" : "Day",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                      const SizedBox(height: 10),
                      Text("${repo.nightPercent}%",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                    ]))));
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
        height: _cardHeight,
        //Use a ListView.builder, calls buildItemRenderer() lazily, whenever it need to display a listItem
        child: CarouselSlider(
          options: CarouselOptions(height: 400.0),
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

  //If the user has released a pointer, and is currently scrolling, we'll assume they're done scrolling and tween our offset to zero.
  //This is a bit of a hack, we can't be sure this event actually came from the same finger that was scrolling, but should work most of the time.
  void _handlePointerUp(PointerUpEvent event) {
    if (_isScrolling) {
      _isScrolling = false;
      _startOffsetTweenToZero();
    }
  }

  //Helper function, any time we change the offset, we want to rebuild the widget tree, so all the renderers get the new value.
  void _setOffset(double value) {
    setState(() {
      _normalizedOffset = value;
    });
  }

  //Tweens our offset from the current value, to 0
  void _startOffsetTweenToZero() {
    //The first time this runs, setup our controller, tween and animation. All 3 are required to control an active animation.
    int tweenTime = 1000;
    if (_tweenController == null) {
      //Create Controller, which starts/stops the tween, and rebuilds this widget while it's running
      _tweenController = AnimationController(
          vsync: this, duration: Duration(milliseconds: tweenTime));
      //Create Tween, which defines our begin + end values
      _tween = Tween<double>(begin: -1, end: 0);
      //Create Animation, which allows us to access the current tween value and the onUpdate() callback.
      _tweenAnim = _tween.animate(
          CurvedAnimation(parent: _tweenController, curve: Curves.elasticOut))
        //Set our offset each time the tween fires, triggering a rebuild
        ..addListener(() {
          _setOffset(_tweenAnim.value);
        });
    }
    //Restart the tweenController and inject a new start value into the tween
    _tween.begin = _normalizedOffset;
    _tweenController.reset();
    _tween.end = 0;
    _tweenController.forward();
  }
}
