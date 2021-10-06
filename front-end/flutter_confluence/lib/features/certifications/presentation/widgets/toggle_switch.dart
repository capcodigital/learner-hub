import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/layout_constants.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';

class ToggleButton extends StatefulWidget {
  static const TXT_COMPLETED = 'Completed';
  static const TXT_IN_PROGRESS = 'In Progress';

  @override
  ToggleButtonState createState() => ToggleButtonState();
}

class ToggleButtonState extends State<ToggleButton> {
  final Color jiraColor = Constants.JIRA_COLOR;
  final double minWidth = 300.0;
  final double height = 50.0;
  final double inProgressAlign = -1;
  final double completedAlign = 1;
  final Color selectedColor = Colors.white;
  final Color normalColor = Constants.JIRA_COLOR;

  double? xAlign;
  Color? inProgressColor;
  Color? completedColor;

  @override
  void initState() {
    super.initState();
    xAlign = inProgressAlign;
    inProgressColor = selectedColor;
    completedColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    final scaledWidth =
        math.max(getWidth(context, LayoutConstants.BIG_SCALE), minWidth);
    return Container(
      width: scaledWidth,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: jiraColor, width: 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(scaledWidth * LayoutConstants.MEDIUM_SCALE),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign!, 0),
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: scaledWidth * LayoutConstants.HALF_SIZE_SCALE,
              height: height,
              decoration: BoxDecoration(
                color: jiraColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = inProgressAlign;
                inProgressColor = selectedColor;
                completedColor = normalColor;
                BlocProvider.of<CloudCertificationBloc>(context)
                    .add(GetInProgressCertificationsEvent());
              });
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: scaledWidth * LayoutConstants.HALF_SIZE_SCALE,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(ToggleButton.TXT_IN_PROGRESS,
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.copyWith(color: inProgressColor)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = completedAlign;
                completedColor = selectedColor;
                inProgressColor = normalColor;
                BlocProvider.of<CloudCertificationBloc>(context)
                    .add(GetCompletedCertificationsEvent());
              });
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: scaledWidth * LayoutConstants.HALF_SIZE_SCALE,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(ToggleButton.TXT_COMPLETED,
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.copyWith(color: completedColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
