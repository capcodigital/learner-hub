import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/dimen.dart';
import '/features/onboarding/presentation/widgets/indicator_icon.dart';

class _OnBoardingCarouselItem {
  _OnBoardingCarouselItem({required this.asset, required this.title, required this.description});

  final String asset;
  final String title;
  final String description;
}

final List<_OnBoardingCarouselItem> _carouselItems = [
  _OnBoardingCarouselItem(
      asset: 'assets/certifications_icon.png',
      title: 'Certifications & standards',
      description:
          'View all the certifications that you can do at Capco, as well as the coding standard guidelines we have produced!'),
  _OnBoardingCarouselItem(
      asset: 'assets/guides_icon.png',
      title: 'Create guides',
      description: 'Do you want to make this completed  message goes here'),
  _OnBoardingCarouselItem(
      asset: 'assets/chat_icon.png',
      title: 'Chat with colleagues',
      description: 'Do you want to make this completed  message goes here'),
];

List<Widget> _getImageSliders(BuildContext context) {
  return _carouselItems
      .map((item) => Column(
            children: [
              Image.asset(item.asset),
              Padding(
                padding: const EdgeInsets.all(Dimen.large_padding),
                child: Column(
                  children: [
                    Text(item.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline1),
                    const SizedBox(height: Dimen.small_padding),
                    Text(item.description, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              )
            ],
          ))
      .toList();
}

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
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: Dimen.large_padding),
        child: CarouselSlider(
          items: _getImageSliders(context),
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: false,
              height: MediaQuery.of(context).size.height / 3,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _carouselItems.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimen.extra_small_padding / 2, vertical: 0),
              child: IndicatorIcon(isSelected: _currentIndex == entry.key),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
