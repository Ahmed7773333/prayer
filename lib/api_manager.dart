import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:prayer/logic/location.dart';
import 'package:prayer/model.dart';

const String endPoint = 'http://api.aladhan.com/v1/timings/';

class ApiManager {
  Dio dio = Dio();
  DateTime now = DateTime.now();

  Future<TimesModel> getTimes() async {
    final String date = DateFormat('dd-MM-yyyy').format(now);
    final Position position = await getCurrentLocation();
    Response response = await dio.get(
        '$endPoint$date?latitude=${position.latitude}&longitude=${position.longitude}');
    debugPrint(response.data.toString());
    TimesModel result = TimesModel.fromJson(response.data);
    return result;
  }
}
