import 'dart:io';

import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/Components/badNetwork.dart';
import 'package:academia/Components/custom_snack.dart';
import 'package:academia/Components/disconnectDialog.dart';
import 'package:academia/Components/noNetwork.dart';
import 'package:academia/HttpRequest/Api.dart';
import 'package:academia/HttpRequest/notificationrequest.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert' as convert;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HandleError {
  HandleError._();
  static Future<dynamic> buildError(BuildContext context, dynamic error,
      [GlobalKey<ScaffoldState> scaffoldKey]) async {
    if (error is DioError && error.type == DioErrorType.RESPONSE) {
      var message = convert.jsonDecode(error.response.toString());

      if (error.response.statusCode == 403) {
        await NotificationRequest.destroy();
        await DatabaseHelper.instance.deleteUser();
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => DisconnectDialog());
      } else {
        var custom = new CustomSnack(message['error'], "warning");
        return scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: custom.getText(),
          ),
        );
      }
    } else if ((error is DioError &&
            error.type == DioErrorType.DEFAULT &&
            error.error != null &&
            error.error is SocketException &&
            error.type != DioErrorType.CONNECT_TIMEOUT) ||
        error is SocketException) {
      Connectivity connectivity = Connectivity();
      ConnectivityResult connectivityResult =
          await connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => Nonetwork());
      }
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => BadNetwork());
    } else if (error is DioError &&
        error.type == DioErrorType.CONNECT_TIMEOUT) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => BadNetwork());
    } else if (error is HttpExceptionWithStatus && error.statusCode == 401) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => DisconnectDialog());
    } else {
      return showDialog(
          context: context, builder: (context) => AlerteNonetwork(error));
    }
  }
}
