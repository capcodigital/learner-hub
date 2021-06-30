import 'package:flutter/material.dart';

class EmptySearch extends StatelessWidget {
  final VoidCallback? onClearPressed;

  const EmptySearch({this.onClearPressed});

  @override
  Widget build(BuildContext context) {
    const double spacing = 10.0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text("No results found", style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: spacing),
        TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: this.onClearPressed,
            child: const Text('Clear')),
      ],
    );
  }
}
