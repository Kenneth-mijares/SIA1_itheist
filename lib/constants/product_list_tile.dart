// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MinimalistListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailingText;
  final VoidCallback onTap;
  final VoidCallback onUpdateInfo;
  final VoidCallback onDelete; 
  final VoidCallback onRestock;

  const MinimalistListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailingText,
    required this.onTap,
    required this.onUpdateInfo,
    required this.onDelete,
    required this.onRestock, // Add to constructor

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            Text(
              trailingText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: Row( // Buttons on the right
          mainAxisSize: MainAxisSize.min, // Keep the row as small as possible
          children: [
           ElevatedButton(
              onPressed: onUpdateInfo,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding as needed
                textStyle: TextStyle(fontSize: 12), // Adjust font size as needed
              ),
              child: Text('Update Info'),
            ),
            SizedBox(width: 8), // Add spacing between buttons
            ElevatedButton(
              onPressed: onRestock,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: TextStyle(fontSize: 12),
              ),
              child: Text('Restock'),
            ),

            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete_forever, size: 27, color: Colors.red,),
            )
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
