import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';

class EmptySearch extends StatelessWidget {
  final CloudCertificationType type;
  final TextEditingController searchController;

  const EmptySearch({
    required this.type,
    required this.searchController});

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
            onPressed: () {
              searchController.clear();

              switch(type) {
                case CloudCertificationType.completed:
                  BlocProvider.of<CloudCertificationBloc>(context)
                      .add(GetCompletedCertificationsEvent());
                  break;
                case CloudCertificationType.in_progress:
                  BlocProvider.of<CloudCertificationBloc>(context)
                      .add(GetInProgressCertificationsEvent());
                  break;
              }
            },
            child: const Text('Clear')),
      ],
    );
  }
}