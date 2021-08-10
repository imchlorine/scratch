import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:litt/scratch_view_model.dart';
import 'package:scratcher/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stacked/stacked.dart';



/*
* Scratch and Win UI View 
*/
class ScratchView extends StatefulWidget {
  ScratchView({Key? key}) : super(key: key);

  @override
  _ScratchViewState createState() => _ScratchViewState();
}

class _ScratchViewState extends State<ScratchView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScratchViewModel>.reactive(
      viewModelBuilder: () => ScratchViewModel(),
      onModelReady: (model) => model.setInitialData(),
      builder: (context, model, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Screenshot(
            controller: model.screenshotController,
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top,
                  bottom: MediaQuery.of(context).viewPadding.bottom,
                ),
                child: Column(
                  children: [
                    topBar(model),
                    title(),
                    Expanded(
                      child: scratchCard(model),
                    ),
                    buttons(model),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget topBar(ScratchViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              model.reSetScratchCard();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(Icons.close_rounded, color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              model.screenshot();
            },
            child: Icon(Icons.camera_alt_outlined, color: Colors.white),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              primary: Colors.grey, // <-- Button color
            ),
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Container(
      height: 150,
      child: Image.asset("assets/images/scratch_win.png"),
    );
  }

  Widget scratchCard(ScratchViewModel model) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Scratcher(
        key: model.scratchCardkey,
        brushSize: 50,
        threshold: 20,
        accuracy: ScratchAccuracy.low,
        image: Image.asset(
          "assets/images/scratch_win_cover.png",
        ),
        onThreshold: () {
          model.getScratchCard();
        },
        child: Stack(
          children: [
            Container(
              height: 400,
              child: Image.asset(
                "assets/images/confetti_background.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              child: scratchResult(model),
            ),
          ],
        ),
      ),
    );
  }

  Widget scratchResult(ScratchViewModel model) {
    switch (model.scratchStatus) {
      case ScratchStatus.intitial:
        return Container();
      case ScratchStatus.win:
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                child: Image.asset("assets/images/litt_medal.png"),
              ),
            ),
            Text(
              "Congratulations!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                text: "You earned ",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "${model.littPoints} LITT points",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        );
      case ScratchStatus.loss:
        return Center(
          child: Container(
            width: 160,
            child: Text(
              "You didn't win anything this time. Try again later.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget buttons(ScratchViewModel model) {
    return Container(
      height: 45,
      width: double.infinity,
      margin: EdgeInsets.all(20),
      child: model.scratchStatus != ScratchStatus.intitial
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(model.scratchStatus == ScratchStatus.win
                  ? "Check your LITT points balance"
                  : "close"),
              onPressed: () {
                if (model.scratchStatus == ScratchStatus.loss) {
                  model.reSetScratchCard();
                }
              },
            )
          : Image.asset(
              "assets/images/refer.png",
            ),
    );
  }
}
