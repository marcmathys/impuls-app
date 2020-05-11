import 'dart:typed_data';
import 'package:flutter/services.dart';

var temp = 5;

ByteData getByteDataFromBitList( List<int> intList ,{ bool is4Bytes = false  } )
{
   if(!is4Bytes)
   {
    Int16List toObjectForm =  Int16List.fromList(intList);
    return ByteData.sublistView(toObjectForm);
   }
   else
   { var listDouble = intList.map((i) => i.toDouble()).toList();
     Float32List toObjectform = Float32List.fromList(listDouble);
     return ByteData.sublistView(toObjectform);
   }
}

void swapBytes(List<int> ekgValues) {
  if (ekgValues.length == 2) {
    temp = ekgValues[0];
    ekgValues[0] = ekgValues[1];
    ekgValues[1] = temp;


  } else if (ekgValues.length == 4) {
    temp = ekgValues[0];
    ekgValues[0] = ekgValues[3];
    ekgValues[3] = temp;
    temp = ekgValues[1];
    ekgValues[1] = ekgValues[2];
    ekgValues[2] = temp;
  }
}