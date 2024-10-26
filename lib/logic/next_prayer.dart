import 'package:alarm/alarm.dart';
import 'package:intl/intl.dart';

String? getNextPrayer(Map<String, String> prayerTimes) {
  DateTime now = DateTime.now();
  DateFormat format = DateFormat("HH:mm");

  // Convert each prayer time to a DateTime object for today
  List<MapEntry<String, DateTime>> prayerTimesToday =
      prayerTimes.entries.map((entry) {
    DateTime prayerTime = format.parse(entry.value); // Convert time to DateTime
    // Set the date to today
    DateTime prayerDateTime = DateTime(
        now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
    return MapEntry(entry.key, prayerDateTime);
  }).toList();

  // Sort prayer times to ensure correct order
  prayerTimesToday.sort((a, b) => a.value.compareTo(b.value));

  // Find the next prayer
  for (var entry in prayerTimesToday) {
    if (now.isBefore(entry.value)) {
      return entry.key; // Return the name of the next prayer
    }
  }

  // If no prayer is left for today, return the first prayer for tomorrow (usually Fajr)
  return prayerTimesToday.first.key;
}

Duration getTimeLeft(Map<String, String> map) {
  String prayer = map[getNextPrayer(map)]!;
  DateTime now = DateTime.now();
  DateFormat format = DateFormat("HH:mm");
  DateTime prayerTime = format.parse(prayer); // Convert time to DateTime
  // Set the date to today
  DateTime prayerDateTime = DateTime(
      now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
  return prayerDateTime.difference(now);
}

String convertTimeTo12HourFormat(String time24) {
  // Create a DateFormat object for parsing 24-hour format
  DateFormat inputFormat = DateFormat("HH:mm");

  // Parse the input string into a DateTime object
  DateTime dateTime = inputFormat.parse(time24);

  // Create a DateFormat object for 12-hour format with AM/PM
  DateFormat outputFormat = DateFormat("hh:mm a");

  // Format the DateTime object to 12-hour format
  return outputFormat.format(dateTime);
}

returnNumberName(String? date) {
  Map<int, String> arabicOrdinals = {
    0: '',
    1: 'الأول',
    2: 'الثاني',
    3: 'الثالث',
    4: 'الرابع',
    5: 'الخامس',
    6: 'السادس',
    7: 'السابع',
    8: 'الثامن',
    9: 'التاسع',
    10: 'العاشر',
    11: 'الحادي عشر',
    12: 'الثاني عشر',
    13: 'الثالث عشر',
    14: 'الرابع عشر',
    15: 'الخامس عشر',
    16: 'السادس عشر',
    17: 'السابع عشر',
    18: 'الثامن عشر',
    19: 'التاسع عشر',
    20: 'العشرون',
    21: 'الحادي والعشرون',
    22: 'الثاني والعشرون',
    23: 'الثالث والعشرون',
    24: 'الرابع والعشرون',
    25: 'الخامس والعشرون',
    26: 'السادس والعشرون',
    27: 'السابع والعشرون',
    28: 'الثامن والعشرون',
    29: 'التاسع والعشرون',
    30: 'الثلاثون',
  };
  if (date == '') return '';
  return arabicOrdinals[int.parse((date?.split('-').first) ?? '0')] ?? '';
}

AlarmSettings returnAlarmSettings(int id, String time) {
  final now = DateTime.now();
  DateFormat format = DateFormat("HH:mm");
  DateTime prayerTime = format.parse(time);
  return AlarmSettings(
    id: id,
    dateTime: DateTime(
        now.year, now.month, now.day, prayerTime.hour, prayerTime.minute - 5),
    assetAudioPath: 'assets/azan.mp3',
    loopAudio: true,
    vibrate: true,
    volume: 1,
    notificationSettings: const NotificationSettings(
      title: 'فاضل خمس دقايق',
      body: '',
      stopButton: 'تمام',
      icon: 'notification_icon',
    ),
  );
}
