import 'dart:typed_data';

import 'package:flutter/services.dart';

ByteData getByteDataFromBitList( List<int> intList ,{ bool is4Bytes = false  } )
{
   if(!is4Bytes)
   {
    Int16List toObjectForm =  Int16List.fromList(intList.reversed.toList());
    return ByteData.sublistView(toObjectForm);
   }
   else
   { var listDouble = intList.map((i) => i.toDouble()).toList();
     Float32List toObjectform = Float32List.fromList(listDouble);
     return ByteData.sublistView(toObjectform);
   }

}