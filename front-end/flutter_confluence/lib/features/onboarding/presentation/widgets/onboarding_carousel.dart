import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_confluence/core/colours.dart';
import 'package:flutter_confluence/core/dimen.dart';

class _OnBoardingCarouselItem {
  final String asset;
  final String title;
  final String description;

  _OnBoardingCarouselItem({required this.asset, required this.title, required this.description});
}

final List<_OnBoardingCarouselItem> _carouselItems = [
  _OnBoardingCarouselItem(
      asset: "assets/certifications_icon.png",
      title: "Certifications & standards",
      description:
          "View all the certifications that you can do at Capco, as well as the coding standard guidelines we have produced!"),
  _OnBoardingCarouselItem(
      asset: "assets/guides_icon.png",
      title: "Create guides",
      description: "Do you want to make this completed  message goes here"),
  _OnBoardingCarouselItem(
      asset: "assets/chat_icon.png",
      title: "Chat with colleagues",
      description: "Do you want to make this completed  message goes here"),
];

final List<Widget> _imageSliders = _carouselItems
    .map((item) => Expanded(
        child: Container(
            child: Column(
              children: [
                Image.asset(item.asset),
                Container(height: Dimen.large_padding),
                Text(item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colours.PRIMARY_TEXT_COLOR,
                        fontFamily: 'FuturaPT',
                        fontWeight: FontWeight.w800,
                        fontSize: 22.0)),
                Container(height: Dimen.extra_small_padding),
                Text(item.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colours.PRIMARY_TEXT_COLOR,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0)),
              ],
            ))))
    .toList();

class OnBoardingCarousel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnBoardingCarouselState();
  }
}

class _OnBoardingCarouselState extends State<OnBoardingCarousel> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimen.large_padding),
            child: CarouselSlider(
              items: _imageSliders,
              carouselController: _controller,
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  aspectRatio: 1.5,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _carouselItems.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white)
                        .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
