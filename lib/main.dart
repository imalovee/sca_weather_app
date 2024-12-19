import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/shared/routes/route_strings.dart';
import 'package:weatherapp/shared/routes/router.dart';

void main() async {
  ///Figma link: https://www.figma.com/design/LpqCQZ7D625SHOtoTZ6VDy/Ideate-Design---Weather-app-(Community)?node-id=102-7&t=423TrESatD6gwN9u-1
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: AppRouter.navKey,
      initialRoute: AppRouteStrings.base,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
