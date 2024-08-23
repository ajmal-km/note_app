import 'package:flutter/material.dart';
import 'package:note_app/utils/color_constants.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({
    super.key,
    required this.noteTitle,
    required this.description,
    required this.date,
    required this.appBarColor,
    this.onDelete,
  });

  final String noteTitle;
  final String description;
  final String date;
  final Color appBarColor;
  final void Function()? onDelete;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isMarked = false;
  @override
  void initState() {
    titleController.text = widget.noteTitle;
    descriptionController.text = widget.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBlack,
      appBar: _buildAppBarSection(context),
      body: _buildNoteDetailedViewSection(),
    );
  }

  Widget _buildNoteDetailedViewSection() {
    return Padding(
      padding: const EdgeInsets.all(13),
      child: Column(
        children: <Widget>[
          TextField(
            controller: titleController,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            cursorColor: ColorConstants.mainRed,
            cursorWidth: 3,
            style: TextStyle(
              color: ColorConstants.fontColor,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
            decoration: InputDecoration(
              hintText: "Title",
              hintStyle: TextStyle(
                color: ColorConstants.fontColor,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.date,
                    style: TextStyle(
                      color: ColorConstants.greyFont,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 16,
                    child: VerticalDivider(
                      color: ColorConstants.fontColor,
                      width: 1.3,
                      thickness: 1.3,
                    ),
                  ),
                ),
                Text(
                  "${widget.description.length} characters",
                  style: TextStyle(
                    color: ColorConstants.greyFont,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    //
                  },
                  controller: descriptionController,
                  maxLines: 24,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: TextStyle(
                    color: ColorConstants.fontColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                  cursorColor: ColorConstants.mainRed,
                  cursorWidth: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBarSection(BuildContext context) {
    return AppBar(
      backgroundColor: widget.appBarColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: ColorConstants.fontColor,
        icon: Icon(Icons.arrow_back_ios),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          color: ColorConstants.fontColor,
          icon: Icon(
            isMarked ? Icons.bookmark : Icons.bookmark_border,
          ),
        ),
        IconButton(
          onPressed: widget.onDelete,
          icon: Icon(
            Icons.delete,
            color: ColorConstants.fontColor,
          ),
        ),
        SizedBox(width: 6),
      ],
    );
  }
}
