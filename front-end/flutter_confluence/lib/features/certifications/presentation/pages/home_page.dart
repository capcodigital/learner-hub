import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants.dart';
import 'error_page.dart';
import '../widgets/empty_search.dart';
import '../widgets/searchbox.dart';
import '../bloc/cloud_certification_bloc.dart';
import '../widgets/certifications_view.dart';
import '../widgets/toggle-switch.dart';

class HomePage extends StatefulWidget {
  static const route = 'HomePage';

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  static const double frontLayerLeftMargin = 40;
  static const double frontLayerInitialTop = 130;
  static const double parallaxSmoothFactor = 0.1;
  static const double headerItemsSpacing = 23.0;
  static const double headerTopPadding = 23.0;
  static const double headerBottomPadding = 16.0;
  static const double searchbarHorizontalPadding = 25.0;
  var frontLayerTop = frontLayerInitialTop;
  var disableSearchAndToggle = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Certifications',
            style: Theme.of(context).textTheme.headline1),
        automaticallyImplyLeading: false,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.scrollDelta != null) {
              final delta = notification.scrollDelta!;
              setState(() {
                frontLayerTop += delta * parallaxSmoothFactor;
              });
            }
          }
          return true;
        },
        child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/back-layer.png"),
                    fit: BoxFit.cover)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: frontLayerLeftMargin,
                  top: frontLayerTop,
                  child: Image.asset('assets/front-layer.png'),
                ),
                buildTable(context)
              ],
            )));
  }

  Widget buildTable(BuildContext context) {
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
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Constants.getWidgetFilterColor(disableSearchAndToggle),
                    BlendMode.modulate,
                  ),
                  child: IgnorePointer(
                    ignoring: disableSearchAndToggle,
                    child: SearchBox(
                      controller: searchController,
                      onSearchTermChanged: doSearch,
                      onSearchSubmitted: doSearch,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: headerItemsSpacing,
              ),
              ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Constants.getWidgetFilterColor(disableSearchAndToggle),
                    BlendMode.modulate,
                  ),
                  child: IgnorePointer(
                      ignoring: disableSearchAndToggle, child: ToggleButton())),
            ],
          ),
        ),
        BlocConsumer<CloudCertificationBloc, CloudCertificationState>(
            builder: (context, state) {
          log("HOME PAGE - New State received: " + state.toString());
          if (state is Loaded) {
            return Expanded(child: CertificationsView(items: state.items));
          } else if (state is Loading)
            return Container(
                margin: EdgeInsets.only(top: 60),
                child: CircularProgressIndicator());
          else if (state is Empty)
            return Text(Constants.NO_RESULTS);
          else if (state is EmptySearchResult)
            return EmptySearch(
                type: state.cloudCertificationType,
                searchController: searchController);
          else if (state is Error)
            return ErrorPage(error: state);
          else
            return Text(Constants.UNKNOWN_ERROR);
        }, listener: (context, state) {
          setState(() {
            disableSearchAndToggle = state is Error;
            if (disableSearchAndToggle) FocusScope.of(context).unfocus();
          });
        })
      ],
    );
  }
}
