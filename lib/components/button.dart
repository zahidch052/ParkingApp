import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkingapp/utilities/constants.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final Function onClick;

  CommonButton({required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 00.0),
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Container(
          height: 50.0,
          width: double.infinity,
          margin: EdgeInsets.only(left: 25.0, right: 25.0),
          decoration: BoxDecoration(
            color: kTealBasic,
            borderRadius: BorderRadius.circular(22.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}
