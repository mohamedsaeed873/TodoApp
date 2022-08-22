import 'package:flutter/material.dart';

class DefuldFormFild extends StatelessWidget {

String? hint,labeltext;
IconData? iconData;
TextInputType? keyboardType;
TextEditingController? controller;
void Function()? tab;
String? Function(String?)? validator;

DefuldFormFild({required this.hint,required this.labeltext,required this.iconData,required this.keyboardType,required this.controller,required this.tab , this.validator});


  @override
  Widget build(BuildContext context) {
    return  TextFormField(
                onTap: tab,
                validator: validator,
                keyboardType: TextInputType.text,
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: hint,
                  label:Text("$labeltext"),
                  prefixIcon:  Icon(iconData),
          
                ),
              );
  }
}