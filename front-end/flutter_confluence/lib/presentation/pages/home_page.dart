import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/presentation/widgets/searchbox.dart';

import '../bloc/cloud_certification_bloc.dart';
import '../widgets/certifications_view.dart';
import '../widgets/toggle-switch.dart';

class HomePage extends StatelessWidget {
  static const double appTitleTextSize = 18.0;
  static const double toggleButtonPaddingTop = 23.0;
  static const double toggleButtonPaddingBottom = 16.0;

  static const double headerItemsSpacing = 23.0;
  static const double headerTopPadding = 23.0;
  static const double headerBottomPadding = 16.0;
  static const double searchbarHorizontalPadding = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Cloud Certifications',
            style: TextStyle(fontSize: appTitleTextSize),
          ),
        ),
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/ic_home_background.png"),
                    fit: BoxFit.cover)),
            child: buildBody(context)));
  }

  buildBody(BuildContext context) {
    void doSearch(String searchTerm) {
      BlocProvider.of<CloudCertificationBloc>(context)
          .add(SearchCertificationsEvent(searchTerm));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: headerTopPadding, bottom: headerBottomPadding),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: searchbarHorizontalPadding,
                    right: searchbarHorizontalPadding),
                child: SearchBox(
                  onSearchTermChanged: doSearch,
                  onSearchSubmitted: doSearch,
                ),
              ),
              SizedBox(
                height: headerItemsSpacing,
              ),
              ToggleButton()
            ],
          ),
        ),
        BlocBuilder<CloudCertificationBloc, CloudCertificationState>(
          builder: (context, state) {
            log("HOME PAGE - New State received: " + state.toString());
            if (state is Loaded) {
              return Expanded(child: CertificationsView(items: state.items));
            } else if (state is Loading)
              return Text('Loading...');
            else if (state is Empty)
              return Text('No results');
            else if (state is EmptySearchResult)
              return Text('No results found');
            else if (state is Error)
              return Text('Error');
            else
              return Text('Unknown state');
          },
        )
      ],
    );
  }
}
