import 'package:flutter/material.dart';
import 'package:note_app/utils/color_constants.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.onEdit,
    this.onDelete,
    
  });

  final String title;
  final String description;
  final String date;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorConstants.mainRed,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: ColorConstants.fontColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit,
                  color: ColorConstants.fontColor,
                ),
              ),
              IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: ColorConstants.fontColor,
                  )),
            ],
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              color: ColorConstants.fontColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                date,
                style: TextStyle(
                  color: ColorConstants.fontColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.6,
                ),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.share,
                color: ColorConstants.fontColor,
                size: 23,
              ),
            ],
          )
        ],
      ),
    );
  }
}
