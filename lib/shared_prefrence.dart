import 'package:prayer/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrenceHelper {
  static const String dateKey = 'date';
  static const String monthKey = 'month';
  static const String cityKey = 'city';
  static const String weekDayKey = 'weekDay';
  static const String yearKey = 'year';
  static const String fajrKey = 'fajr';
  static const String duhrKey = 'duhr';
  static const String asrKey = 'asr';
  static const String maghribKey = 'maghrib';
  static const String ishaKey = 'isha';
  static const String firstThirdKey = 'firstThird';
  static const String lastThirdKey = 'lastThird';
  static const String sunRiseKey = 'sunRise';
  static const String midnightKey = 'midnight';
  static const String currntDayKey = 'currntDay';

  static Future<void> saveLocalData(TimesModel? data) async {
    DateTime now = DateTime.now();
    String currntDayy =
        now.year.toString() + now.month.toString() + now.day.toString();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(dateKey, data?.data?.date?.hijri?.date ?? '');
    await prefs.setString(monthKey, data?.data?.date?.hijri?.month?.ar ?? '');
    await prefs.setInt(yearKey, data?.data?.date?.hijri?.year ?? 0);
    await prefs.setString(
        cityKey, (data?.data?.meta?.timezone ?? '').split('/').last);
    await prefs.setString(
        weekDayKey, (data?.data?.date?.hijri?.weekday?.ar ?? ''));
    await prefs.setString(fajrKey, data?.data?.timings?.fajr ?? '');
    await prefs.setString(sunRiseKey, data?.data?.timings?.sunrise ?? '');
    await prefs.setString(duhrKey, data?.data?.timings?.dhuhr ?? '');
    await prefs.setString(asrKey, data?.data?.timings?.asr ?? '');
    await prefs.setString(maghribKey, data?.data?.timings?.maghrib ?? '');
    await prefs.setString(ishaKey, data?.data?.timings?.isha ?? '');
    await prefs.setString(midnightKey, data?.data?.timings?.midnight ?? '');
    await prefs.setString(firstThirdKey, data?.data?.timings?.firstthird ?? '');
    await prefs.setString(lastThirdKey, data?.data?.timings?.lastthird ?? '');
    await prefs.setString(currntDayKey, currntDayy);
  }

  static Future<LocalModel> getLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve values from SharedPreferences
    String date = prefs.getString(dateKey) ?? '';
    String month = prefs.getString(monthKey) ?? '';
    String city = prefs.getString(cityKey) ?? '';
    String weekDay = prefs.getString(weekDayKey) ?? '';
    int year = prefs.getInt(yearKey) ?? 0;
    String fajr = prefs.getString(fajrKey) ?? '';
    String duhr = prefs.getString(duhrKey) ?? '';
    String asr = prefs.getString(asrKey) ?? '';
    String maghrib = prefs.getString(maghribKey) ?? '';
    String isha = prefs.getString(ishaKey) ?? '';
    String firstThird = prefs.getString(firstThirdKey) ?? '';
    String lastThird = prefs.getString(lastThirdKey) ?? '';
    String sunRise = prefs.getString(sunRiseKey) ?? '';
    String midnight = prefs.getString(midnightKey) ?? '';
    String currntDay = prefs.getString(currntDayKey) ?? '';

    // Return a LocalModel instance with the retrieved data
    return LocalModel(
      date: date,
      month: month,
      city: city,
      weekDay: weekDay,
      year: year,
      fajr: fajr,
      duhr: duhr,
      asr: asr,
      maghrib: maghrib,
      isha: isha,
      firstThird: firstThird,
      lastThird: lastThird,
      sunRise: sunRise,
      midnight: midnight,
      currntDay: currntDay,
    );
  }
}
