import 'package:flutter/material.dart';
import 'package:note_app/utils/color_constants.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.cardColor,
    this.onEdit,
    this.onDelete,
    this.onShare,
  });

  final String title;
  final String description;
  final String date;
  final Color cardColor;
  final void Function()? onEdit;
  final void Function()? onDelete;
  final void Function()? onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            cardColor, // card color added through data passing from constructor.
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                title,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: ColorConstants.appBarFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit,
                  color: ColorConstants.appBarFont,
                ),
              ),
              IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: ColorConstants.appBarFont,
                  )),
            ],
          ),
          SizedBox(height: 10),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: ColorConstants.appBarFont,
              fontSize: 15,
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
                  color: ColorConstants.appBarFont,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.6,
                ),
              ),
              SizedBox(width: 7),
              IconButton(
                onPressed: onShare,
                icon: Icon(
                  Icons.share,
                  color: ColorConstants.appBarFont,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
