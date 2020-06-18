//TODO The stimulation process is:
// 1. Thresshold determination (rating)
// 2. Thresshold determination - If over 5000, use only one rating instead of two
// 3. Threshold Summary - Average of 1 and 2 (background), to stimulation screen
// 4. STIM 1 (66 automatic stimuli at pain free. 50% and 75% of the tolerance threshold - just the 3 vaues gets passed in and the device does the rest - back to threshold screen
// 5. Threshold determination
// 6. Threshold determination
// 7. Threshold Summary - Average of 1 and 2 (background), to stimulation screen
// 8. STIM 2 same as 1 (change the stim screen number from 1 to 2 and the Stim Finished button to indigo and back to this screen anfter 1 and 2 unplug after 2
// 9. Threshold determination
// 10. Threshold determination
// 11. Threshold Summary - To session review screen (keep off until 1-9 are done
// The determinations(each time 3 mA values need to be stored in to Mysql and sent to the device for stimulation
// When 0 is pressed it should change the 0 color to Color(0xffD97676), the sensory button to color: AppColors.primaryElement, the PAIN ONSET to Indigo and the mA value saved
// When 1 is pressed it should change 1 color to light green, the Pain Onset button to color: to indigo, and the mA value saved
// When the other numbers are pressed it should change color to light green, the Tolerance Rating button to idiogo and the pain onset button to AppColors.primaryElement,and the mA value saved
// When 10 is pressed it should flash red change capture the value and leave the screed ti the next threshold screen or the threshold summary
// As interim numbers are pressed (based upon patient response) the colors should go to light red and stim mA captured with the number.
// After the number 0 is pressed, the stim button should be turn off untill a number is pressed.  A number can be pressed more than once, but all smaller numbers should be unpressble one a larger umber is pressed.
// The stim mA goes up by 200 mA every time that the stim button is pressed.
/*
*  threshold_determination_screen.dart
*  KleinKlein Wireframes
*
*  Created by marc.
*  Copyright © 2018 Uni-Marburg. All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:implulsnew/styles/button.dart';
import 'package:implulsnew/styles/h2.dart';
import 'package:implulsnew/styles/h4.dart';
import 'package:implulsnew/screens/threshold_summary_screen.dart';
import 'package:implulsnew/values/values.dart';

class ThresholdDeterminationWidget extends StatefulWidget {
  @override
  _ThresholdDeterminationWidgetState createState() =>
      _ThresholdDeterminationWidgetState();
}

class _ThresholdDeterminationWidgetState
    extends State<ThresholdDeterminationWidget> {
  void onStimButtonPressed(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ThresholdSummaryWidget()));
  void onRatingSTPressed(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ThresholdSummaryWidget()));
  void onRatingPOPressed(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ThresholdSummaryWidget()));
  void onRatingTTPressed(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ThresholdSummaryWidget()));

  final int stimAmplitude = 200;
  final int currentIBI = 750;

//  BoxDecoration borderDecoration() {
//    return BoxDecoration(
//      border: Border.all(
//        width: 1, //                   <--- border width here
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    List<int> text = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          H2(
            child: Text(
              "Threshold Determination",
              textAlign: TextAlign.left,
              style: TextStyle(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              H4(
                child: Text(
                  "Stim Level: $stimAmplitude mA       ",
                  textAlign: TextAlign.left,
                  style: TextStyle(),
                ),
              ),
              ButtonButton(
                padding: EdgeInsets.all(0),
                onPressed: () => this.onStimButtonPressed(context),
                child: Text(
                  "STIMULATE",
                  textAlign: TextAlign.left,
                  style: TextStyle(),
                ),
              ),
              H4(
                child: Text(
                  "          IBI: $currentIBI mSec",
                  textAlign: TextAlign.left,
                  style: TextStyle(),
                ),
              ),
            ],
          ),
          H4(
            child: Text(
              "Pain Rating",
              textAlign: TextAlign.left,
              style: TextStyle(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i in text)
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "$i",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 23,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonButton(
                padding: EdgeInsets.all(0),
                onPressed: () => this.onRatingSTPressed(context),
                child: Text(
                  "SENSORY RATING",
                  textAlign: TextAlign.left,
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonButton(
                  color: AppColors.primaryElement,
                  padding: EdgeInsets.all(0),
                  onPressed: () => this.onRatingPOPressed(context),
                  child: Text(
                    "PAIN ONSET RATING",
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
              ),
              ButtonButton(
                color: AppColors.primaryElement,
                padding: EdgeInsets.all(0),
                onPressed: () => this.onRatingSTPressed(context),
                child: Text(
                  "TOLERANCE RATING",
                  textAlign: TextAlign.left,
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
