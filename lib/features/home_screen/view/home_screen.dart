import 'package:flutter/material.dart';
import 'package:weatherapp/Repository/weather_repository.dart';
import 'package:weatherapp/shared/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Hello Arian,",
                style: baseStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "Discover the weather",
                style: baseStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              FutureBuilder(
                  future: WeatherRepository().fetchCurrentWeather(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data?.error != null) {
                      return Text(snapshot.data?.error ??
                          "Emabinu.... No weather data");
                    }
                    return WeatherCard(
                      location: snapshot.data?.model?.name ?? "",
                      temp: snapshot.data?.model?.main?.temp ?? 0,
                      weatherType: snapshot
                              .data?.model?.weather?.firstOrNull?.description ??
                          "",
                    );
                  })
            ],
          ),
        ),
      ),
    ));
  }
}

class WeatherCard extends StatelessWidget {
  const WeatherCard(
      {super.key,
      required this.location,
      required this.temp,
      required this.weatherType});

  final String location;
  final String weatherType;
  final num temp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.purple,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current location",
                  style: baseStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  location,
                  style: baseStyle.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  weatherType,
                  style: baseStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [Text(temp.toString())],
          )
        ],
      ),
    );
  }
}
