import 'package:flutter/cupertino.dart';
import 'package:weatherapp/features/home_screen/view/home_screen.dart';
import 'package:weatherapp/features/search_screen/search_screen.dart';
import 'package:weatherapp/features/weather_details/weather_details_screen.dart';
import 'package:weatherapp/shared/routes/route_strings.dart';

class AppRouter {
  static final navKey = GlobalKey<NavigatorState>();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteStrings.base:
        return CupertinoPageRoute(builder: (_) => const HomeScreen());
      case AppRouteStrings.homeScreen:
        return CupertinoPageRoute(builder: (_) => const HomeScreen());
      case AppRouteStrings.weatherDetailsScreen:
        return CupertinoPageRoute(builder: (_) => const WeatherDetailsScreen());
      case AppRouteStrings.searchScreen:
        return CupertinoPageRoute(builder: (_) => const SearchScreen());

      default:
        return CupertinoPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
