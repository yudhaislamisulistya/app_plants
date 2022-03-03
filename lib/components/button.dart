import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String btnText;
  final dynamic onClick;
  IconData? icon;

  AppButton({required this.btnText, required this.onClick, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (onClick),
      child: Container(
        width: MediaQuery.of(context).size.width - 260,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xff297F87),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Icon(icon, color: Colors.white,),
            Text(
              btnText,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
class ListContent extends StatelessWidget {
  final String text;
  final dynamic onClick;
  final String imagePath;

  ListContent({required this.text, required this.onClick, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      child: ListTile(
        leading: Image.asset(imagePath, width: 50, height: 50,fit: BoxFit.fill,),
        title: Text(text, style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white
        ),),
      ),
    );
  }
}
