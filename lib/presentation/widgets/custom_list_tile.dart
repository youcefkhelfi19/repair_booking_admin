import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key, required this.title, this.trailing, required this.subtitle,
  }) : super(key: key);
  final String title ;
  final String subtitle ;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin:  const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}
