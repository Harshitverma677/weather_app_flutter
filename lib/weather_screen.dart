import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/hourly_forecast.dart' show Hourlyforecast;
import 'package:weather_app/additional_info.dart' show AditionalInfo;
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
 
  Future<Map<String,dynamic>>getrealweather() async{
    try{
       String cityname = 'Spain';
    final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$weatherAPI',
    ));
    
    final data = jsonDecode(res.body);
    if(data['cod']!='200'){
      throw 'unexpected error occur';
    }
    return data;
    }
    catch(e){
      throw e.toString();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Weather App',
        style: TextStyle(
          fontWeight: FontWeight.bold
          ),
          ),
        centerTitle: true,
        actions: [
          IconButton(onPressed:() {
            setState(() {});
          }, 
          icon: Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getrealweather(),
        builder: (context, asyncSnapshot) {
          if(asyncSnapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if(asyncSnapshot.hasError){
            return Center(child: Text(asyncSnapshot.error.toString()));
          }
          final data = asyncSnapshot.data!;
          final currenttemp = data['list'][0]['main']['temp'];
          final currentsky = data['list'][0]['weather'][0]['main'];
          final humidity = data['list'][0]['main']['humidity'];
          final pressure = data['list'][0]['main']['pressure'];
          final windspeed = data['list'][0]['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('$currenttemp K',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(height: 16),
                          Icon(
                            currentsky=='Clouds' || currentsky=='Rain' ? Icons.cloud: Icons.sunny,
                          size: 70,),
                          SizedBox(height: 16),
                          Text('$currentsky',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text('Hourly Forecast',style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 20),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for(int i=0;i<5;i++)
                  //       Hourlyforecast(
                  //         time: data['list'][i+1]['dt'].toString(),
                  //         temp: data['list'][i+1]['main']['temp'].toString(),
                  //         weather: data['list'][i+1]['weather'][0]['main']=='Clouds' || data['list'][i+1]['weather'][0]['main']=='Rain' ? Icons.cloud: Icons.sunny,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context,index){
                        //final hourlytime = data['list'][index+1]['dt'].toString();
                        final hourlytemp = data['list'][index+1]['main']['temp'].toString();
                        final hourlyweather = data['list'][index+1]['weather'][0]['main'];
                        final hourlytime = DateTime.parse(data['list'][index+1]['dt_txt']);
                        return Hourlyforecast(
                          time: DateFormat.j().format(hourlytime),
                          temp: hourlytemp,
                          weather: hourlyweather=='Clouds' || hourlyweather=='Rain' ? Icons.cloud: Icons.sunny,
                          );
                      },
                  )
                  ),
                
                SizedBox(height: 20,),
                Text('Additional information',style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AditionalInfo(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '$humidity',
                      ),
                      AditionalInfo(
                        icon: Icons.air,
                        label: 'Wind speed',
                        value: '$windspeed',
                      ),
                     AditionalInfo(
                      icon: Icons.beach_access,
                        label: 'Pressure',
                        value: '$pressure',
                     ),
                    ]
                  ),
                )
                
              ],
            ),
          );
        }
      ),
    );
  }
}

