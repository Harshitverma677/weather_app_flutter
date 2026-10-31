import 'package:flutter/material.dart';


class AditionalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AditionalInfo({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon,size: 40,),
        SizedBox(height: 8,),
        Text(label,style: TextStyle(
          fontSize: 15,
        ),),
        Text(value,style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),)
      ],
    );
  }
}