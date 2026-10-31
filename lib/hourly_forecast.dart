import 'package:flutter/material.dart';

class Hourlyforecast extends StatelessWidget {
  final String time;
  final String temp;
  final IconData weather;
  const Hourlyforecast({
    required this.time,
    required this.temp,
    required this.weather,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return Card(
                      elevation: 10,
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Column(
                          children: [
                            Text(time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),),
                            SizedBox(height: 8,),
                            Icon(weather,size: 35,),
                            SizedBox(height: 8,),
                            Text(temp,style: TextStyle(
                              fontSize: 16,
                            ),),
                            
                          ],
                        ),
                      ),
                    );
  }
}