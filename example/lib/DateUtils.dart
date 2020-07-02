
import 'package:intl/intl.dart';
class DateUtils{



  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static String currentTimeMillisString() {
    int value=new DateTime.now().millisecondsSinceEpoch;
    return '$value';
  }

 //yyyy-MM-dd HH:mm:ss
  static DateTime getDateTimeFormat(String format,String time){
    DateTime dateTime = DateFormat(format).parse(time);
    return dateTime;
  }

  static int getDateTimeDay00(String date){
    DateTime nowDate=DateTime.fromMicrosecondsSinceEpoch(int.parse(date));
    DateTime dateTime =getDateTimeFormat('yyyy-MM-dd HH:mm:ss','${nowDate.year}-${nowDate.month}-${nowDate.day} 00:00:00');
    return dateTime.millisecondsSinceEpoch;
  }

  static int getDateTimeDay24(String date){
    DateTime nowDate=DateTime.fromMicrosecondsSinceEpoch(int.parse(date));
    DateTime dateTime =getDateTimeFormat('yyyy-MM-dd HH:mm:ss','${nowDate.year}-${nowDate.month}-${nowDate.day} 23:59:00');
    return dateTime.millisecondsSinceEpoch;
  }

  static int getDateTimeDay00DateTime(DateTime nowDate){
    DateTime dateTime =getDateTimeFormat('yyyy-MM-dd HH:mm:ss','${nowDate.year}-${nowDate.month}-${nowDate.day} 00:00:00');
    return dateTime.millisecondsSinceEpoch;
  }

  static int getDateTimeDay24DateTime(DateTime nowDate){
    DateTime dateTime =getDateTimeFormat('yyyy-MM-dd HH:mm:ss','${nowDate.year}-${nowDate.month}-${nowDate.day} 23:59:00');
    return dateTime.millisecondsSinceEpoch;
  }

  static String getTimeFormatHoursString(int minus){
    if(minus<60){
      return '累计分钟';
    }else if(minus<24*60){
      return '累计小时';
    }else{
      return '累计天数';
    }
  }
  static int getTimeFormatHoursValue(int minus){
    if(minus<60){
      return minus;
    }else if(minus<24*60){
      double v=minus/60;
      return v.toInt();
    }else{
      double temp=minus/60/24;
      int v=temp.toInt();
      return v;
    }
  }

}