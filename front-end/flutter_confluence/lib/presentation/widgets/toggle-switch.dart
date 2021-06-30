import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';

class ToggleButton extends StatefulWidget {
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  static const textSize = 16.0;

  final Color jiraColor = Constants.JIRA_COLOR;
  final double width = 300.0;
  final double height = 50.0;
  final double inProgressAlign = -1;
  final double completedAlign = 1;
  final Color selectedColor = Colors.white;
  final Color normalColor = Constants.JIRA_COLOR;

  double? xAlign;
  Color? inProgressColor;
  Color? completedColor;

  void fetchCompletedCertifications(BuildContext context) {
    BlocProvider.of<CloudCertificationBloc>(context)
        .add(GetCompletedCertificationsEvent());
  }

  void fetchInProgressCertifications(BuildContext context) {
    BlocProvider.of<CloudCertificationBloc>(context)
        .add(GetInProgressCertificationsEvent());
  }

  @override
  void initState() {
    super.initState();
    xAlign = inProgressAlign;
    inProgressColor = selectedColor;
    completedColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: jiraColor, width: 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign!, 0),
            duration: Duration(milliseconds: 300),
            child: Container(
              width: width * 0.5,
              height: height,
              decoration: BoxDecoration(
                color: jiraColor,
                borderRadius: BorderRadius.all(
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
                // Check if this is the correct function to call,
                // it may be the inprogress that you need to call
                fetchInProgressCertifications(context);
              });
            },
            child: Align(
              alignment: Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text('In Progress',
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
                fetchCompletedCertifications(context);
              });
            },
            child: Align(
              alignment: Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text('Completed',
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
