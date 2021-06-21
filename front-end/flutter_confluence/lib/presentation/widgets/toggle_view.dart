import 'package:flutter/material.dart';

// The ToggleButton we already have. I copied the file
// and renamed it to avoid confilcts. Will delete this one and
// use the original when merge develop to this branch
class ToggleView extends StatefulWidget {
  final Function(ToggleState) callback;

  ToggleView(this.callback);

  @override
  _ToggleButtonState createState() => _ToggleButtonState(callback);
}

enum ToggleState { COMPLETED, IN_PROGRESS }

class _ToggleButtonState extends State<ToggleView> {
  static const JIRA_COLOR = const Color(0xff0052CC);
  final Color jiraColor = JIRA_COLOR;
  final double width = 300.0;
  final double height = 50.0;
  final double inProgressAlign = -1;
  final double completedAlign = 1;
  final Color selectedColor = Colors.white;
  final Color normalColor = JIRA_COLOR;

  double? xAlign;
  Color? inProgressColor;
  Color? completedColor;

  final Function callback;

  _ToggleButtonState(this.callback);

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
                callback.call(ToggleState.IN_PROGRESS);
              });
            },
            child: Align(
              alignment: Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'In Progress',
                  style: TextStyle(
                    color: inProgressColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = completedAlign;
                completedColor = selectedColor;
                inProgressColor = normalColor;
                callback.call(ToggleState.COMPLETED);
              });
            },
            child: Align(
              alignment: Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: completedColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
