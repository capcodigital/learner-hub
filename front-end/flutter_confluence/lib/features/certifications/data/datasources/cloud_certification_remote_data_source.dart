import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class CloudCertificationRemoteDataSource {
  Future<List<CloudCertificationModel>> getCompletedCertifications();
  Future<List<CloudCertificationModel>> getInProgressCertifications();
}

class CloudCertificationRemoteDataSourceImpl extends CloudCertificationRemoteDataSource {
  final http.Client client;

  CloudCertificationRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CloudCertificationModel>> getCompletedCertifications() {
    return _getDataFromUrl(Constants.BASE_API_URL + '/' + Constants.COMPLETED_URL);
  }

  @override
  Future<List<CloudCertificationModel>> getInProgressCertifications() {
    return _getDataFromUrl(Constants.BASE_API_URL + '/' + Constants.IN_PROGRESS_URL);
  }

  Future<List<CloudCertificationModel>> _getDataFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => CloudCertificationModel.fromJson(e))
          .toList();

    } else {
      throw ServerException();
    }
  }
}