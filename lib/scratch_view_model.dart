import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:litt/api_service.dart';
import 'package:litt/locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scratcher/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';


/*
* Scratch and Win View Model
* Manages the state of the View, business logic, 
* and any other logic as required from user interaction. 
* It does this by making use of the services.
*/
class ScratchViewModel extends BaseViewModel {
  final APIService _apiService = locator<APIService>();
  late ScratchStatus scratchStatus;
  late int littPoints;
  final scratchCardkey = GlobalKey<ScratcherState>();
  ScreenshotController screenshotController = ScreenshotController();

  getScratchCard() async {
    bool isWin = await _apiService.getScratchCard();
    if (isWin) {
      littPoints = await _apiService.getScratchPoints();
      scratchStatus = ScratchStatus.win;
    } else {
      scratchStatus = ScratchStatus.loss;
    }
    notifyListeners();
  }

  reSetScratchCard() {
    if (scratchCardkey.currentState != null) {
      scratchCardkey.currentState!.reset();
    }
    scratchStatus = ScratchStatus.intitial;
    notifyListeners();
  }

  setInitialData() {
    scratchStatus = ScratchStatus.intitial;
  }

  screenshot() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath =
            await File('${directory.path}/screenshot.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareFiles(
          [imagePath.path],
          text: "screenshot",
          subject: "screenshot",
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

enum ScratchStatus {
  intitial,
  win,
  loss,
}
