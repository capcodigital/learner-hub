import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/ServerException.dart';
import 'package:flutter_confluence/data/models/CloudCertificationModel.dart';
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
      var rawJson = json.decode(response.body);
      var data = CertificationListDto.fromJson(rawJson);
      return data.certifications;
    } else {
      throw ServerException();
    }
  }
}

class CertificationListDto {
  final List<CloudCertificationModel> certifications;

  CertificationListDto({required this.certifications});

  factory CertificationListDto.fromJson(Map<String, dynamic> json) {
    var certs =
        json.values.map((e) => CloudCertificationModel.fromJson(e)).toList();
    return CertificationListDto(certifications: certs);
  }
}
