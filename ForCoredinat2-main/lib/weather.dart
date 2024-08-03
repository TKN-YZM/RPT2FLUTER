import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherFactory _wf = WeatherFactory("d2206abfc7166e5b8849c3c1ee6cc78c");
  Weather? _weatherToday;
  Weather? _weatherTomorrow;
  String _city = "Konya";
  List<Weather>? _weatherForFiveDays;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting("tr_TR").then((_) {
      _fetchWeather();
    });
  }

  Future<void> _fetchWeather() async {
    // Fetch today's weather
    Weather weatherToday = await _wf.currentWeatherByCityName(_city);
    List<Weather> forecast = [];
    // Fetch forecast for the next 5 days
    await _wf.fiveDayForecastByCityName(_city).then((data) {
      data.forEach(
        (element) {
          if (!(element.date.toString().contains("21:00:00.000"))) {
            debugPrint("--" + element.date.toString());
          } else {
            forecast.add(element);
          }
        },
      );
    });

    setState(() {
      _weatherToday = weatherToday;
      _weatherForFiveDays = forecast;
      _weatherTomorrow = forecast[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white24,
          elevation: 0,
        ),
        body: _buildStructure(),
      ),
    );
  }

  Widget _buildStructure() {
    return _weatherToday == null || _weatherForFiveDays == null
        ? const Center(
            child: Text("Veri yok"),
          )
        : SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _locationHeader(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.08,
                ),
                _dateTimeInfo(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.05,
                ),
                _weatherIcon(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                _currentTemp(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
              ],
            ),
          );
  }

  // Şehir ismi & şehir değiştirme
  Widget _locationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          (_weatherToday?.areaName?.split(" ")[0]) ?? "",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
            onPressed: () {
              _showDialog(context);
            },
            child: const Text("Şehir Değiştir"))
      ],
    );
  }

  // Tarih & saat
  Widget _dateTimeInfo() {
    DateTime now = _weatherToday!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a", "tr_TR").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _daySelector(),
          ],
        ),
      ],
    );
  }

  // Hava iconu
  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weatherTomorrow?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _translateWeatherDescription(
              _weatherTomorrow?.weatherDescription ?? ""),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  // Sıcaklık
  Widget _currentTemp() {
    return Text(
      "${_weatherTomorrow?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Yeni görev & event ekleme işlemleri
  Future<void> _showDialog(BuildContext context) {
    final myController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Weather App'),
          content: TextField(
            decoration: const InputDecoration(
                hintText: "Şehir Ekle", border: InputBorder.none),
            controller: myController,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ekle'),
              onPressed: () async {
                _city = myController.text;
                await _fetchWeather();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Vazgeç'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _translateWeatherDescription(String description) {
    switch (description.toLowerCase()) {
      case "clear sky":
        return "Açık";
      case "light rain":
        return "Hafif yapmurlu";
      case "few clouds":
        return "Az Bulutlu";
      case "scattered clouds":
        return "Parçalı Bulutlu";
      case "broken clouds":
        return "Çok Bulutlu";
      case "shower rain":
        return "Sağanak Yağışlı";
      case "rain":
        return "Yağmurlu";
      case "thunderstorm":
        return "Gök Gürültülü Fırtına";
      case "snow":
        return "Karlı";
      case "mist":
        return "Sisli";
      default:
        return description;
    }
  }

  Widget _daySelector() {
    List<DateTime> uniqueDates =
        _weatherForFiveDays!.map((weather) => weather.date!).toSet().toList();

    return DropdownButton<DateTime>(
      icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      dropdownColor: Colors.white,
      elevation: 0,
      value: _weatherTomorrow?.date,
      items: uniqueDates.map((date) {
        return DropdownMenuItem<DateTime>(
          value: date,
          child: Text(DateFormat("EEEE", "tr_TR").format(date)),
        );
      }).toList(),
      onChanged: (DateTime? newDate) {
        setState(() {
          _weatherTomorrow = _weatherForFiveDays!
              .firstWhere((weather) => weather.date == newDate);
        });
      },
    );
  }
}
