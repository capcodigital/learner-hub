import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/layout_constants.dart';
import '/features/onboarding/presentation/widgets/indicator_icon.dart';

class _OnBoardingCarouselItem {
  _OnBoardingCarouselItem(
      {required this.asset, required this.title, required this.description});

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
      description:
          'Keep track of your training by making your own study guide!'),
  _OnBoardingCarouselItem(
      asset: 'assets/chat_icon.png',
      title: 'Chat with colleagues',
      description:
          'Talk with your colleagues and share resources about your training materials'),
];

List<Widget> _getImageSliders(BuildContext context) {
  return _carouselItems
      .map((item) => Column(
            children: [
              Image.asset(item.asset),
              Padding(
                padding: const EdgeInsets.all(LayoutConstants.LARGE_PADDING),
                child: Column(
                  children: [
                    Text(item.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1),
                    const SizedBox(height: LayoutConstants.SMALL_PADDING),
                    Text(item.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1),
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
        padding: const EdgeInsets.only(top: LayoutConstants.LARGE_PADDING),
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
              padding: const EdgeInsets.symmetric(
                  horizontal: LayoutConstants.EXTRA_SMALL_PADDING / 2,
                  vertical: 0),
              child: IndicatorIcon(isSelected: _currentIndex == entry.key),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
