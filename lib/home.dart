import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prayer/api_manager.dart';
import 'package:prayer/logic/next_prayer.dart';
import 'package:prayer/model.dart';
import 'package:prayer/ramdan_counter.dart';
import 'package:prayer/shared_prefrence.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:one_clock/one_clock.dart';
import 'package:permission_handler/permission_handler.dart' as per;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimesModel? data;
  Duration duration = Duration.zero;
  LocalModel model = LocalModel();
  Map<String, String> map = {};

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    await per.Permission.notification.request();
    DateTime now = DateTime.now();
    String currntDayy =
        now.year.toString() + now.month.toString() + now.day.toString();
    debugPrint(currntDayy);
    model = await SharedPrefrenceHelper.getLocalData();
    if (currntDayy != model.currntDay) {
      data = await ApiManager().getTimes();
      await SharedPrefrenceHelper.saveLocalData(data);
      model = await SharedPrefrenceHelper.getLocalData();
      await Alarm.set(alarmSettings: returnAlarmSettings(101, model.fajr));
      await Alarm.set(alarmSettings: returnAlarmSettings(102, model.duhr));
      await Alarm.set(alarmSettings: returnAlarmSettings(103, model.asr));
      await Alarm.set(alarmSettings: returnAlarmSettings(104, model.maghrib));
      await Alarm.set(alarmSettings: returnAlarmSettings(105, model.isha));
    }
    map = {
      'الفجر': model.fajr,
      'الشروق': model.sunRise,
      'الظهر': model.duhr,
      'العصر': model.asr,
      'المغرب': model.maghrib,
      'العشاء': model.isha,
      'منتصف الليل': model.midnight,
      'الثلث الأول': model.firstThird,
      'الثلث الأخير': model.lastThird
    };

    duration = getTimeLeft(map);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 45.h),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            getData();
          },
          child: Icon(
            Icons.refresh_rounded,
            color: Colors.blue[800],
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: DigitalClock(
                showSeconds: false,
                isLive: true,
                datetime: DateTime.now(),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '${returnNumberName(model.date)} من ${(model.month)} لسنة ${(model.year)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (map.isNotEmpty)
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'الصلاة التالية هي\n' +
                      (getNextPrayer(map) ?? '') +
                      '\n${convertTimeTo12HourFormat(map[getNextPrayer(map) ?? '']!)}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            SizedBox(height: 20.h),
            if (map.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'الوقت المتبقي للصلاة القادمة',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SlideCountdownSeparated(
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    duration: duration,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                    onDone: () {
                      Future.delayed(Duration(seconds: 2), () {
                        duration = getTimeLeft(map);
                        setState(() {});
                      });
                    },
                  ),
                ],
              ),
            SizedBox(height: 30.h),
            // Table of prayer times
            Table(
              border: TableBorder.all(color: Colors.blue[600]!),
              columnWidths: const {
                0: FlexColumnWidth(1), // Column for the name
                1: FlexColumnWidth(1), // Column for the time
              },
              children: map.entries.map((entry) {
                bool isNextPrayer = entry.key == getNextPrayer(map);
                return TableRow(
                  decoration: isNextPrayer
                      ? BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(1),
                              blurRadius: 8.r,
                            ),
                          ],
                        )
                      : null,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Text(
                        entry.key,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Text(
                        convertTimeTo12HourFormat(entry.value),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 30.h),
            // Timezone and weekday row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  model.city,
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RamdanCounter()));
                  },
                  child: Text(
                    'وقت رمضان',
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  (model.weekDay),
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
    );
  }
}
