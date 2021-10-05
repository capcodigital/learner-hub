import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/layout_constants.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../core/constants.dart';
import '../bloc/cloud_certification_bloc.dart';
import '../widgets/certifications_view.dart';
import '../widgets/empty_search.dart';
import '../widgets/searchbox.dart';
import '../widgets/toggle_switch.dart';
import 'error_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.appBar}) : super(key: key);
  static const route = 'HomePage';
  final PreferredSizeWidget appBar;

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
      appBar: widget.appBar,
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
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/back-layer.png'),
                    fit: BoxFit.cover)),
            child: LayoutBuilder(
                builder: (BuildContext ctx, BoxConstraints constraints) {
              final parallaxLayerLeft = isPortrait(ctx)
                  ? constraints.maxWidth * LayoutConstants.parallax_layer_left_scale_small
                  : constraints.maxWidth * LayoutConstants.parallax_layer_left_scale_large;
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
        ? constraints.maxHeight * LayoutConstants.tiny_scale
        : constraints.maxHeight * LayoutConstants.home_vertical_padding_scale_large;
    final horizontalPadding = isPortrait(context)
        ? constraints.maxWidth * LayoutConstants.home_horizontal_padding_scale_small
        : constraints.maxWidth * LayoutConstants.extra_small_scale;
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
                        ? constraints.maxHeight * LayoutConstants.toggle_space_top_scale_small
                        : constraints.maxHeight * LayoutConstants.toggle_space_top_scale_large),
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
          log('HOME PAGE - New State received: $state');
          if (state is Loaded) {
            return Expanded(child: CertificationsView(items: state.items));
          } else if (state is Loading)
            return Container(
                margin: EdgeInsets.only(
                    top: constraints.maxHeight * LayoutConstants.toggle_space_top_scale_large),
                child: PlatformCircularProgressIndicator());
          else if (state is Empty)
            return const Text(Constants.NO_RESULTS);
          else if (state is EmptySearchResult)
            return EmptySearch(
                type: state.cloudCertificationType,
                searchController: searchController);
          else if (state is Error)
            return Expanded(child: ErrorPage(error: state));
          else
            return const Text(Constants.UNKNOWN_ERROR);
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
