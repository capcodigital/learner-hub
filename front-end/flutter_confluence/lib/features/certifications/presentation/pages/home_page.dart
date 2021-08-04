import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/dimen.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/certification_hive_helper.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  static const double frontLayerInitialTop = 130;
  static const double parallaxSmoothFactor = 0.1;
  var frontLayerTop = frontLayerInitialTop;
  var disableSearchAndToggle = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fixes bottom overflow error when show keyboard in landscape
      resizeToAvoidBottomInset: false,
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
            width: getMediaWidth(context),
            height: getMediaHeight(context),
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/back-layer.png"),
                    fit: BoxFit.cover)),
            child: LayoutBuilder(
                builder: (BuildContext ctx, BoxConstraints constraints) {
              final parallaxLayerLeft = isPortrait(ctx)
                  ? constraints.maxWidth * Dimen.scale_6_100
                  : constraints.maxWidth * Dimen.scale_35_100;
              return Stack(
                children: <Widget>[
                  Positioned(
                    left: parallaxLayerLeft,
                    top: frontLayerTop,
                    child: Image.asset('assets/front-layer.png'),
                  ),
                  buildTable(context, constraints)
                ],
              );
            })));
  }

  Widget buildTable(BuildContext context, BoxConstraints constraints) {
    void doSearch(String searchTerm) {
      BlocProvider.of<CloudCertificationBloc>(context)
          .add(SearchCertificationsEvent(searchTerm));
    }

    final verticalPadding = isPortrait(context)
        ? constraints.maxHeight * Dimen.scale_2_100
        : constraints.maxHeight * Dimen.scale_4_100;
    final horizontalPadding = isPortrait(context)
        ? constraints.maxWidth * Dimen.scale_9_100
        : constraints.maxWidth * Dimen.scale_12_100;
    return Column(
      children: [
        // Padding around Search and Toggle
        Padding(
          padding: EdgeInsets.only(
            top: verticalPadding,
            bottom: verticalPadding,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Column(
            children: [
              // Search
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  disableSearchAndToggle
                      ? Constants.DISABLED_COLOR
                      : Colors.white,
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
              // Toggle
              Padding(
                padding: EdgeInsets.only(
                    top: isPortrait(context)
                        ? constraints.maxHeight * Dimen.scale_3_100
                        : constraints.maxHeight * Dimen.scale_5_100),
                child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      disableSearchAndToggle
                          ? Constants.DISABLED_COLOR
                          : Colors.white,
                      BlendMode.modulate,
                    ),
                    child: IgnorePointer(
                        ignoring: disableSearchAndToggle,
                        child: ToggleButton())),
              ),
            ],
          ),
        ),
        BlocConsumer<CloudCertificationBloc, CloudCertificationState>(
            builder: (context, state) {
          log("HOME PAGE - New State received: " +
              state.runtimeType.toString());
          if (state is Loaded) {
            return Expanded(child: CertificationsView(items: state.items));
          } else if (state is Loading)
            return Container(
                margin: EdgeInsets.only(
                    top: constraints.maxHeight * Dimen.scale_5_100),
                child: PlatformCircularProgressIndicator());
          else if (state is Empty)
            return Text(Constants.NO_RESULTS);
          else if (state is EmptySearchResult)
            return EmptySearch(
                type: state.cloudCertificationType,
                searchController: searchController);
          else if (state is Error)
            return Expanded(child: ErrorPage(error: state));
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
