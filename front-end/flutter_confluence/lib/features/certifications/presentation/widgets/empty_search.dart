import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/dimen.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';

class EmptySearch extends StatelessWidget {
  static const TXT_NO_RESULTS = "No results found";
  static const TXT_CLEAR = "Clear";

  final CloudCertificationType type;
  final TextEditingController searchController;

  const EmptySearch({required this.type, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: getHeight(context, Dimen.scale_3_100),
              bottom: getHeight(context, Dimen.scale_3_100)),
          child: Text(TXT_NO_RESULTS, style: TextStyle(fontSize: 18)),
        ),
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
              switch (type) {
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
