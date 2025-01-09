import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weatherapp/Repository/weather_repository.dart';
import 'package:weatherapp/models/weather_models.dart';
import 'package:weatherapp/services/location_services/location_service.dart';
import 'package:weatherapp/shared/assets.dart';
import 'package:weatherapp/shared/constant.dart';
import 'package:weatherapp/shared/routes/route_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final locationService = LocationService();

  LocationData? currentLocation;
 late String? searchedCity;

  void setLocation() async {
    currentLocation = await locationService.getLocation();
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setLocation();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          bottom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    "Hello Arian,",
                    style: baseStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                      onPressed: ()async{
                        searchedCity = await Navigator.pushNamed(
                            context,
                           AppRouteStrings.searchScreen
                        );
                      },
                      icon: const Icon(Icons.search, color: AppColors.purple,)
                  )
                ],
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
                  future: WeatherRepository().fetchCurrentWeather(
                      lat: currentLocation?.latitude,
                      lon: currentLocation?.longitude),
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
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Text(
                  "Around the world",
                  style: baseStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              FutureBuilder(
                  future: WeatherRepository()
                      .fetchCurrentWeather(lat: 45.50884, lon: -73.58781),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data?.error != null) {
                      return Text(snapshot.data?.error ??
                          "Emabinu.... No weather data");
                    }
                    return WeatherCard(
                      country: snapshot.data?.model?.sys?.country ?? "",
                      location: snapshot.data?.model?.name ?? "",
                      temp: snapshot.data?.model?.main?.temp ?? 0,
                      weatherType: snapshot
                              .data?.model?.weather?.firstOrNull?.description ??
                          "",
                    );
                  }),
              const SizedBox(height: 12,),
              FutureBuilder(
                future: WeatherRepository().fetchCurrentWeather(lat: 39.9042, lon: 116.4074),
                builder: (BuildContext context,  snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(),);
                  }
                  if(snapshot.data?.error != null){
                    return Text(snapshot.data?.error ?? "Sorry..No Weather Data");
                  }
                  return WeatherCard(
                      country: snapshot.data?.model?.sys?.country ?? "",
                      location: snapshot.data?.model?.name?? "",
                      temp: snapshot.data?.model?.main?.temp ??0,
                      weatherType: snapshot.data?.model?.weather?.firstOrNull?.description ?? ''
                  );
                },

              ),
              const SizedBox(height: 12,),
              FutureBuilder(
                  future: WeatherRepository().fetchCurrentWeather(lat: 55.7558 , lon: 37.6173 ),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    if(snapshot.data?.error != null){
                      return Text(snapshot.data?.error ?? "Sorry no Weather data");
                    }
                    return WeatherCard(
                        country: snapshot.data?.model?.sys?.country ?? "",
                        location: snapshot.data?.model?.name ?? "",
                        temp: snapshot.data?.model?.main?.temp ?? 0,
                        weatherType: snapshot.data?.model?.weather?.firstOrNull?.description ?? ""
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
      required this.weatherType,
      this.country});

  final String location;
  final String weatherType;
  final num temp;
  final String? country;

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
                  country ?? "Current location",
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
            children: [
              Image.asset(
                temp > 20
                    ? AppAssets.sunnyPng
                    : temp > 5 && temp < 15
                        ? AppAssets.drizzlingPng
                        : temp < 0
                            ? AppAssets.snowPng
                            : AppAssets.stormyPng,
                height: 100,
                width: 100,
              ),
              Text(
                "${temp.toInt().toString()}℃",
                style: baseStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
