import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_countdown/slide_countdown.dart';

class RamdanCounter extends StatefulWidget {
  const RamdanCounter({super.key});

  @override
  State<RamdanCounter> createState() => _RamdanCounterState();
}

class _RamdanCounterState extends State<RamdanCounter> {
  DateTime ramadanTime = DateTime(2025, 2, 28, 17, 53, 0);
  Duration duration = Duration.zero;
  @override
  void initState() {
    super.initState();
    duration = ramadanTime.difference(DateTime.now());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        title: Text(
          'فاضل ع الحلو كام تكة',
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          height: 50.h,
          child: SlideCountdownSeparated(
            decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
            duration: duration,
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
