import 'dart:typed_data';

import 'package:flutter/services.dart';

ByteData getByteDataFromBitList(  { bool is4Bytes = false ,List<int> twoByteList  ,List<double> fourByteList } )
{
   if(!is4Bytes)
   {
    Int16List toObjectForm =  Int16List.fromList(twoByteList);
    return ByteData.sublistView(toObjectForm);
   }
   else
   {
     Float32List toObjectform = Float32List.fromList(fourByteList);
     return ByteData.sublistView(toObjectform);
   }

}