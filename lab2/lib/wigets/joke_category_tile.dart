import 'package:flutter/material.dart';

class JokeCategoryTile extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const JokeCategoryTile({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0), 
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[50], 
            borderRadius: BorderRadius.circular(15.0), 
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            leading: Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.blueAccent, 
              size: 40.0, 
            ),
            title: Text(
              category,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold, 
                color: Colors.black87, 
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
              size: 28.0, 
            ),
          ),
        ),
      ),
    );
  }
}
