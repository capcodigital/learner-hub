import 'dart:convert';
import 'dart:developer';

import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:http/http.dart' as http;

abstract class CloudCertificationRemoteDataSource {
  Future<List<CloudCertificationModel>> getCompletedCertifications();
  Future<List<CloudCertificationModel>> getInProgressCertifications();
}

class CloudCertificationRemoteDataSourceImpl
    implements CloudCertificationRemoteDataSource {
  CloudCertificationRemoteDataSourceImpl({required this.client});
  static const TAG = 'CloudCertificationRemoteDataSourceImpl:';
  final http.Client client;

  @override
  Future<List<CloudCertificationModel>> getCompletedCertifications() {
    return _getDataFromUrl(
        '${Constants.BASE_API_URL}/${Constants.COMPLETED_URL}');
  }

  @override
  Future<List<CloudCertificationModel>> getInProgressCertifications() {
    return _getDataFromUrl(
        '${Constants.BASE_API_URL}/${Constants.IN_PROGRESS_URL}');
  }

  Future<List<CloudCertificationModel>> _getDataFromUrl(String url) async {
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == Constants.STATUS_CODE_200) {
        return (json.decode(response.body) as List)
            .map((e) => CloudCertificationModel.fromJson(e))
            .toList();
      } else {
        throw ServerException(
            message: _mapStatusCodeToMessage(response.statusCode));
      }
    } on Exception catch (ex) {
      if (ex is ServerException) rethrow;
      log(TAG + ex.toString());
      throw ServerException(message: Constants.SERVER_FAILURE_MSG);
    }
  }

  String _mapStatusCodeToMessage(int errorStatusCode) {
    switch (errorStatusCode) {
      case Constants.STATUS_CODE_500:
        return Constants.SERVER_ERROR_500;
      case Constants.STATUS_CODE_404:
        return Constants.SERVER_ERROR_404;
      default:
        return Constants.SERVER_FAILURE_MSG;
    }
  }
}
