import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weatherapp/Repository/weather_repository.dart';
import 'package:weatherapp/features/home_screen/view/home_screen.dart';
import 'package:weatherapp/models/weather_models.dart';
import 'package:weatherapp/services/location_services/location_service.dart';
import 'package:weatherapp/shared/constant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repo = WeatherRepository();
  TextEditingController  _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
   bool isTextEnabled = true;

  // final _locationService = LocationService();
  // LocationData? _currentLocation;
  // Future<({String? error, WeatherData? model})>? _currentWeatherFuture;

  bool isSearchActive = false;
  bool _showOverlay = false;

  final List<WeatherData> weatherDataList = [];

  Future<void> _searchCityWeather (String cityname)async{
    try {
      final weatherdata = await _repo.fetchCityWeather(cityName: cityname);
    if(weatherdata != null && weatherdata.error == null){
      setState(() {
        weatherDataList.insert(0, weatherdata.model!);
     
        isSearchActive = true;
      });
         print(weatherDataList); 

    }else{
      ScaffoldMessenger.of(context).showSnackBar
      ( SnackBar(content: Text(weatherdata.error ??  'An error ocurred while fetching')));
    }
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar
      (const SnackBar(content: Text('An error ocurred while fetching')));
    }
  }

  void _deleteWeatherCard(int index) {
  setState(() {
    weatherDataList.removeAt(index);
  });
}

  // Future<void> _fetchCityWeather({required String cityname})async{
  //     setState(() {
  //       isSearchActive = true;
  //      _currentWeatherFuture =  _repo.fetchCityWeather(cityName: cityname);
  //     });
  // }
  // WeatherData _dataList = [];

  // void _setLocation ()async{
  //     _currentLocation = await _locationService.getLocation();
  //     setState(() {
        
  //     });
  // }

  void enableTextField(){
    setState(() {
      isTextEnabled = true;
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void initState(){
    super.initState();
    _focusNode.addListener((){
      if(! _focusNode.hasFocus){
        setState(() {
          isTextEnabled = false;
        });
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   _setLocation();
    // });
  }

   @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Stack(
        children: [
         
      Scaffold(
        appBar: AppBar(
          title: Text('Search Cities'),
      
        ),
        body:  Padding(padding:const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Manage Cities',
                // style: baseStyle.copyWith(
                //       fontSize: 20,
                //       fontWeight: FontWeight.w400,
                //     ),),
                 Row(
                   children: [
      
                     Expanded(
                       child: TextField(
                        focusNode: _focusNode,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          hintText: 'Enter City name ',
                          hintStyle: baseStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                          ),
                          prefixIcon:  Icon(Icons.search, color: AppColors.purple,),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.purple,
                          
                            )
                          )
                        ),
                        onSubmitted: (value){
                          _searchCityWeather(value);
                        },
                        controller: _controller ,
                       ),
                     ),
                     SizedBox(width: 9,),
                     TextButton(onPressed: (){
                     _searchCityWeather(_controller.text);
                      _controller.clear();
                      enableTextField();
                     },
                      child: Text('Enter'))
                   ],
                 ),
                 SizedBox(height: 19,) ,
                  // FutureBuilder(
                  // future: _repo.fetchCurrentWeather(
                  //   lat: _currentLocation?.latitude,
                  //   lon: _currentLocation?.longitude
                  // ), 
                  // builder: (context, snapshot){
                  //   if(snapshot.connectionState == ConnectionState.waiting){
                  //     return const Center(child: CircularProgressIndicator(
                  //       valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
                  //     ),);
                  //   }
                  //   else if(snapshot.hasError){
                  //     return Text('Could not fetch City weather');
                  //   }
                  //   else if(snapshot.data?.error != null){
                  //     return Text(snapshot.data?.error ?? "Could not fetch city weather");
                  //   }
                  //   return WeatherCard(
                  //     location: snapshot.data?.model?.name ?? "",
                  //      temp: snapshot.data?.model?.main?.temp ?? 0, 
                  //      weatherType: snapshot.data?.model?.weather?.firstOrNull?.description ?? ""
                  //      );
                  // }) ,
                 
                  // const SizedBox(
                  //   height: 20,
                  // ) ,
                  if(isSearchActive)
                  SizedBox(
                    height: 700,
                    child: ListView.separated(
                       physics: NeverScrollableScrollPhysics(), 
                      itemCount: weatherDataList.length,
                      itemBuilder: (context, index){
                        final data = weatherDataList[index];
                        return GestureDetector(
                          onTap: () {
                            _alertBox(index);
                          },
                          child: WeatherCard(
                            country: data.sys?.country,
                            location: data.name ?? "", 
                            temp: data.main?.temp ?? 0, 
                            weatherType: data.weather?.firstOrNull?.description ?? ""
                            ),
                        );
                      }, separatorBuilder: (BuildContext context, int index) { 
                       return SizedBox(height: 15,);
                       },
                      ))
                      else
        const Center(child: Text('Search for a city to display weather',
        style: TextStyle(
      fontSize: 16
        ),))
                //  FutureBuilder(
                //   future: _currentWeatherFuture, 
                //   builder: (context, snapshot){
                //     if(snapshot.connectionState == ConnectionState.waiting){
                //       return const Center(child: CircularProgressIndicator(
                //         valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
                //       ),);
                //     }
                //     else if(snapshot.hasError){
                //       return Text('Could not fetch City weather');
                //     }
                //     else if(snapshot.data?.error != null){
                //       return Text(snapshot.data?.error ?? "Could not fetch city weather");
                //     }
                //     return WeatherCard(
                //       country: snapshot.data?.model?.sys?.country,
                //       location: snapshot.data?.model?.name ?? "",
                //        temp: snapshot.data?.model?.main?.temp ?? 0, 
                //        weatherType: snapshot.data?.model?.weather?.firstOrNull?.description ?? ""
                //        );
                //   })  
              ],
            ),
        ),),
      ),
      if (_showOverlay)
            Container(
              color: Colors.red.withOpacity(0.4), // Semi-transparent red overlay
            ),
      ]),
    );
  }

    void _alertBox(index) async {
    setState(() {
      _showOverlay = true; // Show the red overlay
    });
   await showDialog(context: context,
        builder: (builder) {
          return AlertDialog(
            icon: const Icon(
              Icons.delete, color: AppColors.appRed,),
            title: const Text('Delete Document', style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),
              textAlign: TextAlign.start,),
            content: const Text(
                'Are you sure you want to delete all the notifications? This action cannot be undone.'),
            contentTextStyle: const TextStyle(
              color: Colors.black26,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),

                        decoration: const BoxDecoration(
                            color: Colors.white
                        ),
                        child: const Text('Cancel', style: TextStyle(
                          color: Colors.black,
                        ),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _deleteWeatherCard(index);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),

                        decoration: const BoxDecoration(
                            color: AppColors.appRed
                        ),
                        child: const Text('Delete', style: TextStyle(
                          color: Colors.white,
                        ),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      setState(() {
      _showOverlay = false; // Show the red overlay
    });
}
}